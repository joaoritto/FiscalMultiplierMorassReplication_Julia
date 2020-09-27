
function PriorPredictiveAnalysis(model,N,path)

    periods=40+1 # 10 years is 40 quarters, plus the impact multiplier

    outputmultiplier=[zeros(periods) for i in 1:N]
    consumptionmultiplier=[zeros(periods) for i in 1:N]
    investmentmultiplier=[zeros(periods) for i in 1:N]

    for i in 1:N
        calibpara0=calibratedpara()
        #estimpara=estimatedpara()

        estimpara0=DrawParaFromPrior()

        calibpara,estimpara,calibparar,estimparar,regime,subsorcompl=modelrestrictions(model,calibpara0,estimpara0)

        Γ_0s, Γ_1s, constants, Ψs, Πs = linearizedmodel(calibpara,estimpara,regime,path)

        # Recover the dense matrix
        Γ_0 = Matrix(Γ_0s); Γ_1 = Matrix(Γ_1s);
        constant = Vector(constants); Ψ = Matrix(Ψs); Π = Matrix(Πs)

        G1, C, impact, qt, a, b, z, eu=mygensys(Γ_0,Γ_1,constant,Ψ,Π)

        T, R, Q, Z, H, W=statespacematrices(G1,C,impact,calibpara,estimpara,path)

        outputmultiplier[i],consumptionmultiplier[i],investmentmultiplier[i]=PVmultiplier(calibpara,estimpara,T,R,Q,Z,H,W,path)
    end

    return outputmultiplier,consumptionmultiplier,investmentmultiplier
end


function table3(N,path)
    #Models=["2.1";"2.2";"2.3";"3.1";"3.2";"3.3";"4.1";"4.2";"4.3";"4.4";"4.5";"4.6";"4.7";"4.8";"4.9";"4.10";"4.11";"4.12"]
    Models=["3.1";"3.2";"3.3"]

    Table_y=zeros(length(Models),5)
    Table_c=zeros(length(Models),5)
    Table_i=zeros(length(Models),5)

    for ind in 1:length(Models)
        model=Models[ind]
        outputmultiplier,consumptionmultiplier,investmentmultiplier=PriorPredictiveAnalysis(model,N,path)

        Horizons=[0+1; 4+1; 10+1; 25+1; 40+1]

        # Output

        problargemultiplier_y=zeros(5)
        problargemultiplier_c=zeros(5)
        problargemultiplier_i=zeros(5)

        for j in 1:5
            t=Horizons[j]
            largemultiplier_y=Bool[outputmultiplier[i][t]>1 for i in 1:N]
            largemultiplier_c=Bool[consumptionmultiplier[i][t]>0 for i in 1:N]
            largemultiplier_i=Bool[investmentmultiplier[i][t]>0 for i in 1:N]
            problargemultiplier_y[j]=sum(largemultiplier_y)/N
            problargemultiplier_c[j]=sum(largemultiplier_c)/N
            problargemultiplier_i[j]=sum(largemultiplier_i)/N
        end

        Table_y[ind,:]=problargemultiplier_y'
        Table_c[ind,:]=problargemultiplier_c'
        Table_i[ind,:]=problargemultiplier_i'
    end

    return Table_y,Table_c,Table_i
end

function figure1(N,path)
    Models=["5.1";"3.1";"3.4"]

    horizon=41


    multipliers_y10=zeros(length(Models),horizon)
    multipliers_y90=zeros(length(Models),horizon)
    multipliers_y50=zeros(length(Models),horizon)
    multipliers_c10=zeros(length(Models),horizon)
    multipliers_c90=zeros(length(Models),horizon)
    multipliers_c50=zeros(length(Models),horizon)
    multipliers_i10=zeros(length(Models),horizon)
    multipliers_i90=zeros(length(Models),horizon)
    multipliers_i50=zeros(length(Models),horizon)

    for ind in 1:length(Models)
        model=Models[ind]
        outputmultiplier,consumptionmultiplier,investmentmultiplier=PriorPredictiveAnalysis(model,N,path)

        multipliers_y=zeros(horizon,N)
        multipliers_c=zeros(horizon,N)
        multipliers_i=zeros(horizon,N)

        for i in 1:N
            for j in 1:horizon
                multipliers_y[j,i]=outputmultiplier[i][j]
                multipliers_c[j,i]=consumptionmultiplier[i][j]
                multipliers_i[j,i]=investmentmultiplier[i][j]
            end
        end

        for j in 1:horizon
            multipliers_y10[ind,j]=quantile(multipliers_y[j,:],0.1)
            multipliers_y90[ind,j]=quantile(multipliers_y[j,:],0.9)
            multipliers_y50[ind,j]=quantile(multipliers_y[j,:],0.5)
            multipliers_c10[ind,j]=quantile(multipliers_c[j,:],0.1)
            multipliers_c90[ind,j]=quantile(multipliers_c[j,:],0.9)
            multipliers_c50[ind,j]=quantile(multipliers_c[j,:],0.5)
            multipliers_i10[ind,j]=quantile(multipliers_i[j,:],0.1)
            multipliers_i90[ind,j]=quantile(multipliers_i[j,:],0.9)
            multipliers_i50[ind,j]=quantile(multipliers_i[j,:],0.5)
        end
    end

    return multipliers_y10,multipliers_y90,multipliers_y50,multipliers_c10,multipliers_c90,multipliers_c50,multipliers_i10,multipliers_i90,multipliers_i50
end


function figure2(N,path)
    Models=["5.2";"3.3";"3.5"]

    horizon=41


    multipliers_y10=zeros(length(Models),horizon)
    multipliers_y90=zeros(length(Models),horizon)
    multipliers_y50=zeros(length(Models),horizon)
    multipliers_c10=zeros(length(Models),horizon)
    multipliers_c90=zeros(length(Models),horizon)
    multipliers_c50=zeros(length(Models),horizon)
    multipliers_i10=zeros(length(Models),horizon)
    multipliers_i90=zeros(length(Models),horizon)
    multipliers_i50=zeros(length(Models),horizon)

    for ind in 1:length(Models)
        model=Models[ind]
        outputmultiplier,consumptionmultiplier,investmentmultiplier=PriorPredictiveAnalysis(model,N,path)

        multipliers_y=zeros(horizon,N)
        multipliers_c=zeros(horizon,N)
        multipliers_i=zeros(horizon,N)

        for i in 1:N
            for j in 1:horizon
                multipliers_y[j,i]=outputmultiplier[i][j]
                multipliers_c[j,i]=consumptionmultiplier[i][j]
                multipliers_i[j,i]=investmentmultiplier[i][j]
            end
        end

        for j in 1:horizon
            multipliers_y10[ind,j]=quantile(multipliers_y[j,:],0.1)
            multipliers_y90[ind,j]=quantile(multipliers_y[j,:],0.9)
            multipliers_y50[ind,j]=quantile(multipliers_y[j,:],0.5)
            multipliers_c10[ind,j]=quantile(multipliers_c[j,:],0.1)
            multipliers_c90[ind,j]=quantile(multipliers_c[j,:],0.9)
            multipliers_c50[ind,j]=quantile(multipliers_c[j,:],0.5)
            multipliers_i10[ind,j]=quantile(multipliers_i[j,:],0.1)
            multipliers_i90[ind,j]=quantile(multipliers_i[j,:],0.9)
            multipliers_i50[ind,j]=quantile(multipliers_i[j,:],0.5)
        end
    end

    return multipliers_y10,multipliers_y90,multipliers_y50,multipliers_c10,multipliers_c90,multipliers_c50,multipliers_i10,multipliers_i90,multipliers_i50
end
