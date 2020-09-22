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

function transform_estimpara(regime,cand_draw)
        estimpara=zeros(45)
        if regime=="M"

                estimpara[1]=cand_draw[1]
                estimpara[2]=cand_draw[2]
                estimpara[3]=cand_draw[3]
                estimpara[4]=0.0 # μ
                estimpara[5]=cand_draw[4]
                estimpara[6]=cand_draw[5]
                estimpara[7]=cand_draw[6]
                estimpara[8]=cand_draw[7]
                estimpara[9]=cand_draw[8]
                estimpara[10]=cand_draw[9]
                estimpara[11]=cand_draw[10]
                estimpara[12]=cand_draw[11]
                estimpara[13]=0.0
                estimpara[14]=cand_draw[12]
                estimpara[15]=cand_draw[13]
                estimpara[16]=cand_draw[14]
                estimpara[17]=0.0 # γ_KM
                estimpara[18]=0.0 # γ_LM
                estimpara[19]=cand_draw[15]
                estimpara[20]=0.0
                estimpara[21]=0.0
                estimpara[22]=0.0
                estimpara[23]=0.0
                estimpara[24]=cand_draw[16]
                estimpara[25]=0.0 # ρ_K
                estimpara[26]=0.0 # ρ_L
                estimpara[27]=0.98 # ρ_Z
                estimpara[28]=cand_draw[17]
                estimpara[29]=cand_draw[18]
                estimpara[30]=cand_draw[19]
                estimpara[31]=cand_draw[20]
                estimpara[32]=cand_draw[21]
                estimpara[33]=cand_draw[22]
                estimpara[34]=cand_draw[23]
                estimpara[35]=0.8 # ρ_ez
                estimpara[36]=cand_draw[24]
                estimpara[37]=cand_draw[25]
                estimpara[38]=cand_draw[26]
                estimpara[39]=cand_draw[27]
                estimpara[40]=cand_draw[28]
                estimpara[41]=cand_draw[29]
                estimpara[42]=cand_draw[30]
                estimpara[43]=cand_draw[31]
                estimpara[44]=cand_draw[32]
                estimpara[45]=cand_draw[33]

        else
                estimpara[1]=cand_draw[1]
                estimpara[2]=cand_draw[2]
                estimpara[3]=cand_draw[3]
                estimpara[4]=0.0 # μ
                estimpara[5]=cand_draw[4]
                estimpara[6]=cand_draw[5]
                estimpara[7]=cand_draw[6]
                estimpara[8]=cand_draw[7]
                estimpara[9]=cand_draw[8]
                estimpara[10]=cand_draw[9]
                estimpara[11]=cand_draw[10]
                estimpara[12]=0.0
                estimpara[13]=cand_draw[11]
                estimpara[14]=cand_draw[12]
                estimpara[15]=cand_draw[13]
                estimpara[16]=0.0
                estimpara[17]=0.0
                estimpara[18]=0.0
                estimpara[19]=0.0
                estimpara[20]=cand_draw[14]
                estimpara[21]=0.0
                estimpara[22]=0.0
                estimpara[23]=cand_draw[15]
                estimpara[24]=cand_draw[16]
                estimpara[25]=0.0 # ρ_K
                estimpara[26]=0.0 # ρ_L
                estimpara[27]=cand_draw[17]
                estimpara[28]=cand_draw[18]
                estimpara[29]=cand_draw[19]
                estimpara[30]=cand_draw[20]
                estimpara[31]=cand_draw[21]
                estimpara[32]=cand_draw[22]
                estimpara[33]=cand_draw[23]
                estimpara[34]=cand_draw[24]
                estimpara[35]=cand_draw[25]
                estimpara[36]=cand_draw[26]
                estimpara[37]=cand_draw[27]
                estimpara[38]=cand_draw[28]
                estimpara[39]=cand_draw[29]
                estimpara[40]=cand_draw[30]
                estimpara[41]=cand_draw[31]
                estimpara[42]=cand_draw[32]
                estimpara[43]=cand_draw[33]
                estimpara[44]=cand_draw[34]
                estimpara[45]=cand_draw[35]
        end
        return estimpara
end




## Function for Metropolis-Hastings Algorithm

