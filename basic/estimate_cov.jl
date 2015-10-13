#estimate convariance of multivariate normal
#with inverse-wishart distribution as prior(conjugate prior)

using PyPlot
using Distributions
using PDMats

#generate artifition data
cov_n = [10.0  4.0  5.0;
         4.0  9.0  1.0;
         5.0  1.0  7.0]                #covariance
nu_n = [2.0; 2; 3]
N = 1000                               #number of data
multi_normal = MvNormal(nu_n, cov)
data = rand(multi_normal, 1000)'

#prior cojugate
k = 3
v = 4
S = [1.0 0 0;
     0 1 0;
     0 0 1 ]

u_e = Array(Float64, 3)
for i = 1:3
    u_e[i] = mean(data[:,i])
end

println(u_e)
#update the probability
for i = 1:size(data,1)
    v += 1
    x_i = vec(data[i,:])
    S = S+(x_i-u_e)*(x_i-u_e)'

    E_cov_n = 1/(v-k-1)*S
    clf()
    axis([0,10, 0, 15])
    scatter([1:length(cov_n)], reshape(cov_n, length(cov_n)), c="g")
    scatter([1:length(E_cov_n)], reshape(E_cov_n, length(E_cov_n)), c="r")
    sleep(0.01)
    println(i)
end







