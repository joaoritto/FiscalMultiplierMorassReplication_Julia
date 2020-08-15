# Model

# Parameter values

# Calibrated parameters
AD=20 # Average duration of government debt
β=0.99 # Discount factor
α=0.33 # Capital income share
δ=0.025 # Capital depreciation
η_p=0.14 # Price markup
η_w=0.14 # Wage markup
gy=0.11 # Steady state share of government consumption in gdp (g/y)
by=1.47 # Steady state government debt to gdp
π_ss=1 # Steady state inflation
τK=0.218 # Steady state capital taxation
τL=0.186 # Steady state labor taxation
τC=0.023 # Steady state consumption taxation

# Estimated parameters

function estimatedpara()

    # Preferences and HHs
    γ=0.4/100 # Steady State ln growth
    ξ=2.0 # Inverse Frisch labor elasticity
    θ=0.5 # Habit formation
    μ=0.3 # Fraction of non-savers
    α_G=0.0 # Substitutability of private/public consumption

    # Frictions and production
    ψ=0.6 # Capital utilization
    s=6 # Investment adjustment cost
    ω_p=0.5 # Price stickiness
    ω_w=0.5 # Wage stickiness
    χ_p=0.5 # Price partial indexation
    χ_w=0.5 # Wage partial indexation

    # Monetary policy
    ϕ_πM=1.5 # Interest rate response to inflation, regime M
    ϕ_πF=0.5 # Interest rate response to inflation, regime F
    ϕ_y=0.125 # Interest rate response to output
    ρ_r=0.5 # Response to lagged interest rate

    # Fiscal policy
    γ_GM=0.15 # Debt response for expenditures, regime M
    γ_KM=0.15 # Debt response for capital taxes, regime M
    γ_LM=0.15 # Debt response for labor taxes, regime M
    γ_ZM=0.15 # Debt response for transfers, regime M
    γ_GF=0.0 # Debt response for expenditures, regime F
    γ_KF=0.0 # Debt response for capital taxes, regime F
    γ_LF=0.0 # Debt response for labor taxes, regime F
    γ_ZF=0.0 # Debt response for transfers, regime F
    ρ_G=0.5 # Lagged response for expenditures
    ρ_K=0.5 # Lagged response for capital taxes
    ρ_L=0.5 # Lagged response for labor taxes
    ρ_Z=0.5 # Lagged response for transfers

    # Shocks
    ρ_a=0.5 # Autoregressive parameter, technology shock
    ρ_b=0.5 # Autoregressive parameter, preference shock
    ρ_i=0.5 # Autoregressive parameter, investment shock
    ρ_p=0.5 # Autoregressive parameter, price markup shock
    ρ_w=0.5 # Autoregressive parameter, wage markup shock
    ρ_em=0.5 # Autoregressive parameter, monetary policy shock
    ρ_eg=0.5 # Autoregressive parameter, government consumption shock
    ρ_ez=0.5 # Autoregressive parameter, transfers shock
    σ_a=0.1/100 # Standard deviation, technology shock
    σ_b=0.1/100 # Standard deviation, preference shock
    σ_i=0.1/100 # Standard deviation, investment shock
    σ_p=0.1/100 # Standard deviation, price markup shock
    σ_w=0.1/100 # Standard deviation, wage markup shock
    σ_em=0.1/100 # Standard deviation, monetary policy shock
    σ_eg=0.1/100 # Standard deviation, government consumption shock
    σ_ez=0.1/100 # Standard deviation, transfers shock

    num_parameters=43
    parameters=zeros(num_parameters)

    parameters[1]=γ
    parameters[2]=ξ
    parameters[3]=θ
    parameters[4]=μ
    parameters[5]=α_G
    parameters[6]=ψ
    parameters[7]=s
    parameters[8]=ω_p
    parameters[9]=ω_w
    parameters[10]=χ_p
    parameters[11]=χ_w
    parameters[12]=ϕ_πM
    parameters[13]=ϕ_πF
    parameters[14]=ϕ_y
    parameters[15]=ρ_r
    parameters[16]=γ_GM
    parameters[17]=γ_KM
    parameters[18]=γ_LM
    parameters[19]=γ_ZM
    parameters[20]=γ_GF
    parameters[21]=γ_KF
    parameters[22]=γ_LF
    parameters[23]=γ_ZF
    parameters[24]=ρ_G
    parameters[25]=ρ_K
    parameters[26]=ρ_L
    parameters[27]=ρ_Z
    parameters[28]=ρ_a
    parameters[29]=ρ_b
    parameters[30]=ρ_i
    parameters[31]=ρ_p
    parameters[32]=ρ_w
    parameters[33]=ρ_em
    parameters[34]=ρ_eg
    parameters[35]=ρ_ez
    parameters[36]=σ_a
    parameters[37]=σ_b
    parameters[38]=σ_i
    parameters[39]=σ_p
    parameters[40]=σ_w
    parameters[41]=σ_em
    parameters[42]=σ_eg
    parameters[43]=σ_ez

    return parameters
