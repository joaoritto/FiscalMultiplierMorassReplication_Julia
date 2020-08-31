# Main file

path="/home/joaoritto/Dropbox/Economics/Books_and_notes/SecondYear/Macroeconometrics/TermPaper/"

using Statistics, LinearAlgebra, Distributions

include(path*"prior.jl")
include(path*"model.jl")
include(path*"PVmultiplier.jl")
include(path*"modelrestrictions.jl")

model=2.3
N=2000

function PriorPredictiveAnalysis(model,N)

    periods=40+1 # 10 years is 40 quarters, plus the impact multiplier

    outputmultiplier=[zeros(periods) for i in 1:N]
    consumptionmultiplier=[zeros(periods) for i in 1:N]
    investmentmultiplier=[zeros(periods) for i in 1:N]

    for i in 1:N
        calibpara0=calibratedpara()
        #estimpara=estimatedpara()

        estimpara0=DrawParaFromPrior()

        calibpara,estimpara,calibparar,estimparar,regime,subsorcompl=modelrestrictions(model,calibpara0,estimpara0)

        Γ_0, Γ_1, constant, Ψ, Π = linearizedmodel(calibpara,estimpara,regime,path)

        G1, C, impact, qt, a, b, z, eu=mygensys(Γ_0,Γ_1,constant,Ψ,Π)

        T, R, Q, Z, H, W=statespacematrices(G1,C,impact,estimpara,path)

        outputmultiplier[i],consumptionmultiplier[i],investmentmultiplier[i]=PVmultiplier(calibpara,estimpara,path,T,R,Q,Z,H,W)
    end

    return outputmultiplier,consumptionmultiplier,investmentmultiplier
end

outputmultiplier,consumptionmultiplier,investmentmultiplier=PriorPredictiveAnalysis(model,N)

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
