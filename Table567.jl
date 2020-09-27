## A fule to replicate the table 5-7
# September 27th
using JLD, Statistics

path1 = "/Users/yoshiki/Dropbox/RWMH_results/"
cd(path1)

# Load the simulation results
RWMHDataM  = load("MH100000_regimeM.jld")
RWMHDataF1 = load("Fiscal_model52/RWMH_Fver1_N3000.jld")
RWMHDataF2 = load("Fiscal_model52/RWMH_Fver2_N40000.jld")
RWMHDataF3 = load("Fiscal_model52/RWMH_Fver3_N40000.jld")
RWMHDataF4 = load("Fiscal_model52/RWMH_Fver4_N17000.jld")

## Monetary Regime
vParaM     = reduce(hcat,RWMHDataM["Para"])
vYmulM     = reduce(hcat,RWMHDataM["OutMul"])
vCmulM     = reduce(hcat,RWMHDataM["ConMul"])
vImulM     = reduce(hcat,RWMHDataM["InvMul"])

## Fiscal Regime
ParaDraw1  = RWMHDataF1["Para"];   YmulDraw1  = RWMHDataF1["Ymulti"];
CmulDraw1  = RWMHDataF1["Cmulti"]; ImulDraw1  = RWMHDataF1["Imulti"];

ParaDraw2  = RWMHDataF2["Para"];   YmulDraw2  = RWMHDataF2["Ymulti"];
CmulDraw2  = RWMHDataF2["Cmulti"]; ImulDraw2  = RWMHDataF2["Imulti"];

ParaDraw3  = RWMHDataF3["Para"];   YmulDraw3  = RWMHDataF3["Ymulti"];
CmulDraw3  = RWMHDataF3["Cmulti"]; ImulDraw3  = RWMHDataF3["Imulti"];

ParaDraw4  = RWMHDataF4["Para"];   YmulDraw4  = RWMHDataF4["Ymulti"];
CmulDraw4  = RWMHDataF4["Cmulti"]; ImulDraw4  = RWMHDataF4["Imulti"];

# Create a Matrix for each variable
vParaF     = [reduce(hcat, ParaDraw1) reduce(hcat,ParaDraw2) reduce(hcat,ParaDraw3) reduce(hcat,ParaDraw4)]
vYmulF     = [reduce(hcat, YmulDraw1) reduce(hcat,YmulDraw2) reduce(hcat,YmulDraw3) reduce(hcat,YmulDraw4)]
vCmulF     = [reduce(hcat, CmulDraw1) reduce(hcat,CmulDraw2) reduce(hcat,CmulDraw3) reduce(hcat,CmulDraw4)]
vImulF     = [reduce(hcat, ImulDraw1) reduce(hcat,ImulDraw2) reduce(hcat,ImulDraw3) reduce(hcat,ImulDraw4)]

## Discard First 5000 draws
Ndiscard = 5000
# Monetary Regime
vParaM2  = vParaM[:,Ndiscard+1:end]
vYmulM2  = vYmulM[:,Ndiscard+1:end]
vCmulM2  = vCmulM[:,Ndiscard+1:end]
vImulM2  = vImulM[:,Ndiscard+1:end]

# Fiscal Regime
vParaF2  = vParaF[:,Ndiscard+1:end]
vYmulF2  = vYmulF[:,Ndiscard+1:end]
vCmulF2  = vCmulF[:,Ndiscard+1:end]
vImulF2  = vImulF[:,Ndiscard+1:end]

## Function to compute Mean, 5th and 95th percentile of Entire Sample
function MeanIntervalPara(vPara)
    # Mean
    Mean     = mean(vPara; dims=2)

    # Percentile
    Percentile05 = zeros(size(vPara,1),1)
    Percentile95 = zeros(size(vPara,1),1)
    for ii = 1: size(vPara,1)
            Percentile05[ii,1] = quantile(vPara[ii,:], 0.05)
            Percentile95[ii,1] = quantile(vPara[ii,:], 0.95)
    end

    return Mean, Percentile05, Percentile95
end

## Take particular Five Time Horizons from Multipliers
# Function to take 5 elements from (Mean,5th,95th) Vector
function MultiFiveHorizon(vMul)
   # Compute Mean, 5th and 95th Percentile
   Multi_Mean, Multi_05, Multi_95  = MeanIntervalPara(vMul)

   # Mean of (Impact,4qtrs, 10qtrs, 25qtrs, 10yeas)
    vMean = [Multi_Mean[1], Multi_Mean[5], Multi_Mean[11], Multi_Mean[26],Multi_Mean[end] ]
   # 5th Percentile of (Impact,4qtrs, 10qtrs, 25qtrs, 10yeas)
    v05 = [Multi_05[1], Multi_05[5], Multi_05[11], Multi_05[26],Multi_05[end] ]
   # 95th Percentile of (Impact,4qtrs, 10qtrs, 25qtrs, 10yeas)
    v95 = [Multi_95[1], Multi_95[5], Multi_95[11], Multi_95[26],Multi_95[end] ]

    return vMean, v05, v95
