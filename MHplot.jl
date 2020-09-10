## Plot the posterior denisity for each parameters
using SparseArrays
obsdata = USdataobtain(path)

# Given the estimpara0, compute the posterior log-likelihood
function postLikelihood(estimpara0, model, path)

        calibpara0=calibratedpara()

        # Structural Model
        calibpara,estimpara,calibparar,estimparar,regime,subsorcompl=
                       modelrestrictions(model,calibpara0,estimpara0)
        Γ_0s, Γ_1s, constants, Ψs, Πs = linearizedmodel(calibpara,estimpara,regime,path)

        # Recover the dense matrix
        Γ_0 = Matrix(Γ_0s); Γ_1 = Matrix(Γ_1s);
        constant = Vector(constants); Ψ = Matrix(Ψs); Π = Matrix(Πs)

        # Express in State-Space Form
        G1, C, impact, qt, a, b, z, eu=mygensys(Γ_0,Γ_1,constant,Ψ,Π)
        T, R, Q, Z, H, W=statespacematrices(G1,C,impact,estimpara,path)

        # Evaluate the Joint Density of the parameters
        estimpara_pdf1     = ParaDensity(estimpara0 ) # Evaluate the Density
        estimpara_density  = JointDensities(estimpara_pdf1 , # Replace the irrelevant density by 1
                                       estimparar, regime, subsorcompl)

        # Evaluate the Likelihood
        candlike    = myKalmanLogLikelihood(T,R,Q,Z,H,W,obsdata)
        postloglike = log(prod(estimpara_density)) + candlike

        return postloglike
end

# Check if it works okay
# estimpara0=DrawParaFromPrior()
# loglike1  = postLikelihood(estimpara0, model, path)


function vPostLike(whichpara,Ngrid, model, path)
        # Prior Mean
        vPriorMean = [0.4/100, 2.0,0.5,0.3,0.0,0.6,6,0.5,0.5,0.5,0.5,
                1.5,0.5,0.125,0.5,0.15,0.15,0.15,0.15,0,0,0,0, 0.5,0.5,0.5,0.5,
                0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,
                0.1/100,0.1/100,0.1/100,0.1/100,0.1/100,0.1/100,0.1/100,0.1/100]

        # Prior Draw (used to find support)
        PriorDraw = [DrawParaFromPrior() for i=1:1000]

        # Find the Support of the parameter
        paraMatrix = reduce(hcat, PriorDraw)
        paraMax = maximum(paraMatrix[whichpara,:])
        paraMin = minimum(paraMatrix[whichpara,:])

        # Make a sequence
        vPara   = range(paraMin, length = Ngrid, paraMax)
        mPara   = reduce(hcat,[vPriorMean for i = 1:Ngrid])
        mPara[whichpara,:] = vPara

        # Create a vector of Log-Likelihood
        vPostLogLike = zeros(Ngrid)
        for ii = 1:Ngrid
                current_para = mPara[:,ii]
                vPostLogLike[ii] = postLikelihood(current_para, model, path)
        end

        return vPara, vPostLogLike
end

function plotlikelihood(Ngrid, model)
# Make a plot for each parameter from 1 to 43
for whichpara = 1:size(DrawParaFromPrior())[1]

        # Compute the Likelihood
        println("Time to compute log-likelihood $Ngrid times for para $whichpara")
        @time vPara, vPostLogLike = vPostLike(whichpara,Ngrid, model, path)

        # Make a plot and save
        plot(vPara, vPostLogLike, m=:o, leg=false)
        title!("Log-Likelihood with a range of Parameter $whichpara in model $model")
        savefig(path*"plots/plot_para$whichpara.png")
end
end

# Implementation
Ngrid = 20;
plotlikelihood(Ngrid, "5.2")
