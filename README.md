Term Paper for ECON 722 course in UPenn: 
Replication of "Clearing up the Fiscal Multiplier Morass" (2017), by Leeper, Traum and Walker.

Replication made in Julia language.

The files mainPPA.jl and mainEstimation.jl should be run to reproduce the prior predictive analysis and the bayesian estimation, respectively. Other files contain functions that are called by these scripts: model.jl has the functions necessary to solve the model given a parameter vector, including a version of Sims' gensys; priorpredictiveanalysis.jl call several function for constructing the prior predictive analysis tables and figures; prior.jl contains functions to draw from the prior but also to evaluate the prior density of a given parameter vector; modelrestrictions.jl imposes the necessary restrictions of the submodel that one wants to use; PVmultiplier.jl computes the multipliers; RWMH.jl implements the random walk metropolis hastings algorithm; variablesindices.jl is an auxiliary function to model.jl; Kalman.jl implements the Kalman Filter given certain state space matrices.

by Yoshiki Ando and Joao Ritto
