# Computing IRFs

path="C:\\Users\\joaor\\Dropbox\\Economics\\Books_and_notes\\SecondYear\\Macroeconometrics\\TermPaper\\722TermPaper-master\\"

using Statistics, LinearAlgebra, Distributions, SparseArrays, JLD, Plots

include(path*"model.jl")
include(path*"PVmultiplier.jl")

model="5.1"
y_M,c_M,i_M,R_M,π_M,rr_M,b_M,w_M,L_M=IRFs(model,para_M,path)

model="5.2"
y_F,c_F,i_F,R_F,π_F,rr_F,b_F,w_F,L_F=IRFs(model,para_F,path)

y=[y_M y_F]
c=[c_M c_F]
i=[i_M i_F]
R=[R_M R_F]
π=[π_M π_F]
rr=[rr_M rr_F]
b=[b_M b_F]
w=[w_M w_F]
L=[L_M L_F]

x=0:80
p1=plot(x,y,title="Panel A: Output multiplier",titlefontsize=7,legend=false,linestyle=[:dot :dot :dash :dot :dot :solid],lc=[:red :red :red :blue :blue :blue])
p2=plot(x,c,title="Panel B: Consumption multiplier",titlefontsize=7,legend=false,linestyle=[:dot :dot :dash :dot :dot :solid],lc=[:red :red :red :blue :blue :blue])
p3=plot(x,i,title="Panel C: Investment multiplier",titlefontsize=7,legend=false,linestyle=[:dot :dot :dash :dot :dot :solid],lc=[:red :red :red :blue :blue :blue])
p4=plot(x,R,title="Panel D: Nominal interest rate",titlefontsize=7,legend=false,linestyle=[:dot :dot :dash :dot :dot :solid],lc=[:red :red :red :blue :blue :blue])
p5=plot(x,π,title="Panel E: Inflation",titlefontsize=7,legend=false,linestyle=[:dot :dot :dash :dot :dot :solid],lc=[:red :red :red :blue :blue :blue])
p6=plot(x,rr,title="Panel F: Real interest rate",titlefontsize=7,legend=false,linestyle=[:dot :dot :dash :dot :dot :solid],lc=[:red :red :red :blue :blue :blue])
p7=plot(x,b,title="Panel G: Mkt value debt/output",titlefontsize=7,legend=false,linestyle=[:dot :dot :dash :dot :dot :solid],lc=[:red :red :red :blue :blue :blue])
p8=plot(x,w,title="Panel J: Real wage",titlefontsize=7,legend=false,linestyle=[:dot :dot :dash :dot :dot :solid],lc=[:red :red :red :blue :blue :blue])
p9=plot(x,L,title="Panel K: Labor",titlefontsize=7,legend=false,linestyle=[:dot :dot :dash :dot :dot :solid],lc=[:red :red :red :blue :blue :blue])

finalplot=plot(p1,p2,p3,p4,p5,p6,p7,p8,p9,layout=(3,3))

savefig(path*"plotIRFs.png")

