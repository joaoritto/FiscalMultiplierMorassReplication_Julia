## Kalman Filter and Smoother
# Yoshiki, August 21st

# State Space Representation
# α_t = α_{t-1} + R η_t
# y_t = Z α_t + ϵ_t + W
# η_t ∼ N(0,Q), ϵ_t ∼ N(o,H)

# Kalman Filter:
# Input : T,R,Q,Z,H,W,data
# Output: a0,P0,Pred_a,Pred_P,Upd_a,Upd_P,vt,Ft

# Kalman Smoother:
# Input: T,R,Q,Z,H,W,data
# Output: Smth_a, Smth_P

#current_repository = "/Users/yoshiki/Dropbox/Morass/MyJuliaCode"
# I will use the csv file from Homework 2 of 706 "gdpplus.csv"


## Define the Function to run Kalman Filter
function myKalmanFilter(T,R,Q,Z,H,W,data)


## Dimensions
y   = data
TT  = size(y,1)  # Number of Periods
NN  = size(y,2)  # Dimension of Observable Variables
mm  = size(T,1)  # Dimension of State

## Solution Matrix
Pred_a  = [zeros(mm,1)   for i=1:TT]
Pred_P  = [zeros(mm,mm)  for i=1:TT]
Upd_a   = [zeros(mm,1)   for i=1:TT]
Upd_P   = [zeros(mm,mm)  for i=1:TT]
vt      = [zeros(NN,1)   for i=1:TT]
Ft      = [zeros(NN,NN)  for i=1:TT]
invFt   = [zeros(NN,NN)  for i=1:TT]

## (i) Initialization
a0     = zeros(mm,1)
P0_v   = inv(diagm(ones(mm^2)) - kron(T,T) ) *  vec(R*Q* R')
P0_dim = Int(sqrt(size(P0_v ,1)))
P0     = reshape(P0_v,(P0_dim,P0_dim ) )

## (ii) Period 1
# Prediction
Pred_a[1] = T * a0
Pred_P[1] = T * P0 * T' + R * Q  * R'

vt[1]     = y[1,:] - Z * Pred_a[1] - W
Ft[1]     = Z * Pred_P[1] * Z' + H
if abs(det(Ft[1])) <= 0
    return "error (Ft is singular)"
end
# Update
invFt[1]  = inv(Ft[1])
Upd_a[1]  = Pred_a[1] + Pred_P[1] * Z' * invFt[1] * vt[1]
Upd_P[1]  = Pred_P[1] - Pred_P[1] * Z' * invFt[1] * Z * Pred_P[1]

## (ii) Period 2 onwards
for tt = 2:TT
    # Prediction
    Pred_a[tt] = T * Upd_a[tt-1]
    Pred_P[tt] = T * Upd_P[tt-1] * T' + R * Q  * R'

    vt[tt]     = y[tt,:] - Z * Pred_a[tt] - W
    Ft[tt]     = Z * Pred_P[tt] * Z' + H
    if abs(det(Ft[tt])) <= 0
        return "error (Ft is singular)"
    end

    # Update
    invFt[tt]  = inv(Ft[tt])
    Upd_a[tt]  = Pred_a[tt] + Pred_P[tt] * Z' * invFt[tt] * vt[tt]
    Upd_P[tt]  = Pred_P[tt] - Pred_P[tt] * Z' * invFt[tt] * Z * Pred_P[tt]
end

return a0,P0,Pred_a,Pred_P,Upd_a,Upd_P,vt,Ft, invFt
end


## ## Define the Function to run Kalman Smoother
function myKalmanSmoother(T,R,Q,Z,H,W,data)

# Run Kalman Filter First
a0,P0,Pred_a,Pred_P,Upd_a,Upd_P,vt,Ft, invFt =  myKalmanFilter(T,R,Q,Z,H,W,data)

## Dimensions
y   = data
TT  = size(y,1)  # Number of Periods
mm  = size(T,1)  # Dimension of State
NN  = size(y,2)  # Dimension of Observable Variables

## Solution Matrix

Smth_a  = [zeros(mm,1)   for i=1:TT]
Smth_P  = [zeros(mm,mm)  for i=1:TT]
Jt      = [zeros(NN,NN)  for i=1:TT]

## (i) Period TT
Smth_a[TT] = Upd_a[TT]
Smth_P[TT] = Upd_P[TT]


## (ii) Period from TT-1 to 1

for t1 = 1:TT-1
    tt = TT - t1 # range from TT-1 to 1

    Jt[tt]      = Upd_P[tt] * T' * inv(Pred_P[tt+1])
    Smth_a[tt]  = Upd_a[tt] + Jt[tt] * (Smth_a[tt+1] - Pred_a[tt+1])
    Smth_P[tt]  = Upd_P[tt] + Jt[tt] * (Smth_P[tt+1] - Pred_P[tt+1]) * (Jt[tt])'

end

return Smth_a, Smth_P
end

## Computing Log-Likelihood

function myKalmanLogLikelihood(T,R,Q,Z,H,W,data)
# Run Kalman Filter
a0,P0,Pred_a,Pred_P,Upd_a,Upd_P,vt,Ft,invFt =
              myKalmanFilter(T,R,Q,Z,H,W,data)
    # If Ft is singular, return LogLike = - e^10
             if myKalmanFilter(T,R,Q,Z,H,W,data) == "error (Ft is singular)"
                 Total_LogLike = -1e10
             else

## Setup
y   = data
TT  = size(y,1)  # Number of Periods
NN  = size(y,2)  # Dimension of Observable Variables
mm  = size(T,1)  # Dimension of State
Likelihood_t = zeros(TT) # Create a solution vector

for t = 1:TT
    Likelihood_t[t] = -0.5*log(abs(det(Ft[t]))) - (0.5* vt[t]' * (invFt[t])*vt[t])[1]
end

# ln(L) = -0.5 NN*TT*ln(2π) - 0.5*∑_{t=1:T} ln(|F_t|)
#                           - 0.5*∑_{t=1:T} v_t'inv(F_t)*v_t
Total_LogLike = -0.5*NN*TT*log(2*pi) + sum(Likelihood_t)

end

return Total_LogLike

end


## Check if it works properly
# Download the csv.data used in Homework 2 of 706
#cd(current_repository)
#println(pwd())
# using CSV
# rawData = CSV.read("gdpplus.csv")
# data_TS = rawData[41:236,[1,5,6]]

"
# Demean the data
GDE_mean    = mean(data_TS.GRGDP_DATA)
GDI_mean    = mean(data_TS.GRGDI_DATA)
data_demean = [data_TS.GRGDP_DATA.-GDE_mean,data_TS.GRGDI_DATA.-GDI_mean]

data = reduce(hcat, data_demean) # Matrix Form

# Use specific Parameters
init = [0.5,2,2,2]
T    = init[1] .* diagm(ones(2))
R    = init[2] .* diagm(ones(2))
H    = diagm([init[3],init[4]]);
Q    = [2 1; 1 2]
Z    = ones(2,2); W = zeros(2,1);

## Use the Function
# Kalman Filter
a0,P0,Pred_a,Pred_P,Upd_a,Upd_P,vt,Ft,invFt =  myKalmanFilter(T,R,Q,Z,H,W,data)
# Kalman Smoother
@time Smth_a, Smth_P =  myKalmanSmoother(T,R,Q,Z,H,W,data)

@time LogLike =  myKalmanLogLikelihood(T,R,Q,Z,H,W,data)

"
;
;
