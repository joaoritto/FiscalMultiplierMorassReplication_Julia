## Draw Parameters From Prior Distribution
# August 19th, Yoshiki
using Distributions, Plots
## Define Functions
# These functions draw a random variable for each distribution
# given mean (μ) and std (σ)

function myGamma(μ, σ)
   α      = μ^2 / σ^2 ; # compute α in Γ dist
   β      = σ^2 / μ ;   # compute β in Γ dist
   draw   = rand(Gamma(α, β))
   return draw
end

function myBeta(μ,σ) #return a draw from Beta Dist with (μ,σ)
   α = ( (1-μ)/σ^2 - 1/μ ) * μ^2 ; # compute α in Β dist
   β = α * (1/μ - 1);              # compute β in Β dist
   draw = rand(Beta(α, β))
   return draw
end

function myUni(μ, σ)
   β      =  μ + 3^0.5 * σ
   α      =  2 * μ - β
   draw   = rand(Uniform(α, β))
   return draw
end

function myInvΓ(μ,σ)
   α = μ^2/σ^2 + 2
   θ = μ* ( α -1)
   draw = rand(InverseGamma(α,θ))
   return draw
end

# check
# v   = [myInvΓ(0.5,0.2) for i=1:10000]
# mean(v), std(v)

## Function to draw Parameters from Prior Distributions
function DrawParaFromPrior( )
# Preferences and HHs
γ  = rand(Normal(0.4, 0.05))/100 # Steady State ln growth
ξ  = myGamma(2.0,0.5)  # Inverse Frisch labor elasticity
θ  = myBeta(0.5,0.2) # Habit formation
μ  = myBeta(0.3,0.1) # Fraction of non-savers
α_G= myUni(0.0,1.01) # Substitutability of private/public consumption

# Frictions and production
ψ   = myBeta(0.6,0.15) # Capital utilization
s   = rand(Normal(6,1.5)) # Investment adjustment cost
ω_p = myBeta(0.5,0.2) # Price stickiness
ω_w = myBeta(0.5,0.2) # Wage stickiness
χ_p = myBeta(0.5,0.2) # Price partial indexation
χ_w = myBeta(0.5,0.2) # Wage partial indexation

# Monetary policy
ϕ_πM = rand(Normal(1.5,0.2)) # Interest rate response to inflation, regime M
ϕ_πF = myBeta(0.5,0.15) # Interest rate response to inflation, regime F
ϕ_y  = rand(Normal(0.125,0.05)) # Interest rate response to output
ρ_r  = myBeta(0.5,0.2) # Response to lagged interest rate

# Fiscal policy
γ_GM = rand(Normal(0.15,0.1)) # Debt response for expenditures, regime M
γ_KM = rand(Normal(0.15,0.1)) # Debt response for capital taxes, regime M
γ_LM = rand(Normal(0.15,0.1)) # Debt response for labor taxes, regime M
γ_ZM = rand(Normal(0.15,0.1)) # Debt response for transfers, regime M
γ_GF = rand(Normal(0.0,0.001)) # Debt response for expenditures, regime F
γ_KF = rand(Normal(0.0,0.001)) # Debt response for capital taxes, regime F
γ_LF = rand(Normal(0.0,0.001)) # Debt response for labor taxes, regime F
γ_ZF = rand(Normal(0.0,0.001)) # Debt response for transfers, regime F
ρ_G  = myBeta(0.5,0.2) # Lagged response for expenditures
ρ_K  = myBeta(0.5,0.2) # Lagged response for capital taxes
ρ_L  = myBeta(0.5,0.2) # Lagged response for labor taxes
ρ_Z  = myBeta(0.5,0.2) # Lagged response for transfers

# Shocks
ρ_a   = myBeta(0.5,0.2) # Autoregressive parameter, technology shock
ρ_b   = myBeta(0.5,0.2) # Autoregressive parameter, preference shock
ρ_i   = myBeta(0.5,0.2) # Autoregressive parameter, investment shock
ρ_p   = myBeta(0.5,0.2) # Autoregressive parameter, price markup shock
ρ_w   = myBeta(0.5,0.2) # Autoregressive parameter, wage markup shock
ρ_em  = myBeta(0.5,0.15) # Autoregressive parameter, monetary policy shock
ρ_eg  = myBeta(0.5,0.15) # Autoregressive parameter, government consumption shock
ρ_ez  = myBeta(0.5,0.15) # Autoregressive parameter, transfers shock
σ_a   = myInvΓ(0.1,1)/100 # Standard deviation, technology shock
σ_b   = myInvΓ(0.1,1)/100 # Standard deviation, preference shock
σ_i   = myInvΓ(0.1,1)/100 # Standard deviation, investment shock
σ_p   = myInvΓ(0.1,1)/100 # Standard deviation, price markup shock
σ_w   = myInvΓ(0.1,1)/100 # Standard deviation, wage markup shock
σ_em  = myInvΓ(0.1,1)/100 # Standard deviation, monetary policy shock
σ_eg  = myInvΓ(0.1,1)/100 # Standard deviation, government consumption shock
σ_ez  = myInvΓ(0.1,1)/100 # Standard deviation, transfers shock

