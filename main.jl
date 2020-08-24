# Main file

path="/home/joaoritto/Dropbox/Economics/Books_and_notes/SecondYear/Macroeconometrics/TermPaper/"

using Statistics, LinearAlgebra

include(path*"model.jl")
include(path*"PVmultiplier.jl")

calibpara=calibratedpara()
estimpara=estimatedpara()
regime="M"


Γ_0, Γ_1, constant, Ψ, Π = linearizedmodel(calibpara,estimpara,regime,path)

G1, C, impact, qt, a, b, z, eu=mygensys(Γ_0,Γ_1,constant,Ψ,Π)

T, R, Q, Z, H, W=statespacematrices(G1,C,impact,path)

outputmultiplier,consumptionmultiplier,investmentmultiplier=PVmultiplier(calibpara,estimpara,path,T,R,Q,Z,H,W)
