#numerical solution to differential equation dx/dt + x + 2 = 0
#the analytical solution can be obtained and it is c*e^(-t)-2
#where c is a constant that can determined by initial condition

using PyPlot

#analytic solution
x_0 = 0
x(t) = 2*e^(-t)-2

figure()

#plot the analytic solution
subplot(311)
t = [0:0.01:5]
x_o1 = map(x, t)
plot(t, x_o1)

#numerical solution
t_len = length(t)
delta_t = 0.01
x_o2 = Array(Float64, t_len)
x_o2[1] = 0                      
for i = 2:t_len
    x_o2[i] = (-x_o2[i-1]-2)*delta_t+x_o2[i-1]
end

subplot(312)
plot(t, x_o2)

#plot difference
subplot(313)
plot(t, x_o1-x_o2)


