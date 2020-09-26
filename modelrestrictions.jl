# Model restrictions

# List of Models

# 1.1 RBC real friction

# 2 New Keynesian sticky prices and wages
# 2.1 Regime M
# 2.2 Regime F, short debt
# 2.3 Regime F, long debt

# 3 New Keynesian non-savers
# 3.1 Regime M
# 3.2 Regime F, short debt
# 3.3 Regime F, long debt

# 3.4 Regime M, ss tax only (figure 1) 

# 4 New Keynesian G in utility
# 4.1 Regime M, substitutes
# 4.2 Regime M, complements
# 4.3 Regime M, complements, ss tax only
# 4.4 Regime M, complements, no tax
# 4.5 Regime F, substitutes, short debt
# 4.6 Regime F, substitutes, long debt
# 4.7 Regime F, complements, short debt
# 4.8 Regime F, complements, long debt
# 4.9 Regime F, complements, short debt, ss tax only
# 4.10 Regime F, complements, long debt, ss tax only
# 4.11 Regime F, complements, short debt, no tax
# 4.12 Regime F, complements, long debt, no tax


# 5 New Keynesian G in utility (For the estimation)
# 5.1 Regime M, unrestricted, ss tax only
# 5.2 Regime F, unrestricted, ss tax only

function modelrestrictions(model,calibpara0,estimpara0)

    lcalibpara=length(calibpara0)
    lestimpara=length(estimpara0)

    calibpararestric=ones(Int64,lcalibpara)
    estimpararestric=ones(Int64,lestimpara)
    changecalibpara=zeros(lcalibpara)
    changeestimpara=zeros(lestimpara)
    subsorcompl=0

    if model=="1.1"

        regime="M"

        # ω_w=ω_p=η_w=η_p=χ_w=χ_p=ϕ_π=ϕ_y=ρ_r=μ=α_G=0

        estimpararestric[9]=0 # ω_w
        estimpararestric[8]=0 # ω_p
        calibpararestric[6]=0 # η_w
        calibpararestric[5]=0 # η_p
        estimpararestric[11]=0 # χ_w
        estimpararestric[10]=0 # χ_p
        estimpararestric[12]=0 # ϕ_πM
        estimpararestric[14]=0 # ϕ_y
        estimpararestric[15]=0 # ρ_r
        estimpararestric[4]=0 # μ
        estimpararestric[5]=0 # α_G

        changeestimpara[9]=0.0 # ω_w
        changeestimpara[8]=0.0 # ω_p
        changecalibpara[6]=0.0 # η_w
        changecalibpara[5]=0.0 # η_p
        changeestimpara[11]=0.0 # χ_w
        changeestimpara[10]=0.0 # χ_p
        changeestimpara[12]=0.0 # ϕ_πM
        changeestimpara[14]=0.0 # ϕ_y
        changeestimpara[15]=0.0 # ρ_r
        changeestimpara[4]=0.0 # μ
        changeestimpara[5]=0.0 # α_G

    elseif model=="2.1"

        regime="M"

        # μ=α_G=0

        estimpararestric[4]=0 # μ
        estimpararestric[5]=0 # α_G

        changeestimpara[4]=0.0 # μ
        changeestimpara[5]=0.0 # α_G

    elseif model=="2.2"

        regime="F"

        # μ=α_G=0; AD=1

        estimpararestric[4]=0 # μ
        estimpararestric[5]=0 # α_G
        calibpararestric[1]=0 # AD

        changeestimpara[4]=0.0 # μ
        changeestimpara[5]=0.0 # α_G
        changecalibpara[1]=1.0 # AD

    elseif model=="2.3"

        regime="F"

        # μ=α_G=0

        estimpararestric[4]=0 # μ
        estimpararestric[5]=0 # α_G

        changeestimpara[4]=0.0 # μ
        changeestimpara[5]=0.0 # α_G

    elseif model=="3.1"

        regime="M"

        # α_G=0

        estimpararestric[5]=0 # α_G

        changeestimpara[5]=0.0 # α_G

    elseif model=="3.2"

        regime="F"

        # α_G=0; AD=1

        estimpararestric[5]=0 # α_G
        calibpararestric[1]=0 # AD

        changeestimpara[5]=0.0 # α_G
        changecalibpara[1]=1.0 # AD

    elseif model=="3.3"

        regime="F"

        # α_G=0

        estimpararestric[5]=0 # α_G

        changeestimpara[5]=0.0 # α_G
        
    elseif model=="3.4"

        regime="M"

        # α_G=0

        estimpararestric[5]=0 # α_G
        estimpararestric[17]=0 # γ_KM
        estimpararestric[18]=0 # γ_LM
        estimpararestric[25]=0 # ρ_K
        estimpararestric[26]=0 # ρ_L

        changeestimpara[5]=0.0 # α_G
        changeestimpara[17]=0.0 # γ_KM
        changeestimpara[18]=0.0 # γ_LM
        changeestimpara[25]=0.0 # ρ_K
        changeestimpara[26]=0.0 # ρ_L

    elseif model=="4.1"

        regime="M"
        subsorcompl=1

        # μ=0, α_G>0

        estimpararestric[4]=0 # μ

        changeestimpara[4]=0.0 # μ

        if estimpara0[5]<0
            estimpararestric[5]=0 # α_G

            changeestimpara[5]=abs(estimpara0[5]) # α_G
        end

    elseif model=="4.2"

        regime="M"
        subsorcompl=1

        # μ=0, α_G<0

        estimpararestric[4]=0 # μ

        changeestimpara[4]=0.0 # μ

        if estimpara0[5]>0
            estimpararestric[5]=0 # α_G

            changeestimpara[5]=-(estimpara0[5]) # α_G
        end

    elseif model=="4.3"

        regime="M"
        subsorcompl=1

        # μ=0, α_G<0, γ_KM=γ_LM=ρ_K=ρ_L=0

        estimpararestric[4]=0 # μ
        estimpararestric[17]=0 # γ_KM
        estimpararestric[18]=0 # γ_LM
        estimpararestric[25]=0 # ρ_K
        estimpararestric[26]=0 # ρ_L

        changeestimpara[4]=0.0 # μ
        changeestimpara[17]=0.0 # γ_KM
        changeestimpara[18]=0.0 # γ_LM
        changeestimpara[25]=0.0 # ρ_K
        changeestimpara[26]=0.0 # ρ_L


        if estimpara0[5]>0
            estimpararestric[5]=0 # α_G

            changeestimpara[5]=-(estimpara0[5]) # α_G
        end

    elseif model=="4.4"

        regime="M"
        subsorcompl=1

        # μ=0, α_G<0, γ_KM=γ_LM=ρ_K=ρ_L=0, τK=τL=τC=0 (steady state values)

        estimpararestric[4]=0 # μ
        estimpararestric[17]=0 # γ_KM
        estimpararestric[18]=0 # γ_LM
        estimpararestric[25]=0 # ρ_K
        estimpararestric[26]=0 # ρ_L
        calibpararestric[10]=0 # τK
        calibpararestric[11]=0 # τL
        calibpararestric[12]=0 # τC

        changeestimpara[4]=0.0 # μ
        changeestimpara[17]=0.0 # γ_KM
        changeestimpara[18]=0.0 # γ_LM
        changeestimpara[25]=0.0 # ρ_K
        changeestimpara[26]=0.0 # ρ_L
        changecalibpara[10]=0.0 # τK
        changecalibpara[11]=0.0 # τL
        changecalibpara[12]=0.0 # τC

        if estimpara0[5]>0
            estimpararestric[5]=0 # α_G

            changeestimpara[5]=-(estimpara0[5]) # α_G
        end

    elseif model=="4.5"

        regime="F"
        subsorcompl=1

        # μ=0, α_G>0, AD=1

        estimpararestric[4]=0 # μ
        calibpararestric[1]=0 # AD

        changeestimpara[4]=0.0 # μ
        changecalibpara[1]=1.0 # AD

        if estimpara0[5]<0
            estimpararestric[5]=0 # α_G

            changeestimpara[5]=abs(estimpara0[5]) # α_G
        end

    elseif model=="4.6"

        regime="F"
        subsorcompl=1

        # μ=0, α_G>0

        estimpararestric[4]=0 # μ

        changeestimpara[4]=0.0 # μ

        if estimpara0[5]<0
            estimpararestric[5]=0 # α_G

            changeestimpara[5]=abs(estimpara0[5]) # α_G
        end

    elseif model=="4.7"

        regime="F"
        subsorcompl=1

        # μ=0, α_G<0, AD=1

        estimpararestric[4]=0 # μ
        calibpararestric[1]=0 # AD

        changeestimpara[4]=0.0 # μ
        changecalibpara[1]=1.0 # AD

        if estimpara0[5]>0
            estimpararestric[5]=0 # α_G

            changeestimpara[5]=-(estimpara0[5]) # α_G
        end

    elseif model=="4.8"

        regime="F"
        subsorcompl=1

        # μ=0, α_G<0

        estimpararestric[4]=0 # μ

        changeestimpara[4]=0.0 # μ

        if estimpara0[5]>0
            estimpararestric[5]=0 # α_G

            changeestimpara[5]=-(estimpara0[5]) # α_G
        end

    elseif model=="4.9"

        regime="F"
        subsorcompl=1

        # μ=0, α_G<0, AD=1, γ_KF=γ_LF=ρ_K=ρ_L=0

        estimpararestric[4]=0 # μ
        calibpararestric[1]=0 # AD
        estimpararestric[21]=0 # γ_KF
        estimpararestric[22]=0 # γ_LF
        estimpararestric[25]=0 # ρ_K
        estimpararestric[26]=0 # ρ_L

        changeestimpara[4]=0.0 # μ
        changecalibpara[1]=1.0 # AD
        changeestimpara[21]=0.0 # γ_KF
        changeestimpara[22]=0.0 # γ_LF
        changeestimpara[25]=0.0 # ρ_K
        changeestimpara[26]=0.0 # ρ_L


        if estimpara0[5]>0
            estimpararestric[5]=0 # α_G

            changeestimpara[5]=-(estimpara0[5]) # α_G
        end

    elseif model=="4.10"

        regime="F"
        subsorcompl=1

        # μ=0, α_G<0, γ_KF=γ_LF=ρ_K=ρ_L=0

        estimpararestric[4]=0 # μ
        estimpararestric[21]=0 # γ_KF
        estimpararestric[22]=0 # γ_LF
        estimpararestric[25]=0 # ρ_K
        estimpararestric[26]=0 # ρ_L

        changeestimpara[4]=0.0 # μ
        changeestimpara[21]=0.0 # γ_KF
        changeestimpara[22]=0.0 # γ_LF
        changeestimpara[25]=0.0 # ρ_K
        changeestimpara[26]=0.0 # ρ_L


        if estimpara0[5]>0
            estimpararestric[5]=0 # α_G

            changeestimpara[5]=-(estimpara0[5]) # α_G
        end

    elseif model=="4.11"

        regime="F"
        subsorcompl=1

        # μ=0, α_G<0, AD=1, γ_KF=γ_LF=ρ_K=ρ_L=0, τK=τL=τC=0 (steady state values)

        estimpararestric[4]=0 # μ
        calibpararestric[1]=0 # AD
        estimpararestric[21]=0 # γ_KF
        estimpararestric[22]=0 # γ_LF
        estimpararestric[25]=0 # ρ_K
        estimpararestric[26]=0 # ρ_L
        calibpararestric[10]=0 # τK
        calibpararestric[11]=0 # τL
        calibpararestric[12]=0 # τC

        changeestimpara[4]=0.0 # μ
        changecalibpara[1]=1.0 # AD
        changeestimpara[21]=0.0 # γ_KF
        changeestimpara[22]=0.0 # γ_LF
        changeestimpara[25]=0.0 # ρ_K
        changeestimpara[26]=0.0 # ρ_L
        changecalibpara[10]=0.0 # τK
        changecalibpara[11]=0.0 # τL
        changecalibpara[12]=0.0 # τC

        if estimpara0[5]>0
            estimpararestric[5]=0 # α_G

            changeestimpara[5]=-(estimpara0[5]) # α_G
        end

    elseif model=="4.12"

        regime="F"
        subsorcompl=1

        # μ=0, α_G<0, γ_KF=γ_LF=ρ_K=ρ_L=0, τK=τL=τC=0 (steady state values)

        estimpararestric[4]=0 # μ
        estimpararestric[21]=0 # γ_KF
        estimpararestric[22]=0 # γ_LF
        estimpararestric[25]=0 # ρ_K
        estimpararestric[26]=0 # ρ_L
        calibpararestric[10]=0 # τK
        calibpararestric[11]=0 # τL
        calibpararestric[12]=0 # τC

        changeestimpara[4]=0.0 # μ
        changeestimpara[21]=0.0 # γ_KF
        changeestimpara[22]=0.0 # γ_LF
        changeestimpara[25]=0.0 # ρ_K
        changeestimpara[26]=0.0 # ρ_L
        changecalibpara[10]=0.0 # τK
        changecalibpara[11]=0.0 # τL
        changecalibpara[12]=0.0 # τC


        if estimpara0[5]>0
            estimpararestric[5]=0 # α_G

            changeestimpara[5]=-(estimpara0[5]) # α_G
        end

    elseif model=="5.1"

        regime="M"

        # μ=0, γ_KM=γ_LM=ρ_K=ρ_L=0, ρ_Z=0.98, ρ_ez=0.8

        estimpararestric[4]=0 # μ
        estimpararestric[17]=0 # γ_KM
        estimpararestric[18]=0 # γ_LM
        estimpararestric[25]=0 # ρ_K
        estimpararestric[26]=0 # ρ_L
        estimpararestric[27]=0 # ρ_Z
        estimpararestric[35]=0 # ρ_ez


        changeestimpara[4]=0.0 # μ
        changeestimpara[17]=0.0 # γ_KM
        changeestimpara[18]=0.0 # γ_LM
        changeestimpara[25]=0.0 # ρ_K
        changeestimpara[26]=0.0 # ρ_L
        changeestimpara[27]=0.98 # ρ_Z
        changeestimpara[35]=0.8 # ρ_ez

    elseif model=="5.2"

        regime="F"

        # μ=0, γ_KF=γ_LF=ρ_K=ρ_L=0

        estimpararestric[4]=0 # μ
        estimpararestric[21]=0 # γ_KF
        estimpararestric[22]=0 # γ_LF
        estimpararestric[25]=0 # ρ_K
        estimpararestric[26]=0 # ρ_L

        changeestimpara[4]=0.0 # μ
        changeestimpara[21]=0.0 # γ_KF
        changeestimpara[22]=0.0 # γ_LF
        changeestimpara[25]=0.0 # ρ_K
        changeestimpara[26]=0.0 # ρ_L

    end


    calibpara=calibpara0.*calibpararestric+changecalibpara
    estimpara=estimpara0.*estimpararestric+changeestimpara

    if subsorcompl==1
        estimpararestric[5]=1
    end

    return calibpara,estimpara,calibpararestric,estimpararestric,regime,subsorcompl
end
