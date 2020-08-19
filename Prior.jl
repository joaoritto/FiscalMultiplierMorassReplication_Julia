## Draw Parameters From Prior Distribution
# August 19th, Yoshiki

using Distributions
## γ ∼ N(0.4, 0.05) # Steady State ln growth
μ_γ = 0.4; σ_γ = 0.05;
γ   = rand(Normal(μ_γ, σ_γ)) / 100 ;

## ξ ∼ Γ(0.2, 0.5)  # Inverse Frisch labor elasticity
μ_ξ = 2.0; σ_ξ = 0.5;
α_ξ = μ_ξ^2 / σ_ξ^2 ; # compute α in Γ dist
β_ξ = σ_ξ^2 / μ_ξ ;   # compute β in Γ dist
ξ   = rand(Gamma(α_ξ, β_ξ))

# Check that it works correctly
# vξ   = [rand(Gamma(α_ξ, β_ξ)) for i=1:10000]
# mean(vξ ), std(vξ)

## θ ∼ Β(0.5, 0.2)  # Habit formation
μ_θ = 0.5; σ_θ = 0.2;
α_θ = ( (1-μ_θ)/σ_θ^2 - 1/μ_θ ) * μ_θ^2 ; # compute α in Β dist
β_Θ = α_θ * (1/μ_θ - 1);                  # compute β in Β dist
θ   = rand(Beta(α_θ, β_Θ))

# Check that it works correctly
# vθ   = [rand(Beta(α_θ, β_Θ)) for i=1:10000]
# mean(vθ ), std(vθ)

## μ ∼ Β(0.3, 0.1) # Fraction of non-savers
# Command+Shift to have multiple cursors
μ_μ = 0.3; σ_μ = 0.1;
α_μ = ( (1-μ_μ)/σ_μ^2 - 1/μ_μ ) * μ_μ^2 ; # compute α in Β dist
β_μ = α_μ * (1/μ_μ - 1);                  # compute β in Β dist
μ   = rand(Beta(α_μ, β_μ))

# Check that it works correctly
# vμ   = [rand(Beta(α_μ, β_μ)) for i=1:10000]
# mean(vμ ), std(vμ)

## α_G ∼ Uni(0,1.01) # Substitutability of private/public consumption
μ_α_G  = 0.0; σ_α_G = 1.01;
β_α_G  =  μ_α_G + 3^0.5 * σ_α_G
α_α_G  =  2 * μ_α_G - β_α_G
α_G    = rand(Uniform(α_α_G, β_α_G))

# Check that it works correctly
# vα_G   = [rand(Uniform(α_α_G, β_α_G)) for i=1:100_000]
# mean(vα_G ), std(vα_G)

## Ψ ∼ Β(0.6,0.15)  # Capital utilization
μ_Ψ = 0.6; σ_Ψ = 0.15;
α_Ψ = ( (1-μ_Ψ)/σ_Ψ^2 - 1/μ_Ψ ) * μ_Ψ^2 ; # compute α in Β dist
β_Ψ = α_Ψ * (1/μ_Ψ - 1);                  # compute β in Β dist
Ψ   = rand(Beta(α_Ψ, β_Ψ))

# Check that it works correctly
# vΨ   = [rand(Beta(α_Ψ, β_Ψ)) for i=1:10000]
# mean(vΨ ), std(vΨ)

## s ∼ N(6,0.15) # Investment adjustment cost
μ_s = 6; σ_s = 0.15;
s   = rand(Normal(μ_s, σ_s))  ;
# vs   = [rand(Normal(μ_s, σ_s)) for i=1:10000]
# mean(vs ), std(vs)

## ω_p ∼ Β(0.5, 0.2) # Price stickiness
μ_ω_p = 0.5; σ_ω_p = 0.2;
α_ω_p = ( (1-μ_ω_p)/σ_ω_p^2 - 1/μ_ω_p ) * μ_ω_p^2 ; # compute α in Β dist
β_ω_p = α_ω_p * (1/μ_ω_p - 1);                  # compute β in Β dist
ω_p   = rand(Beta(α_ω_p, β_ω_p))

# vω_p   = [rand(Beta(α_ω_p, β_ω_p)) for i=1:10000]
# mean(vω_p ), std(vω_p)

## χ_p∼Β(0.5,0.2) # Price partial indexation
μ_χ_p = 0.5; σ_χ_p = 0.2;
α_χ_p = ( (1-μ_χ_p)/σ_χ_p^2 - 1/μ_χ_p ) * μ_χ_p^2 ; # compute α in Β dist
β_χ_p = α_ω_p * (1/μ_χ_p - 1);                  # compute β in Β dist
χ_p   = rand(Beta(α_χ_p, β_χ_p))

# vχ_p   = [rand(Beta(α_χ_p, β_χ_p)) for i=1:10000]
# mean(vχ_p ), std(vχ_p)

## χ_w∼Β(0.5,0.2) # Wage partial indexation
μ_χ_w = 0.5; σ_χ_w = 0.2;
α_χ_w = ( (1-μ_χ_w)/σ_χ_w^2 - 1/μ_χ_w ) * μ_χ_w^2 ; # compute α in Β dist
β_χ_w = α_χ_w * (1/μ_χ_w - 1);                  # compute β in Β dist
χ_w   = rand(Beta(α_χ_w, β_χ_w))