end

para=estimatedpara()

γ=para[1]
ξ=para[2]
θ=para[3]
μ=para[4]
α_G=para[5]
ψ=para[6]
s=para[7]
ω_p=para[8]
ω_w=para[9]
χ_p=para[10]
χ_w=para[11]
ϕ_πM=para[12]
ϕ_πF=para[13]
ϕ_y=para[14]
ρ_r=para[15]
γ_GM=para[16]
γ_KM=para[17]
γ_LM=para[18]
γ_ZM=para[19]
γ_GF=para[20]
γ_KF=para[21]
γ_LF=para[22]
γ_ZF=para[23]
ρ_K=para[24]
ρ_G=para[25]
ρ_L=para[26]
ρ_Z=para[27]
ρ_a=para[28]
ρ_b=para[29]
ρ_i=para[30]
ρ_p=para[31]
ρ_w=para[32]
ρ_em=para[33]
ρ_eg=para[34]
ρ_ez=para[35]
σ_a=para[36]
σ_b=para[37]
σ_i=para[38]
σ_p=para[39]
σ_w=para[40]
σ_em=para[41]
σ_eg=para[42]
σ_ez=para[43]


regime="M"

# Finding the Steady State

v=1
R=exp(γ)/β
ρ=(1-1/AD)*(1/β)
PB=β/(exp(γ)-ρ*β)
rk=((exp(γ)/β)-1+δ)/(1-τK)
phider1=rk*(1-τK)
mc=1/(1+η_p)
w=(mc*(1-α)^(1-α)*α^α*rk^(-α))^(1/(1-α))
kL=(w/rk)*(α/(1-α))
ΩL=kL^α-rk*kL-w
yL=kL^α-ΩL
iL=(1-(1-δ)*exp(-γ))*exp(γ)*kL
cL=yL*(1-gy)-iL
zL=((1-R*exp(-γ))*by-gy)*yL+τC*cL+τL*w+τK*rk*kL
cNL=((1-τL)*w+zL)/(1+τC)
cSL=(cL-μ*cNL)/(1-μ)
cstarSL=cSL+α_G*gy*yL
L=(((w*(1-τL))/((1+τC)*(1+η_w)))*(1/((1-θ*exp(-γ))*cstarSL)))^(1/(ξ+1))
k=kL*L
Ω=ΩL*L
y=yL*L
i=iL*L
c=cL*L
z=zL*L
cN=cNL*L
cS=cSL*L
g=gy*y
b=by*y


# Log-linearized model

# Variable indices

# Real variables
y_var=1 # Output
c_var=2 # Consumption
cS_var=3 # Consumption of savers
cN_var=4 # Consumption of non-savers
λS_var=5 # Lagrange multiplier savers' budget constraint
g_var=6 # Government consumption
i_var=7 # Investment
q_var=8 # Tobin's q
k_var=9 # Capital
kbar_var=10 # Effective capital
v_var=11 # Capital utilization
L_var=12 # Labor

# Price variables
π_var=13 # Inflation
mc_var=14 # Marginal cost
w_var=15 # Wages
rk_var=16 # Return on capital
PB_var=17 # Price of long-term bonds
R_var=18 # Return of short-term bonds

# Fiscal variables
b_var=19 # Government debt
τK_var=20 # Capital taxes
τL_var=21 # Labor taxes
τC_var=22 # Consumption taxes
z_var=23 # Transfers

# Shocks
ua_var=24 # Technology shock
ub_var=25 # Preference shock
ui_var=26 # Investment shock
up_var=27 # Price markup shock
uw_var=28 # Wage markup shock
uem_var=29 # Monetary policy shock
ueg_var=30 # Government consumption shock
uez_var=31 # Transfers shock

