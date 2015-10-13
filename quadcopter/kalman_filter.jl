#kalman filter simulation
using Distributions
using PDMats
using PyPlot

#kalman filter requirements
function state_trans_eq(prev_state::Array{Float64,1}, input_v::Array{Float64,1}, delta_t::Float64)
    F = [1 0 0 delta_t 0 0;
         0 1 0 0 delta_t 0;
         0 0 1 0 0 delta_t;
         0 0 0 1 0 0;
         0 0 0 0 1 0;
         0 0 0 0 0 1 ]
    
    G = [1/2*delta_t^2 0 0;
         0 1/2*delta_t^2 0;
         0 0 1/2*delta_t^2;
         delta_t 0 0;
         0 delta_t 0;
         0 0 delta_t ]

    F*prev_state + G*input_v
end

function meas_eq(state::Array{Float64,1}, delta_t::Float64)
    H = [0 0 0 1 0 0;
         0 0 0 0 1 0;
         0 0 0 0 0 1 ]

    H*state
end

#noise of the state transition equation
v_mu = [0.;0;0;0;0;0]
sig = PDMat([5. 0 0 0 0 0;
             0 2 0 0 0 0;
             0 0 4 0 0 0;
             0 0 0 1 0 0;
             0 0 0 0 6 0;
             0 0 0 0 0 3])
v = MvNormal(v_mu, sig)

#noise of the measurement equation
v_mu = [.0;0;0]
sig = PDMat([20.0 0 0; 
             0 20 0;
             0 0 20 ])
w = MvNormal(v_mu, sig)

#generate simulation data
data_num = 10000                           #number of data
u_r = Array(Float64, data_num, 3)          #input to the system
let u = Normal(0, 20)
    for i = 1:data_num
        #generate random input to the system
        for j = 1:3
            u_r[i,j] = rand(u)
        end
    end
end

delta_ts = Array(Float64, data_num)        #time duration of each inputs
let u = Uniform(0.001, 0.01)
    for i = 1:data_num
        delta_ts[i] = rand(u)
    end
end

x_r = Array(Float64, data_num, 6)          #true state
x_r[1,:] = [0.0 0 0 0 0 0]                 #initial value
for i = 2:data_num
    #get the next state
    x_r[i,:] = state_trans_eq(vec(x_r[i-1,:]), vec(u_r[i-1,:]), delta_ts[i-1])
end

meas_r = Array(Float64, data_num-1, 3)       #measurement
for i = 1:data_num-1
    meas_r[i,:] = meas_eq(vec(x_r[i+1,:]), delta_ts[i])
    println(meas_r[i,:])
    meas_r[i,:] = vec(meas_r[i,:]) + rand(w)
end

x_state = vec(x_r[1,:])
meas = meas_r[1,:]
state_cov = [5. 0 0 0 0 0;
             0 2 0 0 0 0;
             0 0 4 0 0 0;
             0 0 0 1 0 0;
             0 0 0 0 6 0;
             0 0 0 0 0 3]

x_states = Array(Float64, data_num-1, 6)
for i = 1:data_num-1
    #prediction
    delta_t = delta_ts[i]
    x_pred = state_trans_eq(x_state, vec(u_r[i,:]), delta_t)
    meas_pred = meas_eq(x_pred, delta_t)

    #cov estimation
    F = [1 0 0 delta_t 0 0;
         0 1 0 0 delta_t 0;
         0 0 1 0 0 delta_t;
         0 0 0 1 0 0;
         0 0 0 0 1 0;
         0 0 0 0 0 1 ]
    #estimated noise cov for state transition matrix
    v = [1 0 0 0 0 0;
         0 1 0 0 0 0;
         0 0 1 0 0 0;
         0 0 0 1 0 0;
         0 0 0 0 1 0;
         0 0 0 0 0 1]
    state_cov_pred = F*state_cov*F' + v

    H = [0 0 0 1 0 0;
         0 0 0 0 1 0;
         0 0 0 0 0 1 ]
    #estimate
    w = [1. 0 0;
         0 1 0;
         0 0 1 ]
    S = H*state_cov_pred*H' + w
    w = state_cov_pred*H'*S^-1
    state_cov = state_cov_pred - w*S*w'

    #residual
    r = vec(meas_r[i,:]) - meas_pred
    #update state
    x_state = x_pred + w*r

    x_states[i,:] = x_state
end

close("all")

subplot(311)
plot(x_states[:,1],c="r")
plot(x_r[:,1],c="g")

subplot(312)
plot(x_states[:,2],c="r")
plot(x_r[:,2],c="g")

subplot(313)
plot(x_states[:,3],c="r")
plot(x_r[:,3],c="g")

figure()
subplot(311)
plot(abs(x_r[2:end,1]-x_states[:,1]),c="r")

subplot(312)
plot(abs(x_r[2:end,2]-x_states[:,2]),c="r")

subplot(313)
plot(abs(x_r[2:end,3]-x_states[:,3]),c="r")
