#see how state estimation evolves with time with noise
#without any filter.
using Distributions
using PyPlot

num_n = 10000
delta_t = 0.005
#generate acceleration data
x_a = Array(Float64, num_n-1, 3)
let g = Normal(0, 20)
    for i = 1:num_n-1
        x_a[i,:] = [rand(g); rand(g); rand(g)]
    end
end

#generate velocity data
x_v = Array(Float64, num_n-1, 3)
x_v[1,:] = [0.0; 0; 0]
for i = 2:num_n-1
    x_v[i,:] = vec(x_v[i-1,:]) + delta_t*vec(x_a[i-1,:]) 
end


#generate data
x = Array(Float64, num_n, 3)
x[1,:] = [0.0;0;0]             #init state
for i = 2:num_n
    x[i,:] = vec(x[i-1,:]) + delta_t*vec(x_v[i-1,:])
end

#generate velocity measurements
x_v_m = Array(Float64, num_n-1, 3)
let g = Normal(0,20)
    for i = 1:num_n-1
        x_v_m[i,:] = vec(x_v[i,:]) + [rand(g); rand(g); rand(g)]
    end
end

#data through the measurements directly
x_e = Array(Float64, num_n, 3)
x_e[1,:] = [0.0;0;0]             #assume the init state is perfect
for i = 2:num_n
    x_e[i,:] = vec(x_e[i-1,:]) + delta_t*vec(x_v_m[i-1,:])
end

close("all")

subplot(311)
plot(x[:,1],c="g")
plot(x_e[:,1],c="r")

subplot(312)
plot(x[:,2],c="g")
plot(x_e[:,2],c="r")

subplot(313)
plot(x[:,3],c="g")
plot(x_e[:,3],c="r")


figure()
diff = abs(x_e - x)
subplot(311)
plot(diff[:,1],c="r")

subplot(312)
plot(diff[:,2],c="r")

subplot(313)
plot(diff[:,3],c="r")


                   
