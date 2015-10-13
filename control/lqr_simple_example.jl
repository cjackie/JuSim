#the example is from lecture note:
#http://www.egr.msu.edu/classes/me851/jchoi/lecture/Lect_14.pdf

#ro is 1 in this case
using PyPlot

N = 1000
x = Array(Float64, N, 2)
delta_t = 0.01
x[1,1] = 5
x[1,2] = 7
for i = 2:N
    x[i,1] = x[i-1,2]*delta_t + x[i-1,1]
    x[i,2] = (-x[i-1,1]-sqrt(2)*x[i-1,2])*delta_t + x[i-1,2]
end

figure()
subplot(211)
plot(1:N, vec(x[:,1]))

subplot(212)
plot(1:N, vec(x[:,2]))

