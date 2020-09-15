## Converting Mode Vector and Var-Cov Matrix from Leeper
## suitable for our vector/matrix

# September 15th
path="/Users/yoshiki/Dropbox/Morass/MyJuliaCode/0904/"
using MAT, JLD
cd(path)

# Leeper's Mode and Var-Cov
file1  = read(matopen("SaveModeHessian.mat")) # load data
Leeper_mode = file1["mode"]
Leeper_Cov  = file1["inverseHessianmode"]

# My Mode and Cov Matrix
file2 = load("DrawsN10000_model_43.jld") # you can load this data
my_mode = file2["Mean"]
my_Cov  = file2["CovMatrix"]


function transform_F(Leeper_mode) # 35 elements
    γ=Leeper_mode[1]
    ξ=Leeper_mode[2]
    θ=Leeper_mode[29]
    μ=1
    α_G=Leeper_mode[30]
    ψ=Leeper_mode[5]
    s=Leeper_mode[6]
    ω_p=Leeper_mode[4]
    ω_w=Leeper_mode[3]
    χ_p=Leeper_mode[8]
    χ_w=Leeper_mode[7]
    ϕ_πM=Leeper_mode[9]
    ϕ_πF=1
    ϕ_y=Leeper_mode[10]
    ρ_r=Leeper_mode[15]
    γ_GM=Leeper_mode[11]
    γ_KM=1
    γ_LM=1
    γ_ZM=Leeper_mode[12]
    γ_GF=1
    γ_KF=1
    γ_LF=1
    γ_ZF=1
    ρ_G=Leeper_mode[19]
    ρ_K=1
    ρ_L=1
    ρ_Z=Leeper_mode[20]
    ρ_a=Leeper_mode[13]
    ρ_b=Leeper_mode[14]
    ρ_i=Leeper_mode[16]
    ρ_p=Leeper_mode[18]
    ρ_w=Leeper_mode[17]
    ρ_em=Leeper_mode[31]
    ρ_eg=Leeper_mode[32]
    ρ_ez=Leeper_mode[33]
    σ_a=Leeper_mode[21]
    σ_b=Leeper_mode[22]
    σ_i=Leeper_mode[24]
    σ_p=Leeper_mode[26]
    σ_w=Leeper_mode[25]
    σ_em=Leeper_mode[23]
    σ_eg=Leeper_mode[27]
    σ_ez=Leeper_mode[28]
    
    Mode_trans = [γ,ξ,θ,μ,α_G,ψ,s,ω_p,ω_w,
        χ_p,χ_w,ϕ_πM,ϕ_πF,ϕ_y,ρ_r,
        γ_GM,γ_KM,γ_LM,γ_ZM,γ_GF,γ_KF,γ_LF,γ_ZF,
        ρ_G,ρ_K,ρ_L,ρ_Z,ρ_a,ρ_b,ρ_i,ρ_p,ρ_w,ρ_em,ρ_eg,ρ_ez ,
        σ_a,σ_b,σ_i,σ_p,σ_w,σ_em,σ_eg,σ_ez]

    return Mode_trans
end

function transform_M(Leeper_mode) # 35 elements
    γ=Leeper_mode[1]
    ξ=Leeper_mode[2]
    θ=Leeper_mode[28]
    μ=1
    α_G=Leeper_mode[29]
    ψ=Leeper_mode[5]
    s=Leeper_mode[6]
    ω_p=Leeper_mode[4]
    ω_w=Leeper_mode[3]
    χ_p=Leeper_mode[8]
    χ_w=Leeper_mode[7]
    ϕ_πM=Leeper_mode[9]
    ϕ_πF=1
    ϕ_y=Leeper_mode[10]
    ρ_r=Leeper_mode[15]
    γ_GM=Leeper_mode[11]
    γ_KM=1
    γ_LM=1
    γ_ZM=Leeper_mode[12]
    γ_GF=1
    γ_KF=1
    γ_LF=1
    γ_ZF=1
    ρ_G=Leeper_mode[19]
    ρ_K=1
    ρ_L=1
    ρ_Z=1
    ρ_a=Leeper_mode[13]
    ρ_b=Leeper_mode[14]
    ρ_i=Leeper_mode[16]
    ρ_p=Leeper_mode[18]
    ρ_w=Leeper_mode[17]
    ρ_em=Leeper_mode[30]
    ρ_eg=Leeper_mode[31]
    ρ_ez=Leeper_mode[32]
    σ_a=Leeper_mode[20]
    σ_b=Leeper_mode[21]
    σ_i=Leeper_mode[23]
    σ_p=Leeper_mode[25]
    σ_w=Leeper_mode[24]
    σ_em=Leeper_mode[22]
    σ_eg=Leeper_mode[26]
    σ_ez=Leeper_mode[27]

    Mode_trans = [γ,ξ,θ,μ,α_G,ψ,s,ω_p,ω_w,
        χ_p,χ_w,ϕ_πM,ϕ_πF,ϕ_y,ρ_r,
        γ_GM,γ_KM,γ_LM,γ_ZM,γ_GF,γ_KF,γ_LF,γ_ZF,
        ρ_G,ρ_K,ρ_L,ρ_Z,ρ_a,ρ_b,ρ_i,ρ_p,ρ_w,ρ_em,ρ_eg,ρ_ez ,
        σ_a,σ_b,σ_i,σ_p,σ_w,σ_em,σ_eg,σ_ez]

    return Mode_trans

end


Leeper_mode_2 = transform_M(Leeper_mode)

# Compare
Mode_compare = [Leeper_mode_2, my_mode]
println([Leeper_mode, my_mode])
