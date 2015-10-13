#extension of lqr_simple_example.
#It is a linear system with a desire input and state

#ro is 1 in this case
using PyPlot

I = 1                        #inertial
l = 0.5                       #arm length
ro = 0.01
x_d = [0.4; 0]
u_d = 0

K = [-ro^(-0.5) -sqrt(2)*ro^(-1/4)]
A = [0 1;
     0 0]
B = [0; l/I]

N = 1000                                  #N*t seconds
x = Array(Float64, N, 2)
delta_t = 0.01
x[1,1] = 0.5
x[1,2] = 0.1
for i = 2:N
    x_p = vec(x[i-1,:])
    x_v = A*x_p+B*(K*(x_p-x_d)+u_d)[1,1]
    x[i,:] = vec(x[i-1,:]) + x_v*delta_t
end

figure()
subplot(211)
plot(1:N, vec(x[:,1]))

subplot(212)
plot(1:N, vec(x[:,2]))