function myMH(model, simlen, cc, initialdraw, Σ,  obsdata ,path  )
        ## Take the "estimpararestric, regime, subsorcompl"
        # Specify the Model
        current_model = model
        if model=="5.1"
                regime="M"
        else
                regime="F"
        end
        # Apply the function "modelrestrictions"
        calibpara0=calibratedpara();
        estimpara0=transform_estimpara(regime,initialdraw)
        calibpara,estimpara,calibpararestric,estimpararestric,regime,subsorcompl =
                     modelrestrictions(current_model,calibpara0,estimpara0)
        # global regime

        ## Array to Store the Parameters drawn
        para_drawn = [zeros(size(Σ,1)) for i = 1:simlen]
        ## Array to Store multipliers
        y_multiplier = [zeros(41) for i=1:simlen]
        c_multiplier = [zeros(41) for i=1:simlen]
        i_multiplier = [zeros(41) for i=1:simlen]

        priorcount = 0; acceptcount = 0; postlast = -1e12;

        ## Initial Value
        # Just Draw from the Prior Distribution
        lastdraw = initialdraw

        # Cholesky decomposition
        P=cholesky(Σ)

        ## Start the Algorithm
         for ii = 1:simlen

        # Draw a candidate by θ = θ^{i-1} + η, where η ∼ N(0,c²Σ)
        cand_draw = lastdraw + cc*P.U* randn(size(Σ,1))
        estimpara=transform_estimpara(regime,cand_draw)

                # checks if ant σ parameters are negative
                # Otherwise, evaluate the densities of candidate parameters
                cand_σ_sign = prod(cand_draw[end-9:end-2] .> 0) # false if any of σ is negative
                if cand_σ_sign== false
                        cand_density = zeros(size(Σ,1))
                 #println("false (σ_sign)")
                else
                # Evaluate the Densities

                cand_pdf1     = ParaDensity(estimpara ) # Evaluate the Density
                cand_density  = JointDensities(cand_pdf1 , # Replace the irrelevant density by 1
                                               estimpararestric, regime, subsorcompl)
                end

                # cand_density_positive = prod(cand_density) > 1e-15
                # println([prod(cand_density), prod(cand_draw[end-7:end])])

                if prod(cand_density) < 1e-200
                          priorcount  = priorcount + 1  # number of rejection
                          lastdraw    = lastdraw        # keep the last draw

                          if ii>1
                                  y_multiplier[ii],c_multiplier[ii],i_multiplier[ii]=y_multiplier[ii-1],c_multiplier[ii-1],i_multiplier[ii-1]
                          else
                                  println(cand_draw[1])
                                  oldestimpara=transform_estimpara(regime,lastdraw)
                                  Γ_0s, Γ_1s, constants, Ψs, Πs = linearizedmodel(calibpara,oldestimpara,regime,path)

                                  # Recover the dense matrix
                                  Γ_0 = Matrix(Γ_0s); Γ_1 = Matrix(Γ_1s);
                                  constant = Vector(constants); Ψ = Matrix(Ψs); Π = Matrix(Πs)

                                  # Express in State-Space Form
                                  G1, C, impact, qt, a, b, z, eu=mygensys(Γ_0,Γ_1,constant,Ψ,Π)
                                  T, R, Q, Z, H, W=statespacematrices(G1,C,impact,calibpara,oldestimpara,path)
                                  y_multiplier[ii],c_multiplier[ii],i_multiplier[ii]=PVmultiplier(calibpara,oldestimpara,T,R,Q,Z,H,W,path)
                          end


                else # density of the draw is not zero
                        " Solve the model + Evaluate the Likelihood"
                        # Structural Model

                       Γ_0s, Γ_1s, constants, Ψs, Πs = linearizedmodel(calibpara,estimpara,regime,path)

                       # Recover the dense matrix
                       Γ_0 = Matrix(Γ_0s); Γ_1 = Matrix(Γ_1s);
                       constant = Vector(constants); Ψ = Matrix(Ψs); Π = Matrix(Πs)

                       # Express in State-Space Form
                       G1, C, impact, qt, a, b, z, eu=mygensys(Γ_0,Γ_1,constant,Ψ,Π)
                       T, R, Q, Z, H, W=statespacematrices(G1,C,impact,calibpara,estimpara,path)

                       # Evaluate the Likelihood
                       candlike = myKalmanLogLikelihood(T,R,Q,Z,H,W,obsdata)
                       postcand = log(prod(cand_density)) + candlike
                  #     println(postcand)

                       " Accept if likelihood is high enough"
                   #    println(postcand - postlast)
                    #   println(min( exp(postcand - postlast),1))
                       if min( exp(postcand - postlast),1) > rand()
                                 acceptcount = acceptcount + 1 # nember of acceptance
                                 lastdraw    = cand_draw       # replace with the new draw
                                 postlast    = postcand        # likelihood of the new draw
                                 y_multiplier[ii],c_multiplier[ii],i_multiplier[ii]=PVmultiplier(calibpara,estimpara,T,R,Q,Z,H,W,path)
                       else
                                 priorcount  = priorcount + 1  # number of rejection
                                 lastdraw    = lastdraw        # keep the current draw
                                 if ii>1
                                         y_multiplier[ii],c_multiplier[ii],i_multiplier[ii]=y_multiplier[ii-1],c_multiplier[ii-1],i_multiplier[ii-1]
                                 else
                                         oldestimpara=transform_estimpara(regime,lastdraw)
                                         y_multiplier[ii],c_multiplier[ii],i_multiplier[ii]=PVmultiplier(calibpara,oldestimpara,T,R,Q,Z,H,W,path)
                                 end
                       end

                end

                para_drawn[ii] =  lastdraw
        #        println("Accept:", acceptcount,", Reject:", priorcount  )

        end
        return para_drawn, acceptcount, priorcount, y_multiplier, c_multiplier, i_multiplier
end
