# Computing the present value multiplier

function PVmultiplier(calibpara,estimpara,path,T,R,Q,Z,H,W)

    include(path*"variablesindices.jl")
    include(path*"model.jl")

    num_statevariables=49
    num_shocks=8
    num_periods=41 # 10 years (the one stands for 0 quarters, that is, impact multiplier)

    SS=steadystate(calibpara,estimpara)

    γ=estimpara[1]

    Rss=SS[2]
    yss=SS[21]
    iss=SS[22]
    css=SS[23]
    gss=SS[27]
    πss=1


    a_t=[zeros(num_statevariables)   for t=1:num_periods]
    logy_t=zeros(num_periods)
    logc_t=zeros(num_periods)
    logi_t=zeros(num_periods)
    logg_t=zeros(num_periods)
    logrr_t=zeros(num_periods)
    y_t=zeros(num_periods)
    c_t=zeros(num_periods)
    i_t=zeros(num_periods)
    g_t=zeros(num_periods)
    rr_t=zeros(num_periods)
    dy_t=zeros(num_periods)
    dc_t=zeros(num_periods)
    di_t=zeros(num_periods)
    dg_t=zeros(num_periods)
    discdy_t=zeros(num_periods)
    discdc_t=zeros(num_periods)
    discdi_t=zeros(num_periods)
    discdg_t=zeros(num_periods)
    outputmultiplier=zeros(num_periods)
    consumptionmultiplier=zeros(num_periods)
    investmentmultiplier=zeros(num_periods)


    govshock=zeros(num_shocks)
    govshock[epseg_innov]=1

    for t=1:num_periods
        if t==1
            a_t[t]=R*govshock
        else
            a_t[t]=T*a_t[t-1]
        end
        logy_t[t]=a_t[t][y_var]
        logc_t[t]=a_t[t][c_var]
        logi_t[t]=a_t[t][i_var]
        logg_t[t]=a_t[t][g_var]
        logrr_t[t]=a_t[t][rr_var]
        y_t[t]=yss*exp(logy_t[t])
        c_t[t]=css*exp(logc_t[t])
        i_t[t]=iss*exp(logi_t[t])
        g_t[t]=gss*exp(logg_t[t])
        rr_t[t]=(Rss/πss)*exp(logrr_t[t])
        dy_t[t]=y_t[t]-yss
        dc_t[t]=c_t[t]-css
        di_t[t]=i_t[t]-iss
        dg_t[t]=g_t[t]-gss
        discdy_t[t]=dy_t[t]/prod(rr_t[1:t])
        discdc_t[t]=dc_t[t]/prod(rr_t[1:t])
        discdi_t[t]=di_t[t]/prod(rr_t[1:t])
        discdg_t[t]=dg_t[t]/prod(rr_t[1:t])

        # Computing the multipliers
        outputmultiplier[t]=sum(discdy_t[1:t])/sum(discdg_t[1:t])
        consumptionmultiplier[t]=sum(discdc_t[1:t])/sum(discdg_t[1:t])
        investmentmultiplier[t]=sum(discdi_t[1:t])/sum(discdg_t[1:t])
    end

    return outputmultiplier, consumptionmultiplier, investmentmultiplier

end