## Create an array (vector) of parameters
parameters =
   [γ,ξ,θ,μ,α_G,ψ,s,ω_p,ω_w,χ_p,χ_w,ϕ_πM,ϕ_πF,ϕ_y,ρ_r]
parameters =
  push!(parameters,γ_GM,γ_KM,γ_LM,γ_ZM,γ_GF,γ_KF,γ_LF,γ_ZF)
parameters =
  push!(parameters,ρ_G,ρ_K,ρ_L,ρ_Z,ρ_a,ρ_b,ρ_i,ρ_p,ρ_w,ρ_em,ρ_eg,ρ_ez)
parameters =
  push!(parameters,σ_a,σ_b,σ_i,σ_p,σ_w,σ_em,σ_eg,σ_ez)

# num_parameters = length(parameters)
 return parameters
end

priorpara = DrawParaFromPrior()

# Check that this function generates random variables with targetter mean
# aa = [DrawParaFromPrior() for i=1:10000]
# println(mean(aa))

## Evaluate Density of each value

γ  = rand(Normal(0.4, 0.05))/100
pdf(Normal(0.4, 0.05), 100γ )

# Check if it works properly
vγ   = -3:0.01:3
# vpdf = pdf(Normal(), vγ )
# plot(vγ,vpdf)

## Create Functions to evaluate pdf
# using Pkg ; Pkg.add("SpecialFunctions")
# using SpecialFunctions
function myGammaPdf(μ, σ, value)
   α         = μ^2 / σ^2 ; # compute α in Γ dist
   β         = σ^2 / μ ;   # compute β in Γ dist
#   pdf_temp  = value^(α-1)*exp(-value/β)/(gamma(α)*β^α)
   pdf_temp  = pdf(Gamma(α, β), value )
   return pdf_temp
end

# Check if it works well
α1 = 2; β1 = 2;
μ1 = α1 * β1; σ1 = sqrt(α1 * β1^2)
vGamma   = reshape(0.01:0.01:10, length(0.01:0.01:10), 1)
vpdfGamma= [myGammaPdf(μ1, σ1, vGamma[i,1]) for i=1:length(vGamma)]
plot(vGamma[:,1],vpdfGamma[:,1])

## Beta Function
function myBetaPdf(μ,σ, value) #return a draw from Beta Dist with (μ,σ)
   α         = ( (1-μ)/σ^2 - 1/μ ) * μ^2 ; # compute α in Β dist
   β        = α * (1/μ - 1);              # compute β in Β dist
   pdf_temp = pdf.(Beta(α, β),value)
   return pdf_temp
end

# Check if it works well
α2 = 2; β2 = 2;
μ2 = α2/(α2+β2)
σ2 = sqrt(α2 * β2 / ( (α2+β2)^2*(α2+β2+1))  )

vBeta    = [0.01:0.01:1]
vpdfBeta = [myBetaPdf(μ2, σ2, vBeta[i]) for i=1:length(vBeta)]
plot(vBeta[:,1],vpdfBeta[:,1])


## Uniform Distribution
function myUniPdf(μ, σ, value)
   β          =  μ + 3^0.5 * σ
   α          =  2 * μ - β
   pdf_temp   = pdf.(Uniform(α, β),value)
   return pdf_temp
end

# Check if it works well
α3 = -1.749; β3 = 1.749;
μ3 = 0.5*(α3 + β3)
σ3 = sqrt( (α3-β3)^2/12 )

vUni     = [-2:0.01:2]
vpdfUni  = [myUniPdf(μ3, σ3, vUni[i]) for i=1:length(vUni)]
plot(vUni[:,1],vpdfUni[:,1])


## Inverse Gamma Distribution
function myInvΓPdf(μ,σ, value)
   α = μ^2/σ^2 + 2
   θ = μ* ( α -1)
   pdf_temp = pdf.(InverseGamma(α,θ),value)
   return pdf_temp
end

# Check if it works well
α4 = 3; β4 = 1;
μ4 = β4/(α4-1)
σ4 = sqrt( β4^2/((α4-1)^2*(α4-2)) )

vInvG     = [0.01:0.01:3]
vpdfInvG  = [myInvΓPdf(μ4, σ4, vInvG[i]) for i=1:length(vInvG)]
plot(vInvG[:,1],vpdfInvG[:,1])



