# Main file

path="C:\\Users\\joaor\\Dropbox\\Economics\\Books_and_notes\\SecondYear\\Macroeconometrics\\TermPaper\\722TermPaper-master\\"

using Statistics, LinearAlgebra, Distributions, SparseArrays, JLD, MAT

include(path*"prior.jl")
include(path*"model.jl")
include(path*"PVmultiplier.jl")
include(path*"modelrestrictions.jl")
include(path*"priorpredictiveanalysis.jl")
include(path*"Kalman.jl")
include(path*"ConvertMode.jl")
include(path*"RWMH.jl")

N_initialization=1000
N=100000
model  = "5.1"
if model=="5.1"
        regime="M"
else
        regime="F"
end


file1  = read(matopen("data.mat")) # load data
USdata = file1["data"]             # extract array from the loaded data

d1d      = 1955.1;        # first quarter in estimation
d2d      = 2007.4;        # last quarter in estimation
obsdata = get_data(d1d,d2d,USdata)

## Create a vector of standard deviations from Prior Distributions



Σ0=Diagonal([0.05/100,0.5,0.2,0.1,1.01,0.15,1.5,0.2,0.2,0.2,0.2, # χ_w
        0.2,0.15,0.05,0.2,0.1,0.1,0.1,0.1,0.001,0.001,0.001,0.001,# γ_ZF
        0.2,0.2,0.2,0.2, 0.2,0.2,0.2,0.2,0.2, 0.15,0.15,0.15, # ρ_ez
        1/100,1/100,1/100,1/100, 1/100,1/100,1/100,1/100,5,0.25].^2)

calibpara0=calibratedpara()

if regime=="M"
        leeperinit  = read(matopen("mode_regimeM_5507.mat"))
        leepermode = leeperinit["mode"]
        mode0=transform_M(leepermode)
        calibpara,mymode,calibparar,estimparar,regime,subsorcompl=modelrestrictions(model,calibpara0,mode0)
else
        leeperinit  = read(matopen("mode_regimeF_5507.mat"))
        leepermode = leeperinit["mode"]
        mode0=transform_F(leepermode)
        calibpara,mymode,calibparar,estimparar,regime,subsorcompl=modelrestrictions(model,calibpara0,mode0)
end


initialdraw=mymode
cc       = 0.1 # tuned to have acceptance rate 0.2-0.4


para_drawn, acceptcount, priorcount, y_multiplier, c_multiplier, i_multiplier  = myMH(model, N_initialization, cc, initialdraw, Σ0,  obsdata,path ) ;

# Summarize the Results
println("Accept:", acceptcount,", Reject:", priorcount  )
mean(para_drawn), std(para_drawn)