# Lagged variables
πL_var=32 # Lagged inflation
wL_var=33 # Lagged wages
iL_var=34 # Lagged investment
uaL_var=35 # Lagged technology shock

# Expectation errors
i_experr=1
λS_experr=2
q_experr=3
π_experr=4
w_experr=5
rk_experr=6
PB_experr=7
ua_experr=8
τK_experr=9

# Innovations
epsa_innov=1
epsb_innov=2
epsi_innov=3
epsp_innov=4
epsw_innov=5
epsem_innov=6
epseg_innov=7
epsez_innov=8

# Equation indices
productionfunction_eq=1
capitallaborratio_eq=2
marginalcost_eq=3
phillipscurve_eq=4
hhfocconsumption_eq=5
euler_eq=6
maturitystructuredebt_eq=7
hhfoccapacityutilization_eq=8
hhfoccapital_eq=9
hhfocinvestment_eq=10
effectivecapital_eq=11
lawofmotioncapital_eq=12
nonsaversbudgetconstraint_eq=13
wage_eq=14
agghhconsumption_eq=15
aggresourceconstraint_eq=16
governmentbudgetconstraint_eq=17
monetarypolicyrule_eq=18
governmentconsumption_eq=19
capitaltaxes_eq=20
labortaxes_eq=21
consumptiontaxes_eq=22
transfers_eq=23
artechnology_eq=24
arpreference_eq=25
arinvestment_eq=26
arpricemarkup_eq=27
arwagemarkup_eq=28
armonetarypolicy_eq=29
argovernmentconsumption_eq=30
artransfers_eq=31
laggedinflation_eq=32
laggedwage_eq=33
laggedinvestment_eq=34
laggedtechnologyshock_eq=35

# Writing the equations

# Γ_0 y_t=Γ_1 y_{t-1} + constant + Ψ z_t + Π η_t

num_var=35
num_eq=35 # Needs to be the same as num_var!
num_shocks=8
num_experr=9

Γ_0=zeros(num_eq,num_var)
Γ_1=zeros(num_eq,num_var)
constant=zeros(num_eq)
Ψ=zeros(num_eq,num_shocks)
Π=zeros(num_eq,num_experr)

# 1. Production function
Γ_0[productionfunction_eq,y_var]=1
Γ_0[productionfunction_eq,k_var]=-((y+Ω)/y)*α
Γ_0[productionfunction_eq,L_var]=-((y+Ω)/y)*(1-α)

# 2. Capital-labor ratio
Γ_0[capitallaborratio_eq,rk_var]=1
Γ_0[capitallaborratio_eq,w_var]=-1
Γ_0[capitallaborratio_eq,L_var]=-1
Γ_0[capitallaborratio_eq,k_var]=1

# 3. Marginal cost
Γ_0[marginalcost_eq,mc_var]=1
Γ_0[marginalcost_eq,rk_var]=α
Γ_0[marginalcost_eq,w_var]=1-α

# 4. Phillips curve
κ_p=((1-β*ω_p)*(1-ω_p))/(ω_p*(1+β*χ_p))

Γ_0[phillipscurve_eq,π_var]=-β/(1+χ_p*β)

Γ_1[phillipscurve_eq,π_var]=-1
Γ_1[phillipscurve_eq,πL_var]=χ_p/(1+χ_p*β)
Γ_1[phillipscurve_eq,mc_var]=κ_p
Γ_1[phillipscurve_eq,up_var]=1

Π[phillipscurve_eq,π_experr]=-β/(1+χ_p*β)

# 5. Household FOC for consumption
Γ_0[hhfocconsumption_eq,λS_var]=1
Γ_0[hhfocconsumption_eq,ua_var]=-(1-(exp(γ)/(exp(γ)-θ)))
Γ_0[hhfocconsumption_eq,ub_var]=-1
Γ_0[hhfocconsumption_eq,cS_var]=(exp(γ)/(exp(γ)-θ))*(cS/(cS+α_G*g))
Γ_0[hhfocconsumption_eq,g_var]=(exp(γ)/(exp(γ)-θ))*(α_G*g/(cS+α_G*g))
Γ_0[hhfocconsumption_eq,τC_var]=τC/(1+τC)

Γ_1[hhfocconsumption_eq,cS_var]=θ/(exp(γ)-θ)*(cS/(cS+α_G*g))
Γ_1[hhfocconsumption_eq,g_var]=θ/(exp(γ)-θ)*(α_G*g/(cS+α_G*g))