# vχ_w   = [rand(Beta(α_χ_w, β_χ_w)) for i=1:10000]
# mean(vχ_w ), std(vχ_w)

## ϕ_πM∼N(1.5,0.2) # Interest rate response to inflation, regime M
μ_ϕ_πM = 1.5; σ_ϕ_πM = 0.2;
ϕ_πM   = rand(Normal(μ_ϕ_πM, σ_ϕ_πM))  ;
# vϕ_πM   = [rand(Normal(μ_ϕ_πM, σ_ϕ_πM)) for i=1:10000]
# mean(vϕ_πM ), std(vϕ_πM)

## ϕ_πF∼Β(0.5,0.15) # Interest rate response to inflation, regime F
function myBeta(μ,σ) #return a draw from Beta Dist with (μ,σ)
   α = ( (1-μ)/σ^2 - 1/μ ) * μ^2 ; # compute α in Β dist
   β = α * (1/μ - 1);          # compute β in Β dist
   draw = rand(Beta(α, β))
   return draw
end

ϕ_πF = myBeta(0.5,0.15)
# vϕ_πF   = [myBeta(0.5,0.15) for i=1:10000]
#  mean(vϕ_πF ), std(vϕ_πF)

## ϕ_y∼N(0.125,0.05) # Interest rate response to output
ϕ_πM   = rand(Normal(0.125, 0.05))

## ρ_r ∼ Β(0.5,0.2) # Response to lagged interest rate
ρ_r = myBeta(0.5,0.2)

## Fiscal policy
# γ_GM∼N(0.15,0.1) # Debt response for expenditures, regime M
γ_GM = rand(Normal(0.15, 0.1))

# γ_KM∼N(0.15,0.1) # Debt response for capital taxes, regime M
γ_KM = rand(Normal(0.15, 0.1))

# γ_LM∼N(0.15,0.1) # Debt response for labor taxes, regime M
γ_LM = rand(Normal(0.15, 0.1))

# γ_ZM∼N(0.15,0.1) # Debt response for transfers, regime M
γ_ZM = rand(Normal(0.15, 0.1))

# γ_GF∼N(0.0,0.001) # Debt response for expenditures, regime F
γ_GF = rand(Normal(0.0, 0.001))

# γ_KF∼N(0.0,0.001) # Debt response for capital taxes, regime F
γ_KF = rand(Normal(0.0, 0.001))

# γ_LF∼N(0.0,0.001) # Debt response for labor taxes, regime F
γ_LF = rand(Normal(0.0, 0.001))

# γ_ZF∼N(0.0,0.001) # Debt response for transfers, regime F
γ_ZF = rand(Normal(0.0, 0.001))

## ρ_G∼Β(0.5,0.2) # Lagged response for expenditures
ρ_G = myBeta(0.5,0.2)

# ρ_K∼Β(0.5,0.2) # Lagged response for capital taxes
ρ_K = myBeta(0.5,0.2)

# ρ_L ∼Β(0.5,0.2) # Lagged response for labor taxes
ρ_L = myBeta(0.5,0.2)

# ρ_Z ∼Β(0.5,0.2) # Lagged response for transfers
ρ_Z = myBeta(0.5,0.2)

## Shocks
ρ_a =myBeta(0.5,0.2) # Autoregressive parameter, technology shock
ρ_b =myBeta(0.5,0.2) # Autoregressive parameter, preference shock
ρ_i =myBeta(0.5,0.2) # Autoregressive parameter, investment shock
ρ_p =myBeta(0.5,0.2) # Autoregressive parameter, price markup shock
ρ_w =myBeta(0.5,0.2) # Autoregressive parameter, wage markup shock
ρ_em=myBeta(0.5,0.15) # Autoregressive parameter, monetary policy shock
ρ_eg=myBeta(0.5,0.15) # Autoregressive parameter, government consumption shock
ρ_ez=myBeta(0.5,0.15) # Autoregressive parameter, transfers shock


## Standard Deviation
function myInvΓ(μ,σ)
   α = μ^2/σ^2 + 2
   θ = μ* ( α -1)
   draw = rand(InverseGamma(α,θ))

   draw2 = rand(Gamma(α,θ))
#   draw  = 1/draw2
   return draw
end

v_try = [myInvΓ(0.1,1.0) for i = 1:1000]
mean(v_try), std(v_try)
percentile(v_try, 0.1), percentile(v_try, 0.9)

v_try2 = [rand(InverseGamma(5,5)) for i = 1:1000]
mean(v_try2), std(v_try2)
v_try3 = [myInvΓ(mean(v_try2),std(v_try2)) for i = 1:1000]
mean(v_try3), std(v_try3)


params(InverseGamma(0.1,1.0))

σ_a=0.1/100 # Standard deviation, technology shock
σ_b=0.1/100 # Standard deviation, preference shock
σ_i=0.1/100 # Standard deviation, investment shock
σ_p=0.1/100 # Standard deviation, price markup shock
σ_w=0.1/100 # Standard deviation, wage markup shock
σ_em=0.1/100 # Standard deviation, monetary policy shock
σ_eg=0.1/100 # Standard deviation, government consumption shock
σ_ez=0.1/100 # Standard deviation, transfers shock
