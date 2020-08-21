## Kalman Filter
# Yoshiki, August 21st

# Input : T,R,Q,Z,H,W,data
# Output: a0,P0,Pred_a,Pred_P,Upd_a,Upd_P,vt,Ft


## Define the Function to run Kalman Filter
function myKalman(T,R,Q,Z,H,W,data)

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

## (i) Initialization
a0     = zeros(mm,1)
P0_v   = inv(diagm(ones(mm^2)) - kron(T,T) ) *  vec(R*Q* R')
P0_dim = Int(sqrt(size(P0_v ,1)))
P0     = reshape(P0_v,(P0_dim,P0_dim ) )

## (ii) Period 1
Pred_a[1] = T * a0
Pred_P[1] = T * P0 * T' + R * Q  * R'
vt[1]     = y[1,:] - Z * Pred_a[1] - W
Ft[1]     = Z * Pred_P[1] * Z' + H
if abs(det(Ft[1])) < 1.e-14
    println("error (Ft is singular)")
end
Upd_a[1]  = Pred_a[1] + Pred_P[1] * Z' * inv(Ft[1]) * vt[1]
Upd_P[1]  = Pred_P[1] - Pred_P[1] * Z' * inv(Ft[1]) * Z * Pred_P[1]

## (ii) Period 2 onwards
for tt = 2:TT
    # Prediction
    Pred_a[tt] = T * Upd_a[tt-1]
    Pred_P[tt] = T * Upd_P[tt-1] * T' + R * Q  * R'

    vt[tt]     = y[tt,:] - Z * Pred_a[tt] - W
    Ft[tt]     = Z * Pred_P[tt] * Z' + H
    if abs(det(Ft[tt])) < 1.e-14
        println("error (Ft is singular)")
    end

    # Update
    Upd_a[tt]  = Pred_a[tt] + Pred_P[tt] * Z' * inv(Ft[tt]) * vt[tt]
    Upd_P[tt]  = Pred_P[tt] - Pred_P[tt] * Z' * inv(Ft[tt]) * Z * Pred_P[tt]
end

return a0,P0,Pred_a,Pred_P,Upd_a,Upd_P,vt,Ft
end






## Check if it works properly
# Download the csv.data used in Homework 2 of 706
cd("/Users/yoshiki/Dropbox/Morass/MyJuliaCode")
println(pwd())
using CSV
rawData = CSV.read("gdpplus.csv")
data_TS = rawData[41:236,[1,5,6]]

# Demean the data
GDE_mean    = mean(data_TS.GRGDP_DATA)
GDI_mean    = mean(data_TS.GRGDI_DATA)
data_demean = [data_TS.GRGDP_DATA.-GDE_mean,data_TS.GRGDI_DATA.-GDI_mean]

data = reduce(hcat, data_demean) # Matrix Form

# Use specific Parameters
init = [0.5,2,2,2]
T    = init[1] .*ones(1,1)
R    = init[2]
H    = diagm([init[3],init[4]]);
Q    = ones(1,1);
Z    = ones(2,1); W = zeros(2,1);

## Use the Function
a0,P0,Pred_a,Pred_P,Upd_a,Upd_P,vt,Ft =  myKalman(T,R,Q,Z,H,W,data)