## Function to Evaluate the density for each parameter value
function ParaDensity(paraValues )
# Preferences and HHs
γ_pdf  = pdf(Normal(0.4, 0.05),100*paraValues[1]) # Steady State ln growth
ξ_pdf  = myGammaPdf(2.0,0.5,paraValues[2])  # Inverse Frisch labor elasticity
θ_pdf  = myBetaPdf(0.5,0.2,paraValues[3]) # Habit formation
μ_pdf  = myBetaPdf(0.3,0.1,paraValues[4]) # Fraction of non-savers
α_G_pdf= myUniPdf(0.0,1.01,paraValues[5]) # Substitutability of private/public consumption

# Frictions and production
ψ_pdf   = myBetaPdf(0.6,0.15,paraValues[6]) # Capital utilization
s_pdf   = pdf(Normal(6,1.5),paraValues[7]) # Investment adjustment cost
ω_p_pdf = myBetaPdf(0.5,0.2,paraValues[8]) # Price stickiness
ω_w_pdf = myBetaPdf(0.5,0.2,paraValues[9]) # Wage stickiness
χ_p_pdf = myBetaPdf(0.5,0.2,paraValues[10]) # Price partial indexation
χ_w_pdf = myBetaPdf(0.5,0.2,paraValues[11]) # Wage partial indexation

# Monetary policy
ϕ_πM_pdf = pdf(Normal(1.5,0.2),paraValues[12]) # Interest rate response to inflation, regime M
ϕ_πF_pdf = myBetaPdf(0.5,0.15,paraValues[13]) # Interest rate response to inflation, regime F
ϕ_y_pdf  = pdf(Normal(0.125,0.05),paraValues[14]) # Interest rate response to output
ρ_r_pdf  = myBetaPdf(0.5,0.2,paraValues[15]) # Response to lagged interest rate

# Fiscal policy
γ_GM_pdf = pdf(Normal(0.15,0.1),paraValues[16]) # Debt response for expenditures, regime M
γ_KM_pdf = pdf(Normal(0.15,0.1),paraValues[17]) # Debt response for capital taxes, regime M
γ_LM_pdf = pdf(Normal(0.15,0.1),paraValues[18]) # Debt response for labor taxes, regime M
γ_ZM_pdf = pdf(Normal(0.15,0.1),paraValues[19]) # Debt response for transfers, regime M
γ_GF_pdf = pdf(Normal(0.0,0.001),paraValues[20]) # Debt response for expenditures, regime F
γ_KF_pdf = pdf(Normal(0.0,0.001),paraValues[21]) # Debt response for capital taxes, regime F
γ_LF_pdf = pdf(Normal(0.0,0.001),paraValues[22]) # Debt response for labor taxes, regime F
γ_ZF_pdf = pdf(Normal(0.0,0.001),paraValues[23]) # Debt response for transfers, regime F
ρ_G_pdf  = myBetaPdf(0.5,0.2,paraValues[24]) # Lagged response for expenditures
ρ_K_pdf  = myBetaPdf(0.5,0.2,paraValues[25]) # Lagged response for capital taxes
ρ_L_pdf  = myBetaPdf(0.5,0.2,paraValues[26]) # Lagged response for labor taxes
ρ_Z_pdf  = myBetaPdf(0.5,0.2,paraValues[27]) # Lagged response for transfers

# Shocks
ρ_a_pdf   = myBetaPdf(0.5,0.2,paraValues[28]) # Autoregressive parameter, technology shock
ρ_b_pdf   = myBetaPdf(0.5,0.2,paraValues[29]) # Autoregressive parameter, preference shock
ρ_i_pdf   = myBetaPdf(0.5,0.2,paraValues[30]) # Autoregressive parameter, investment shock
ρ_p_pdf   = myBetaPdf(0.5,0.2,paraValues[31]) # Autoregressive parameter, price markup shock
ρ_w_pdf   = myBetaPdf(0.5,0.2,paraValues[32]) # Autoregressive parameter, wage markup shock
ρ_em_pdf  = myBetaPdf(0.5,0.15,paraValues[33]) # Autoregressive parameter, monetary policy shock
ρ_eg_pdf  = myBetaPdf(0.5,0.15,paraValues[34]) # Autoregressive parameter, government consumption shock
ρ_ez_pdf  = myBetaPdf(0.5,0.15,paraValues[35]) # Autoregressive parameter, transfers shock
σ_a_pdf   = myInvΓPdf(0.1,1,100*paraValues[36]) # Standard deviation, technology shock
σ_b_pdf   = myInvΓPdf(0.1,1,100*paraValues[37]) # Standard deviation, preference shock
σ_i_pdf   = myInvΓPdf(0.1,1,100*paraValues[38]) # Standard deviation, investment shock
σ_p_pdf   = myInvΓPdf(0.1,1,100*paraValues[39]) # Standard deviation, price markup shock
σ_w_pdf   = myInvΓPdf(0.1,1,100*paraValues[40]) # Standard deviation, wage markup shock
σ_em_pdf  = myInvΓPdf(0.1,1,100*paraValues[41]) # Standard deviation, monetary policy shock
σ_eg_pdf  = myInvΓPdf(0.1,1,100*paraValues[42]) # Standard deviation, government consumption shock
σ_ez_pdf  = myInvΓPdf(0.1,1,100*paraValues[43]) # Standard deviation, transfers shock