# 6. Euler equation
Γ_0[euler_eq,λS_var]=-1
Γ_0[euler_eq,π_var]=1
Γ_0[euler_eq,ua_var]=1

Γ_1[euler_eq,λS_var]=-1
Γ_1[euler_eq,R_var]=1

Π[euler_eq,λS_experr]=-1
Π[euler_eq,π_experr]=1
Π[euler_eq,ua_experr]=1

# 7. Maturity Structure of Debt
Γ_0[maturitystructuredebt_eq,PB_var]=-ρ/R

Γ_1[maturitystructuredebt_eq,PB_var]=-1
Γ_1[maturitystructuredebt_eq,R_var]=-1

# 8. Household FOC for capacity utilization
Γ_0[hhfoccapacityutilization_eq,rk_var]=1
Γ_0[hhfoccapacityutilization_eq,τK_var]=-τK/(1-τK)
Γ_0[hhfoccapacityutilization_eq,v_var]=-ψ/(1-ψ)

# 9. Household FOC for capital
Γ_0[hhfoccapital_eq,q_var]=-β*exp(-γ)*(1-δ)
Γ_0[hhfoccapital_eq,rk_var]=-β*exp(-γ)*(1-τK)*rk
Γ_0[hhfoccapital_eq,τK_var]=β*exp(-γ)*τK*rk
Γ_0[hhfoccapital_eq,λS_var]=-1
Γ_0[hhfoccapital_eq,ua_var]=1

Γ_1[hhfoccapital_eq,q_var]=-1
Γ_1[hhfoccapital_eq,λS_var]=-1

Π[hhfoccapital_eq,q_experr]=-β*exp(-γ)*(1-δ)
Π[hhfoccapital_eq,rk_experr]=-β*exp(-γ)*(1-τK)*rk
Π[hhfoccapital_eq,τK_experr]=β*exp(-γ)*τK*rk
Π[hhfoccapital_eq,λS_experr]=-1
Π[hhfoccapital_eq,ua_experr]=1

# 10. Household FOC for investment
Γ_0[hhfocinvestment_eq,i_var]=-β/(1+β)
Γ_0[hhfocinvestment_eq,ua_var]=-β/(1+β)

Γ_1[hhfocinvestment_eq,i_var]=-1
Γ_1[hhfocinvestment_eq,ua_var]=-1/(1+β)
Γ_1[hhfocinvestment_eq,ui_var]=1
Γ_1[hhfocinvestment_eq,iL_var]=1/(1+β)

Π[hhfocinvestment_eq,i_experr]=-β/(1+β)
Π[hhfocinvestment_eq,ua_experr]=-β/(1+β)

# 11. Effective capital
Γ_0[effectivecapital_eq,k_var]=1
Γ_0[effectivecapital_eq,v_var]=-1
Γ_0[effectivecapital_eq,ua_var]=1

Γ_1[effectivecapital_eq,kbar_var]=1

# 12. Law of motion for capital
Γ_0[lawofmotioncapital_eq,kbar_var]=1
Γ_0[lawofmotioncapital_eq,ua_var]=(1-δ)*exp(-γ)
Γ_0[lawofmotioncapital_eq,ui_var]=-(1-(1-δ)*exp(-γ))*(1+β)*s*exp(2*γ)
Γ_0[lawofmotioncapital_eq,i_var]=-(1-(1-δ)*exp(-γ))

Γ_1[lawofmotioncapital_eq,kbar_var]=(1-δ)*exp(-γ)

# 13. Nonsavers' real budget constraint
Γ_0[nonsaversbudgetconstraint_eq,τC_var]=τC*cN
Γ_0[nonsaversbudgetconstraint_eq,cN_var]=(1+τC)*cN
Γ_0[nonsaversbudgetconstraint_eq,w_var]=-(1-τL)*w*L
Γ_0[nonsaversbudgetconstraint_eq,L_var]=-(1-τL)*w*L
Γ_0[nonsaversbudgetconstraint_eq,τL_var]=τL*w*L
Γ_0[nonsaversbudgetconstraint_eq,z_var]=-z

# 14. Wage equation
κ_w=((1-β*ω_w)*(1-ω_w))/(ω_w*(1+β)*(1+((1+η_w)*ξ)/η_w))

Γ_0[wage_eq,w_var]=-β/(1+β)
Γ_0[wage_eq,π_var]=-β/(1+β)

