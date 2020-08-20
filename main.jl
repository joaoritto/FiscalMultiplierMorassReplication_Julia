# Main file

path="/home/joaoritto/Dropbox/Economics/Books_and_notes/SecondYear/Macroeconometrics/TermPaper/"

include(path*"model.jl")

calibpara=calibratedpara()
estimpara=estimatedpara()
regime="M"

using LinearAlgebra

Γ_0, Γ_1, constant, Ψ, Π = linearizedmodel(calibpara,estimpara,regime,path)


G1, C, impact, qt, a, b, z, eu=mygensys(Γ_0,Γ_1,constant,Ψ,Π)


# Constructing the state space form with observables

# Transition equation: α_t=T α_{t-1} + R η_t,    η_t is N(0,Q)
# Measurement equation: y_t=Z α_t + C + ζ_t   ζ_t is N(0,H)

num_statevariables=48
num_obsvariables=8
num_shocks=8

# Observable variables indices
dcobs_var=41 # Log differences of aggregate consumption
diobs_var=42 # Log differences of aggregate investment
dwobs_var=43 # Log differences of real wages
dgobs_var=44 # Log differences of government consumption
dbobs_var=45 # Log differences of real debt in market value
Lobs_var=46 # Log hours worked
πobs_var=47 # GDP deflator
Robs_var=48 # Fed funds rate


T=G1

R=impact

Q=Matrix(1I,num_shocks,num_shocks)

Z=zeros(num_obsvariables,num_statevariables)
Z[1,dcobs_var]=1
Z[2,diobs_var]=1
Z[3,dwobs_var]=1
Z[4,dgobs_var]=1
Z[5,dbobs_var]=1
Z[6,Lobs_var]=1
Z[7,πobs_var]=1
Z[8,Robs_var]=1

γ=estimpara[1]

C=zeros(num_obsvariables)
C[1]=γ*100
C[2]=γ*100
C[3]=γ*100
C[4]=γ*100
C[5]=γ*100
#C[6]=Lbar
#C[7]=π_ss
#C[8]=π_ss+Rbar

# Need to define what the steady state values in these last constants should equal to

H=zeros(num_obsvariables,num_obsvariables)