end

## Parameter Mean, 5th and 95th Percentile
ParaM_Mean, ParaM_05, ParaM_95  = MeanIntervalPara(vParaM2)
ParaF_Mean, ParaF_05, ParaF_95  = MeanIntervalPara(vParaF2)

## Multipliers for Monetary Regime
Y_Mean_M, Y_05th_M, Y_95th_M = MultiFiveHorizon(vYmulM2)
C_Mean_M, C_05th_M, C_95th_M = MultiFiveHorizon(vCmulM2)
I_Mean_M, I_05th_M, I_95th_M = MultiFiveHorizon(vImulM2)

## Multipliers for Fiscal Regime
Y_Mean_F, Y_05th_F, Y_95th_F = MultiFiveHorizon(vYmulF2)
C_Mean_F, C_05th_F, C_95th_F = MultiFiveHorizon(vCmulF2)
I_Mean_F, I_05th_F, I_95th_F = MultiFiveHorizon(vImulF2)

println("computation finished")

function CreateVector(Y_Mean, Ndigit)
    a1 = round(Y_Mean[1], digits=Ndigit)
    a2 = round(Y_Mean[2], digits=Ndigit)
    a3 = round(Y_Mean[3], digits=Ndigit)
    a4 = round(Y_Mean[4], digits=Ndigit)
    a5 = round(Y_Mean[5], digits=Ndigit)

    StringTemp = "$a1 & $a2 & $a3 & $a4 & $a5"
end

function CreateInterval(Y_05th, Y_95th, Ndigit)

    a1 = round(Y_05th[1], digits=Ndigit)
    a2 = round(Y_05th[2], digits=Ndigit)
    a3 = round(Y_05th[3], digits=Ndigit)
    a4 = round(Y_05th[4], digits=Ndigit)
    a5 = round(Y_05th[5], digits=Ndigit)

    b1 = round(Y_95th[1], digits=Ndigit)
    b2 = round(Y_95th[2], digits=Ndigit)
    b3 = round(Y_95th[3], digits=Ndigit)
    b4 = round(Y_95th[4], digits=Ndigit)
    b5 = round(Y_95th[5], digits=Ndigit)

    StringTemp = "[$a1,$b1] & [$a2,$b2] & [$a3,$b3] & [$a4,$b4] & [$a5,$b5]"
end

# Implement
println(CreateVector(I_Mean_F, 2))
println(CreateInterval(I_05th_F,I_95th_F, 2))


## Extract Mean and 5th/95th Percentile for Parameters
# Monetary Regime
MparaName  = ["γ","ξ","θ","α_G","ψ","s","ω_p","ω_w",
        "χ_p","χ_w","ϕ_πM","ϕ_y","ρ_r",
        "γ_GM","γ_ZM",
        "ρ_G","ρ_a","ρ_b","ρ_i","ρ_p","ρ_w","ρ_em","ρ_eg",
        "σ_a","σ_b","σ_i","σ_p","σ_w","σ_em","σ_eg","σ_ez", "L_bar", "pi_bar"]
vMpara = [MparaName,ParaM_Mean, ParaM_05, ParaM_95]
vMpara = reduce(hcat, vMpara)

# Fiscal Regime
FparaName  = ["γ","ξ","θ","α_G","ψ","s","ω_p","ω_w",
        "χ_p","χ_w","ϕ_πF","ϕ_y","ρ_r",
        "γ_GF","γ_ZF",
        "ρ_G","ρ_Z","ρ_a","ρ_b","ρ_i","ρ_p","ρ_w","ρ_em","ρ_eg","ρ_ez" ,
        "σ_a","σ_b","σ_i","σ_p","σ_w","σ_em","σ_eg","σ_ez", "L_bar", "pi_bar"]
vFpara = [FparaName,ParaF_Mean, ParaF_05, ParaF_95]
vFpara = reduce(hcat, vFpara)

function FparaString(vFpara,Position, Ndigit)
     tempFpara = vFpara[Position,:]
     a1 = round(tempFpara[2], digits=Ndigit)
     a2 = round(tempFpara[3], digits=Ndigit)
     a3 = round(tempFpara[4], digits=Ndigit)
     println(tempFpara[1])
     StringTemp = "$a1 & [$a2,$a3]"
     println(StringTemp)
 end

# Implement
function Implement(vMpara,vFpara, Position, Ndigits)
    FparaString(vMpara,Position, Ndigits)
    FparaString(vFpara,Position, Ndigits)
end

Implement(vMpara,vFpara, 17, 2)

FparaString(vMpara,15, 2)
FparaString(vFpara,15, 4)
