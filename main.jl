# Main file

path="C:\\Users\\joaor\\Dropbox\\Economics\\Books_and_notes\\SecondYear\\Macroeconometrics\\TermPaper\\722TermPaper-master\\"

using Statistics, LinearAlgebra, Distributions, SparseArrays, JLD

include(path*"prior.jl")
include(path*"model.jl")
include(path*"PVmultiplier.jl")
include(path*"modelrestrictions.jl")
include(path*"priorpredictiveanalysis.jl")
#include(path*"Kalman.jl")

N=20000

Table_y,Table_c,Table_i=table3(N,path)

cd(path) # go to the current directory

save("file/PriorPredictiveN20000_model3.jld","OutMul",
Table_y, "ConsMul", Table_c,
"InvMul",Table_i) # save in the folder (I created a folder "file")
