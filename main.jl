# Main file

path="/home/joaoritto/Dropbox/Economics/Books_and_notes/SecondYear/Macroeconometrics/TermPaper/"

using Statistics, LinearAlgebra, Distributions

include(path*"prior.jl")
include(path*"model.jl")
include(path*"PVmultiplier.jl")
include(path*"modelrestrictions.jl")
include(path*"priorpredictiveanalysis.jl")

N=200

Table_y,Table_c,Table_i=table3(N,path)
