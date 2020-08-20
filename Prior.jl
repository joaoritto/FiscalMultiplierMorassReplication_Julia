## Draw Parameters From Prior Distribution
# August 19th, Yoshiki

using Distributions
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

priorpara= = DrawParaFromPrior()

# aa = [DrawParaFromPrior() for i=1:10000]
# println(mean(aa))
