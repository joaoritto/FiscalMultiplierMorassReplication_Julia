# Main file

path="C:\\Users\\joaor\\Dropbox\\Economics\\Books_and_notes\\SecondYear\\Macroeconometrics\\TermPaper\\722TermPaper-master\\"

using Statistics, LinearAlgebra, Distributions, SparseArrays, JLD, Plots

include(path*"prior.jl")
include(path*"model.jl")
include(path*"PVmultiplier.jl")
include(path*"modelrestrictions.jl")
include(path*"priorpredictiveanalysis.jl")
#include(path*"Kalman.jl")

N=20000

cd(path) # go to the current directory

#Table_y,Table_c,Table_i=table3(N,path)



#save("file/PriorPredictiveN20000_model4.jld","OutMul",
#Table_y, "ConsMul", Table_c,
#"InvMul",Table_i) # save in the folder (I created a folder "file")

multipliers_y10,multipliers_y90,multipliers_y50,multipliers_c10,multipliers_c90,multipliers_c50,multipliers_i10,multipliers_i90,multipliers_i50=figure1(N,path)

x=0:40
y=[multipliers_y10' multipliers_y90' multipliers_y50']
c=[multipliers_c10' multipliers_c90' multipliers_c50']
i=[multipliers_i10' multipliers_i90' multipliers_i50']

p1=plot(x,y,title="Panel A: Output multiplier",titlefontsize=7,legend=false,linestyle=[:solid :dash :dashdot :solid :dash :dashdot :solid :dash :dashdot],lc=[:black :red :blue :black :red :blue :black :red :blue])
p2=plot(x,c,title="Panel B: Consumption multiplier",titlefontsize=7,legend=false,linestyle=[:solid :dash :dashdot :solid :dash :dashdot :solid :dash :dashdot],lc=[:black :red :blue :black :red :blue :black :red :blue])
p3=plot(x,i,title="Panel C: Investment multiplier",titlefontsize=7,legend=false,linestyle=[:solid :dash :dashdot :solid :dash :dashdot :solid :dash :dashdot],lc=[:black :red :blue :black :red :blue :black :red :blue])

finalplot=plot(p1,p2,p3,layout=(1,3))

savefig(path*"plot1.png")
