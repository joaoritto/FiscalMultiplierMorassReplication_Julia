## Preparation for Metropolis-Hastings Algorithm
# Please have "data.mat" (from Leeper's replication folder) in the current directory

## Load Data
function get_data(d1d,d2d,USdata) # correspond to "get_data" in Leeper
        # Find the row of d1d and d2d
        d1 = findall(x -> x == d1d, USdata[:,16])
        d2 = findall(x -> x == d2d, USdata[:,16])
        d1 = d1[1]; d2 = d2[1]; # Array => Scalar

        # Take out Relevant Data
        C  = USdata[d1:d2, 1]
        I  = USdata[d1:d2,2]
        L  = USdata[d1:d2,4]
        GC = USdata[d1:d2,5]
        B  = USdata[d1:d2,9]
        Pi = USdata[d1:d2,10]
        w  = USdata[d1:d2,11]
        R  = USdata[d1:d2,12]

        # Combine into an array
        final_data = [C I w GC B L Pi R]
        return final_data
end

using MAT
cd(path)
file1  = read(matopen("data.mat")) # load data
USdata = file1["data"]             # extract array from the loaded data

d1d      = 1955.1;        # first quarter in estimation
d2d      = 2007.4;        # last quarter in estimation
obsdata = get_data(d1d,d2d,USdata)

## Create a vector of standard deviations from Prior Distributions
num_estimpara=43


Σ0=Diagonal([0.05/100,0.5,0.2,0.1,1.01,0.15,1.5,0.2,0.2,0.2,0.2, # χ_w
        0.2,0.15,0.05,0.2,0.1,0.1,0.1,0.1,0.001,0.001,0.001,0.001,# γ_ZF
        0.2,0.2,0.2,0.2, 0.2,0.2,0.2,0.2,0.2, 0.15,0.15,0.15, # ρ_ez
        1/100,1/100,1/100,1/100, 1/100,1/100,1/100,1/100].^2)

## Function for Metropolis-Hastings Algorithm

function myMH(model, simlen, cc, initialdraw, Σ,  obsdata   )
        ## Take the "estimpararestric, regime, subsorcompl"
        # Specify the Model
        current_model = model
        # Apply the function "modelrestrictions"
        calibpara0=calibratedpara();
        estimpara00=DrawParaFromPrior()
        calibpara,estimpara,calibpararestric,estimpararestric,regime,subsorcompl =
                     modelrestrictions(current_model,calibpara0,estimpara00)
        # global regime

        ## Array to Store the Parameters drawn
        para_drawn = [zeros(size(Σ,1)) for i = 1:simlen]

        priorcount = 0; acceptcount = 0; postlast = -1e12;

        ## Initial Value
        # Just Draw from the Prior Distribution
        lastdraw = initialdraw

        # Cholesky decomposition
        P=factorize(Σ)


        ## Start the Algorithm
         for ii = 1:simlen

        # Draw a candidate by θ = θ^{i-1} + η, where η ∼ N(0,c²Σ)
        cand_draw = lastdraw + cc*P* randn(size(Σ,1))

                # checks if ant σ parameters are negative
                # Otherwise, evaluate the densities of candidate parameters
                cand_σ_sign = prod(cand_draw[end-7:end] .> 0) # false if any of σ is negative
                if cand_σ_sign== false
                        cand_density = zeros(length(vSD))
                 println("false (σ_sign)")
                else
                # Evaluate the Densities
                cand_pdf1     = ParaDensity(cand_draw ) # Evaluate the Density
                cand_density  = JointDensities(cand_pdf1 , # Replace the irrelevant density by 1
                                               estimpararestric, regime, subsorcompl)
                end

                # If we want, we could keep drawing until cand_density_positive == true
                # with "while" loop. But Leeper et al. didn't do so.
                # cand_density_positive = prod(cand_density) > 1e-15
                # println([prod(cand_density), prod(cand_draw[end-7:end])])

                if prod(cand_density) < 1e-15
                          priorcount  = priorcount + 1  # number of rejection
                          lastdraw    = lastdraw        # keep the last draw

                else # density of the draw is not zero
                        " Solve the model + Evaluate the Likelihood"
                        # Structural Model
                       calibpara,estimpara,calibparar,estimparar,regime,subsorcompl=
                               modelrestrictions(current_model,calibpara0,cand_draw)
                       Γ_0, Γ_1, constant, Ψ, Π = linearizedmodel(calibpara,estimpara,regime,path)

                       # Express in State-Space Form
                       G1, C, impact, qt, a, b, z, eu=mygensys(Γ_0,Γ_1,constant,Ψ,Π)
                       T, R, Q, Z, H, W=statespacematrices(G1,C,impact,estimpara,path)

                       # Evaluate the Likelihood
                       candlike = myKalmanLogLikelihood(T,R,Q,Z,H,W,obsdata)
                       postcand = log(prod(cand_density)) + candlike
                       println(candlike)

                       " Accept if likelihood is high enough"
                       if min( exp(postcand - postlast),1) > rand()
                                 acceptcount = acceptcount + 1 # nember of acceptance
                                 lastdraw    = cand_draw       # replace with the new draw
                                 postlast    = postcand        # likelihood of the new draw
                       else
                                 priorcount  = priorcount + 1  # number of rejection
                                 lastdraw    = lastdraw        # keep the current draw
                       end

                end

                para_drawn[ii] =  lastdraw
                println("Accept:", acceptcount,", Reject:", priorcount  )

        end
        return para_drawn, acceptcount, priorcount
end

## Implement
simlen = 20  ;model  = 4.2
initialdraw = mean([DrawParaFromPrior() for i=1:100])
cc       = 0.1 # tuned to have acceptance rate 0.2-0.4


para_drawn, acceptcount, priorcount  = myMH(model, simlen, cc, initialdraw, Σ0,  obsdata ) ;

# Summarize the Results
println("Accept:", acceptcount,", Reject:", priorcount  )
mean(para_drawn), std(para_drawn)
