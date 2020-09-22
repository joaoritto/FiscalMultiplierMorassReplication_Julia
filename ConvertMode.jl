## Converting Mode Vector and Var-Cov Matrix from Leeper
## suitable for our vector/matrix

# September 15th
#path="/Users/yoshiki/Dropbox/Morass/MyJuliaCode/0904/"
#using MAT, JLD
#cd(path)

# Leeper's Mode and Var-Cov
#file1  = read(matopen("SaveModeHessian.mat")) # load data
#Leeper_mode = file1["mode"]
#Leeper_Cov  = file1["inverseHessianmode"]

# My Mode and Cov Matrix
#file2 = load("DrawsN10000_model_43.jld") # you can load this data
#my_mode = file2["Mean"]
#my_Cov  = file2["CovMatrix"]


function transform_F(Leeper_mode) # 35 elements
    γ=Leeper_mode[1]/100
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
    ϕ_πM=1
    ϕ_πF=Leeper_mode[9]
    ϕ_y=Leeper_mode[10]
    ρ_r=Leeper_mode[15]
    γ_GM=1
    γ_KM=1
    γ_LM=1
    γ_ZM=1
    γ_GF=Leeper_mode[11]
    γ_KF=1
    γ_LF=1
    γ_ZF=Leeper_mode[12]
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
    σ_a=Leeper_mode[21]/100
    σ_b=Leeper_mode[22]/100
    σ_i=Leeper_mode[24]/100
    σ_p=Leeper_mode[26]/100
    σ_w=Leeper_mode[25]/100
    σ_em=Leeper_mode[23]/100
    σ_eg=Leeper_mode[27]/100
    σ_ez=Leeper_mode[28]/100

    L_bar  = Leeper_mode[34]
    pi_bar = Leeper_mode[35]

    Mode_trans = [γ,ξ,θ,α_G,ψ,s,ω_p,ω_w,
        χ_p,χ_w,ϕ_πF,ϕ_y,ρ_r,
        γ_GF,γ_ZF,
        ρ_G,ρ_Z,ρ_a,ρ_b,ρ_i,ρ_p,ρ_w,ρ_em,ρ_eg,ρ_ez ,
        σ_a,σ_b,σ_i,σ_p,σ_w,σ_em,σ_eg,σ_ez, L_bar, pi_bar]

    return Mode_trans
end

function transform_M(Leeper_mode) # 35 elements
    γ=Leeper_mode[1]/100
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
    ρ_ez=1
    σ_a=Leeper_mode[20]/100
    σ_b=Leeper_mode[21]/100
    σ_i=Leeper_mode[23]/100
    σ_p=Leeper_mode[25]/100
    σ_w=Leeper_mode[24]/100
    σ_em=Leeper_mode[22]/100
    σ_eg=Leeper_mode[26]/100
    σ_ez=Leeper_mode[27]/100

    L_bar  = Leeper_mode[32]
    pi_bar = Leeper_mode[33]

    Mode_trans = [γ,ξ,θ,α_G,ψ,s,ω_p,ω_w,
        χ_p,χ_w,ϕ_πM,ϕ_y,ρ_r,
        γ_GM,γ_ZM,
        ρ_G,ρ_a,ρ_b,ρ_i,ρ_p,ρ_w,ρ_em,ρ_eg,
        σ_a,σ_b,σ_i,σ_p,σ_w,σ_em,σ_eg,σ_ez, L_bar, pi_bar]

    return Mode_trans

end


#Leeper_mode_2 = transform_M(Leeper_mode)

# Compare
#Mode_compare = [Leeper_mode_2, my_mode]
#println([Leeper_mode, my_mode])


## Function to Convert Var-Cov Matrix

function convertVarCovF(Leeper_CovF)
    # From Leeper's Order to Our Order
    vConvertF = [1,2,8,7,5,6,10,9,11,12,14,15,18,19,13,20,22,21,16,17,#20
                26,27,31,28,30,29,32,33,3,4,23,24,25,34,35]
    vDivide100F = [1,21,22,23,24,25,26,27,28]
    # Matrix to Store our Var-Cov Matrix
    VarCovF_converted = zeros(35,35)

    for ii = 1:length(vConvertF)
    for jj = 1:length(vConvertF)
        VarCovF_converted[vConvertF[ii],vConvertF[jj]] = Leeper_CovF[ii,jj]
        # Divide by 100 if necessary
        if jj in vDivide100F
            VarCovF_converted[vConvertF[ii],vConvertF[jj]] =
                VarCovF_converted[vConvertF[ii],vConvertF[jj]]/100
        end

        if ii in vDivide100F
            VarCovF_converted[vConvertF[ii],vConvertF[jj]] =
                VarCovF_converted[vConvertF[ii],vConvertF[jj]]/100
        end
    end
    end

    return VarCovF_converted
end

function convertVarCovM(Leeper_CovM)
    # From Leeper's Order to Our Order
    vConvertM = [1,2,8,7,5,6,10,9,11,12,14,15,17,18,13,19,21,20,16,24,#20
                25,29,26,28,27,30,31,3,4,22,23,32,33]
    vDivide100M = [1,20,21,22,23,24,25,26,27]

    # Matrix to Store our Var-Cov Matrix
    VarCovM_converted = zeros(33,33)

    for ii = 1:length(vConvertM)
    for jj = 1:length(vConvertM)
        VarCovM_converted[vConvertM[ii],vConvertM[jj]] = Leeper_CovM[ii,jj]
        # Divide by 100 if necessary
        if jj in vDivide100M
            VarCovM_converted[vConvertM[ii],vConvertM[jj]] =
                VarCovM_converted[vConvertM[ii],vConvertM[jj]]/100
        end

        if ii in vDivide100M
            VarCovM_converted[vConvertM[ii],vConvertM[jj]] =
                VarCovM_converted[vConvertM[ii],vConvertM[jj]]/100
        end
    end
    end

    return VarCovM_converted
end

## Implementation
# path="/Users/yoshiki/Dropbox/Morass/MyJuliaCode/0918/"
# using MAT, JLD
# cd(path)

# Leeper's Mode and Var-Cov
# fileF  = read(matopen("mode_regimeF_5507.mat")) # load data
# Leeper_modeF = fileF["mode"]
# Leeper_CovF  = fileF["inverseHessianmode"]

# fileM  = read(matopen("mode_regimeM_5507.mat")) # load data
# Leeper_modeM = fileM["mode"]
# Leeper_CovM  = fileM["inverseHessianmode"]

## Converting!
# OurVarCovM = convertVarCovM(Leeper_CovM)
# OurVarCovF = convertVarCovF(Leeper_CovF)




" Checking if this method works for mode too!
function convertModeF(Leeper_modeF)
    # From Leeper's Order to Our Order
    vConvertF = [1,2,9,8,6,7,11,10,13,14,20,23,28,29,15,30,32,31,24,27,#20
                36,37,41,38,40,39,42,43,3,5,33,34,35,44,45]
    vDivide100F = [1,21,22,23,24,25,26,27,28]
    # Matrix to Store our Var-Cov Matrix
    modeF_converted = ones(45)

    for ii = 1:length(vConvertF)
        modeF_converted[vConvertF[ii]] = Leeper_modeF[ii]
        # Divide by 100 if necessary
        if ii in vDivide100F
            modeF_converted[vConvertF[ii]] =
                modeF_converted[vConvertF[ii]]/100
        end
    end

    return modeF_converted
end

Fmode2 = convertModeF(Leeper_modeF)
Fmode1 = transform_F(Leeper_modeF)
Fmode1 == Fmode2
"