## Create an array (vector) of parameters
paraPdf =
   [γ_pdf,ξ_pdf,θ_pdf,μ_pdf,α_G_pdf,ψ_pdf,s_pdf,ω_p_pdf,ω_w_pdf,χ_p_pdf,χ_w_pdf,ϕ_πM_pdf,ϕ_πF_pdf,ϕ_y_pdf,ρ_r_pdf]
paraPdf =
  push!(paraPdf,γ_GM_pdf,γ_KM_pdf,γ_LM_pdf,γ_ZM_pdf,γ_GF_pdf,γ_KF_pdf,γ_LF_pdf,γ_ZF_pdf)
paraPdf =
  push!(paraPdf,ρ_G_pdf,ρ_K_pdf,ρ_L_pdf,ρ_Z_pdf,ρ_a_pdf,ρ_b_pdf,ρ_i_pdf,ρ_p_pdf,ρ_w_pdf,ρ_em_pdf,ρ_eg_pdf,ρ_ez_pdf)
paraPdf =
  push!(paraPdf,σ_a_pdf,σ_b_pdf,σ_i_pdf,σ_p_pdf,σ_w_pdf,σ_em_pdf,σ_eg_pdf,σ_ez_pdf)

# num_parameters = length(paraPdf)
 return paraPdf
end

## DELETE THIS?

#pdf1 = ParaDensity(priorpara )
#prod(pdf1)

# Check when some density is zero
#priorpara[5] = 2
#pdf1 = ParaDensity(priorpara )
#prod(pdf1)

" ## Test if it works properly
Ntry        = 100
TryMatrix   = zeros(length(priorpara), Ntry)

for jj = 1:Ntry
priorpara1  = DrawParaFromPrior()
paraPdf1    = ParaDensity(priorpara1 )

vPrior       = [DrawParaFromPrior() for i = 1:100]
vParaPdf     = [ParaDensity(vPrior[i] ) for i = 1:100]
vPdfRelative = [vParaPdf[i]./paraPdf1 for i = 1:100]
TryMatrix[:,jj] = mean(vPdfRelative)
end
println(mean(TryMatrix,dims = 2))
"

## Create a function to return Joint Density
# input: vDensities, estimpararestric,regime,subsorcompl
# vDensities: a vector of density (after applying the function "ParaDensity")
# return the vector of densities
# where the density irrelevant parameters are replaced to one

"  # This is a setup to check if the function works properly
# draw Parameters
calibpara0=calibratedpara()
estimpara0=DrawParaFromPrior()

# Apply the fuction modelrestrictions
calibpara,estimpara,calibpararestric,estimpararestric,regime,subsorcompl =
     modelrestrictions(2.1,calibpara0,estimpara0)

# Vector of Densities
vDensities = ParaDensity(estimpara0 )

println(estimpararestric)
println(vDensities)
"


function JointDensities(vDensities, estimpararestric,regime, subsorcompl)

vDensities2 = vDensities.* estimpararestric + (1 .- estimpararestric)

if regime == "M"
   regimeM01 = ones(Int64,43)
   regimeM01[[13,20,21,22,23]] = zeros(Int64,5) # create a vector similar to estimpararestric
   vDensities3 = vDensities.* regimeM01 + (1 .- regimeM01)
else # regime "F"
   regimeF01 = ones(Int64,43)
   regimeF01[[12,16,17,18,19]] = zeros(Int64,5)
   vDensities3 = vDensities.* regimeF01 + (1 .- regimeF01)
end

if subsorcompl==1
   vDensities3[5] = 2*vDensities3[5]
end

   return vDensities3
end

" # Check if it works okay
JointDensity1 =  JointDensities(vDensities, estimpararestric,regime,subsorcompl)
prod(JointDensity1)


## Try with Relative Densities
# Draw Two Prior Paramters
estimpara1=DrawParaFromPrior()
estimpara2=DrawParaFromPrior()
# Compute the Density of these parameters
vDensities1 = ParaDensity(estimpara1 )
vDensities2 = ParaDensity(estimpara2 )

vDensities3   =  vDensities1 ./ vDensities2
JointDensity2 =  JointDensities(vDensities3, estimpararestric,regime, subsorcompl)
prod(JointDensity2)
"

;