Γ_1[wage_eq,w_var]=-1-κ_w
Γ_1[wage_eq,L_var]=κ_w*ξ
Γ_1[wage_eq,ub_var]=κ_w
Γ_1[wage_eq,λS_var]=-κ_w
Γ_1[wage_eq,τL_var]=κ_w*(τL/(1-τL))
Γ_1[wage_eq,π_var]=-(1+β*χ_w)/(1+β)
Γ_1[wage_eq,ua_var]=-(1+β*χ_w-ρ_a*β)/(1+β)
Γ_1[wage_eq,uw_var]=1
Γ_1[wage_eq,wL_var]=1/(1+β)
Γ_1[wage_eq,πL_var]=χ_w/(1+β)
Γ_1[wage_eq,uaL_var]=χ_w/(1+β)

Π[wage_eq,w_experr]=-β/(1+β)
Π[wage_eq,π_experr]=-β/(1+β)

# 15. Aggregation of household consumption
Γ_0[agghhconsumption_eq,c_var]=c
Γ_0[agghhconsumption_eq,cS_var]=-cS*(1-μ)
Γ_0[agghhconsumption_eq,cN_var]=-cN*μ

# 16. Aggregate resource constraint
Γ_0[aggresourceconstraint_eq,y_var]=y
Γ_0[aggresourceconstraint_eq,c_var]=-c
Γ_0[aggresourceconstraint_eq,g_var]=-g
Γ_0[aggresourceconstraint_eq,i_var]=-i
Γ_0[aggresourceconstraint_eq,v_var]=-phider1*k

# 17. Government Budget Constraint
Γ_0[governmentbudgetconstraint_eq,b_var]=by
Γ_0[governmentbudgetconstraint_eq,τK_var]=τK*rk*(k/y)
Γ_0[governmentbudgetconstraint_eq,rk_var]=τK*rk*(k/y)
Γ_0[governmentbudgetconstraint_eq,k_var]=τK*rk*(k/y)
Γ_0[governmentbudgetconstraint_eq,τL_var]=τL*w*(L/y)
Γ_0[governmentbudgetconstraint_eq,w_var]=τL*w*(L/y)
Γ_0[governmentbudgetconstraint_eq,L_var]=τL*w*(L/y)
Γ_0[governmentbudgetconstraint_eq,τC_var]=τC*(c/y)
Γ_0[governmentbudgetconstraint_eq,c_var]=τC*(c/y)
Γ_0[governmentbudgetconstraint_eq,π_var]=(1/β)*(by)
Γ_0[governmentbudgetconstraint_eq,ua_var]=(1/β)*(by)
Γ_0[governmentbudgetconstraint_eq,PB_var]=-(by)*(ρ/exp(γ))
Γ_0[governmentbudgetconstraint_eq,g_var]=-(gy)
Γ_0[governmentbudgetconstraint_eq,z_var]=-(z/y)

Γ_1[governmentbudgetconstraint_eq,b_var]=(1/β)*(by)
Γ_1[governmentbudgetconstraint_eq,PB_var]=-(1/β)*(by)

# 18. Monetary policy rule
Γ_0[monetarypolicyrule_eq,R_var]=1
Γ_0[monetarypolicyrule_eq,uem_var]=-1
Γ_0[monetarypolicyrule_eq,y_var]=-(1-ρ_r)*ϕ_y
if regime=="M"
    Γ_0[monetarypolicyrule_eq,π_var]=-(1-ρ_r)*ϕ_πM
else
    Γ_0[monetarypolicyrule_eq,π_var]=-(1-ρ_r)*ϕ_πF
end

Γ_1[monetarypolicyrule_eq,R_var]=ρ_r

# 19. Government consumption equation
Γ_0[governmentconsumption_eq,g_var]=1
Γ_0[governmentconsumption_eq,ueg_var]=-1

Γ_1[governmentconsumption_eq,g_var]=ρ_G
if regime=="M"
    Γ_1[governmentconsumption_eq,b_var]=-(1-ρ_G)*γ_GM
    Γ_1[governmentconsumption_eq,y_var]=(1-ρ_G)*γ_GM
else
    Γ_1[governmentconsumption_eq,b_var]=-(1-ρ_G)*γ_GF
    Γ_1[governmentconsumption_eq,y_var]=(1-ρ_G)*γ_GF
end

# 20. Capital taxes equation
Γ_0[capitaltaxes_eq,τK_var]=1

