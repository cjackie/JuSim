#lqr with integral action. 

#ro is 1 in this case
using PyPlot

let
    I = 1                        #inertial
    l = 0.5                       #arm length
    ro = 0.01
    x_d = [0.4; 0]
    u_d = 0

    K_z = -5
    K = [-ro^(-0.5) -sqrt(2)*ro^(-1/4)]
    A = [0 1;
         0 0]
    B = [0; l/I]

    N = 5000                                  #N*t seconds
    x = Array(Float64, N, 2)
    z = Array(Float64, N)
    delta_t = 0.01
    x[1,1] = 0.5
    x[1,2] = 0.1
    z[1] = 0;
    for i = 2:N
        x_p = vec(x[i-1,:])
        x_v = A*x_p+B*((K*(x_p-x_d)+u_d)[1,1]+K_z*z[i-1])
        x[i,:] = vec(x[i-1,:]) + x_v*delta_t
        z[i] += (x_p[1]-x_d[1])*delta_t                        #integral term
    end

    close()
    figure()
    subplot(311)
    plot(1:N, vec(x[:,1]))

    subplot(312)
    plot(1:N, vec(x[:,2]))
    
    subplot(313)
    plot(1:N, z)
end
