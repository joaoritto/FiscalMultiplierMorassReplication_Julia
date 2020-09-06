## Preparation for Metropolis-Hastings Algorithm

## Create a vector of standard deviations from Prior Distributions

vSD = [0.05/100,0.5,0.2,0.1,1.01,0.15,1.5,0.2,0.2,0.2,0.2, # χ_w
        0.2,0.15,0.05,0.2,0.1,0.1,0.1,0.1,0.001,0.001,0.001,0.001,# γ_ZF
        0.2,0.2,0.2,0.2, 0.2,0.2,0.2,0.2,0.2, 0.15,0.15,0.15, # ρ_ez
        1/100,1/100,1/100,1/100, 1/100,1/100,1/100,1/100,]

## Take the "estimpararestric, regime, subsorcompl"
# Specify the Model
current_model = 2.1
# Apply the function "modelrestrictions"
calibpara00=calibratedpara();  estimpara00=DrawParaFromPrior()
calibpara,estimpara,calibpararestric,estimpararestric,regime,subsorcompl =
             modelrestrictions(current_model,calibpara00,estimpara00)

## Array to Store the Parameters drawn
simlen = 50
para_drawn = [zeros(length(vSD)) for i = 1:simlen]

priorcount = 0; acceptcount = 0;

## Initial Value
# Just Draw from the Prior Distribution
lastdraw = mean([DrawParaFromPrior() for i=1:100])
cc       = 0.2 # tuned to have acceptance rate 0.2-0.4

## Start the Algorithm
for ii = 1:simlen
# Draw a candidate by θ = θ^{i-1} + η, where η ∼ N(0,c²Σ)
cand_draw = lastdraw + cc^2 * randn(length(vSD)) .* vSD
" Need a code which checks if ant σ parameters are negative"
" and immediately gives that prod(cand_density)=0 "

# Evaluate the Densities
cand_pdf1     = ParaDensity(cand_draw ) # Evaluate the Density
cand_density  = JointDensities(cand_pdf1 , # Replace the irrelevant density by 1
                               estimpararestric, regime, subsorcompl)
# println([cand_density.==0])
println(prod(cand_density))

if prod(cand_density) < 1e-15
        global  priorcount  = priorcount + 1
        postcand   = - 1e5
        global  lastdraw    = lastdraw

else
        " Solve the model + Evaluate the Likelihood"
        " Accept if likelihood is high enough"
        global  acceptcount = acceptcount + 1

        global  lastdraw    = cand_draw
end

para_drawn[ii] =  lastdraw

end

println("Accept:", acceptcount,", Reject:", priorcount  )