Γ_1[capitaltaxes_eq,τK_var]=ρ_K
if regime=="M"
    Γ_1[capitaltaxes_eq,b_var]=(1-ρ_K)*γ_KM
    Γ_1[capitaltaxes_eq,y_var]=-(1-ρ_K)*γ_KM
else
    Γ_1[capitaltaxes_eq,b_var]=(1-ρ_K)*γ_KF
    Γ_1[capitaltaxes_eq,y_var]=-(1-ρ_K)*γ_KF
end

# 21. Labor taxes equation
Γ_0[labortaxes_eq,τL_var]=1

Γ_1[labortaxes_eq,τL_var]=ρ_L
if regime=="M"
    Γ_1[labortaxes_eq,b_var]=(1-ρ_L)*γ_LM
    Γ_1[labortaxes_eq,y_var]=-(1-ρ_L)*γ_LM
else
    Γ_1[labortaxes_eq,b_var]=(1-ρ_L)*γ_LF
    Γ_1[labortaxes_eq,y_var]=-(1-ρ_L)*γ_LF
end

# 22. Consumption taxes equation
Γ_0[consumptiontaxes_eq,τC_var]=1

# 23. Transfers equation
Γ_0[transfers_eq,z_var]=1
Γ_0[transfers_eq,uez_var]=-1

Γ_1[transfers_eq,z_var]=ρ_Z
if regime=="M"
    Γ_1[transfers_eq,b_var]=-(1-ρ_Z)*γ_ZM
    Γ_1[transfers_eq,y_var]=(1-ρ_Z)*γ_ZM
else
    Γ_1[transfers_eq,b_var]=-(1-ρ_Z)*γ_ZF
    Γ_1[transfers_eq,y_var]=(1-ρ_Z)*γ_ZF
end

# 24. Autoregressive process for technology shock
Γ_0[artechnology_eq,ua_var]=1

Γ_1[artechnology_eq,ua_var]=ρ_a

Ψ[artechnology_eq,epsa_innov]=σ_a

# 25. Autoregressive process for preference shock
Γ_0[arpreference_eq,ub_var]=1

Γ_1[arpreference_eq,ub_var]=ρ_b

Ψ[arpreference_eq,epsb_innov]=σ_b

# 26. Autoregressive process for investment shock
Γ_0[arinvestment_eq,ui_var]=1

Γ_1[arinvestment_eq,ui_var]=ρ_i

Ψ[arinvestment_eq,epsi_innov]=σ_i

# 27. Autoregressive process for price markup shock
Γ_0[arpricemarkup_eq,up_var]=1

Γ_1[arpricemarkup_eq,up_var]=ρ_p

Ψ[arpricemarkup_eq,epsp_innov]=σ_p

# 28. Autoregressive process for wage markup shock
Γ_0[arwagemarkup_eq,uw_var]=1

Γ_1[arwagemarkup_eq,uw_var]=ρ_w

Ψ[arwagemarkup_eq,epsw_innov]=σ_w

# 29. Autoregressive process for monetary policy shock
Γ_0[armonetarypolicy_eq,uem_var]=1

Γ_1[armonetarypolicy_eq,uem_var]=ρ_em

Ψ[armonetarypolicy_eq,epsem_innov]=σ_em

# 30. Autoregressive process for government consumption shock
Γ_0[argovernmentconsumption_eq,ueg_var]=1

Γ_1[argovernmentconsumption_eq,ueg_var]=ρ_eg

Ψ[argovernmentconsumption_eq,epseg_innov]=σ_eg

# 31. Autoregressive process for transfers shock
Γ_0[artransfers_eq,uez_var]=1

Γ_1[artransfers_eq,uez_var]=ρ_ez

Ψ[artransfers_eq,epsez_innov]=σ_ez

# 32. Lagged inflation equation
Γ_0[laggedinflation_eq,πL_var]=1

Γ_1[laggedinflation_eq,π_var]=1

# 33. Lagged wage equation
Γ_0[laggedwage_eq,wL_var]=1

Γ_1[laggedwage_eq,w_var]=1

# 34. Lagged investment equation
Γ_0[laggedinvestment_eq,iL_var]=1

Γ_1[laggedinvestment_eq,i_var]=1

# 35. Lagged technology shock equation
Γ_0[laggedtechnologyshock_eq,uaL_var]=1

Γ_1[laggedtechnologyshock_eq,ua_var]=1