function IRFs(model,para_drawn,path)
    # Apply the function "modelrestrictions"
    if model==5.1
        regime="M"
    else
        regime="F"
    end

    include(path*"variablesindices.jl")
    num_vars=49
    num_shocks=8

    govshock=zeros(num_shocks,1)
    govshock[epseg_innov]=1 # Indice for fiscal expenditure shock

    calibpara=calibratedpara()
    N=size(para_drawn,1)
    horizon=80+1

    ymultiplier_IRF=zeros(horizon,N)
    cmultiplier_IRF=zeros(horizon,N)
    imultiplier_IRF=zeros(horizon,N)
    R_IRF=zeros(horizon,N)
    π_IRF=zeros(horizon,N)
    rr_IRF=zeros(horizon,N)
    b_IRF=zeros(horizon,N)
    #LRπ_IRF=zeros(horizon,N)
    #LRrr_IRF=zeros(horizon,N)
    w_IRF=zeros(horizon,N)
    L_IRF=zeros(horizon,N)
    #PS_IRF=zeros(horizon,N)

    AD=calibpara[1]
    β=calibpara[2]
    ρ=(1-(1/AD))*(1/β)

    for i in 1:N
        estimpara=transform_estimpara(regime,para_drawn[i])
        γ=estimpara[1]

        Γ_0s, Γ_1s, constants, Ψs, Πs = linearizedmodel(calibpara,estimpara,regime,path)
        # Recover the dense matrix
        Γ_0 = Matrix(Γ_0s); Γ_1 = Matrix(Γ_1s);
        constant = Vector(constants); Ψ = Matrix(Ψs); Π = Matrix(Πs)

        G1, C, impact, qt, a, b, z, eu=mygensys(Γ_0,Γ_1,constant,Ψ,Π)
        T, R, Q, Z, H, W=statespacematrices(G1,C,impact,calibpara,estimpara,path)
        outputmultiplier,consumptionmultiplier,investmentmultiplier=PVmultiplier(calibpara,estimpara,T,R,Q,Z,H,W,path)

        X=zeros(num_vars,horizon)

        for j in 1:horizon
            if j==1
                X[:,j]=R*govshock
            else
                X[:,j]=T*X[:,j-1]
            end
            ymultiplier_IRF[j,i]=outputmultiplier[j]
            cmultiplier_IRF[j,i]=consumptionmultiplier[j]
            imultiplier_IRF[j,i]=investmentmultiplier[j]
            R_IRF[j,i]=4*X[R_var,j]
            π_IRF[j,i]=4*X[π_var,j]
            rr_IRF[j,i]=4*X[rr_var,j]
            b_IRF[j,i]=X[b_var,j]-X[y_var,j]
            #LRπ_IRF[j,i]=0
            #LRrr_IRF[j,i]=0
            w_IRF[j,i]=X[w_var,j]
            L_IRF[j,i]=X[L_var,j]
            #PS_IRF[j,i]=0
        end
    end

    ymultiplier_IRFinterval=zeros(horizon,3)
    cmultiplier_IRFinterval=zeros(horizon,3)
    imultiplier_IRFinterval=zeros(horizon,3)
    R_IRFinterval=zeros(horizon,3)
    π_IRFinterval=zeros(horizon,3)
    rr_IRFinterval=zeros(horizon,3)
    b_IRFinterval=zeros(horizon,3)
    w_IRFinterval=zeros(horizon,3)
    L_IRFinterval=zeros(horizon,3)


    for j in 1:horizon
        ymultiplier_IRFinterval[j,1]=quantile(ymultiplier_IRF[j,:],0.05)
        ymultiplier_IRFinterval[j,2]=quantile(ymultiplier_IRF[j,:],0.95)
        ymultiplier_IRFinterval[j,3]=mean(ymultiplier_IRF[j,:])
        cmultiplier_IRFinterval[j,1]=quantile(cmultiplier_IRF[j,:],0.05)
        cmultiplier_IRFinterval[j,2]=quantile(cmultiplier_IRF[j,:],0.95)
        cmultiplier_IRFinterval[j,3]=mean(cmultiplier_IRF[j,:])
        imultiplier_IRFinterval[j,1]=quantile(imultiplier_IRF[j,:],0.05)
        imultiplier_IRFinterval[j,2]=quantile(imultiplier_IRF[j,:],0.95)
        imultiplier_IRFinterval[j,3]=mean(imultiplier_IRF[j,:])
        R_IRFinterval[j,1]=quantile(R_IRF[j,:],0.05)
        R_IRFinterval[j,2]=quantile(R_IRF[j,:],0.95)
        R_IRFinterval[j,3]=quantile(R_IRF[j,:])
        π_IRFinterval[j,1]=quantile(π_IRF[j,:],0.05)
        π_IRFinterval[j,2]=quantile(π_IRF[j,:],0.95)
        π_IRFinterval[j,3]=quantile(π_IRF[j,:])
        rr_IRFinterval[j,1]=quantile(rr_IRF[j,:],0.05)
        rr_IRFinterval[j,2]=quantile(rr_IRF[j,:],0.95)
        rr_IRFinterval[j,3]=quantile(rr_IRF[j,:])
        b_IRFinterval[j,1]=quantile(b_IRF[j,:],0.05)
        b_IRFinterval[j,2]=quantile(b_IRF[j,:],0.95)
        b_IRFinterval[j,3]=quantile(b_IRF[j,:])
        w_IRFinterval[j,1]=quantile(w_IRF[j,:],0.05)
        w_IRFinterval[j,2]=quantile(w_IRF[j,:],0.95)
        w_IRFinterval[j,3]=quantile(w_IRF[j,:])
        L_IRFinterval[j,1]=quantile(L_IRF[j,:],0.05)
        L_IRFinterval[j,2]=quantile(L_IRF[j,:],0.95)
        L_IRFinterval[j,3]=quantile(L_IRF[j,:])
    end

    return ymultiplier_IRFinterval,cmultiplier_IRFinterval,imultiplier_IRFinterval,R_IRFinterval,π_IRFinterval,rr_IRFinterval,b_IRF,w_IRFinterval,L_IRFinterval

end
