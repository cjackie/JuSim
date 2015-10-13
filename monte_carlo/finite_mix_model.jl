#######################################################################
# finite mixture with 2 cluster. each cluster is mulitnomial normal.
####################################################################


using Distributions
using PDMats
using PyPlot

###### generate data ###########################
u1 = [2.5; 2.3]
u2 = [-4; 4.3]

sig_c = PDMat([2.0 0;
              3 2])

mv1 = MvNormal(u1, sig_c)
mv2 = MvNormal(u2, sig_c)

N = 100
samples = Array(Float64, N*2, 2)
for i = 1:N
    samples[i,:] = rand(mv1)
    samples[i+N,:] = rand(mv2)
end

clf()
subplot(121)
scatter(samples[:,1],samples[:,2])


##### run finite mixture model with known variance, and 2 cluster #######

M = zeros(Int, N*2, 2)
alpha = 1.0
K = 0.3
u_p = [0.0; 0]
sig_p =[2.0 0;
        0 2]
sig_known = [2.0 0;
             3 2]
         
#init class labels according to the prior, 0.2 and 0.8 in this case
z = Array(Int, N*2)
for i = 1:N*2
    z[i] = (rand() > 0.2) ? 1 : 2;
end

#run for 100 times
for i = 1:20
    for j = 1:N*2
        #probability of being z = 1 for samples[j] data
        x1 = filter((x) -> x[1] == 1, collect(zip(z,samples[:,1],samples[:,2])))
        len = length(x1)-1
        sig_n = (sig_p^-1 + len*sig_known^-1)^-1
        sum_x1 = foldr((x,r) -> (r[1]+x[2], r[2]+x[3]), (0.0, 0.0), x1)
        sum_x1 = (sum_x1[1] - samples[j,1], sum_x1[2] - samples[j,2])
        u_x1 = [sum_x1[1]/len; sum_x1[2]/len]
        u_n = sig_n*(len*sig_known^-1*u_x1+sig_p^-1*u_p)
        xj = vec(samples[j,:])
        f_xj = (2*π)^-1*det(sig_n+sig_known)^(-1/2)*e^((-1/2*(xj-u_n)'*(sig_n+sig_known)^-1*(xj-u_n))[1])
        p_k1 = (alpha/K+len-1)/(alpha+N*2-1)*f_xj

        #probability of being z = 2 for samples[j] data
        x2 = filter((x) -> x[1] == 2, collect(zip(z,samples[:,1],samples[:,2])))
        len = length(x2)-1
        sig_n = (sig_p^-1 + len*sig_known^-1)^-1
        sum_x2 = foldr((x,r) -> (r[1]+x[2], r[2]+x[3]), (0.0, 0.0), x2)
        sum_x2 = (sum_x2[1] - samples[j,1], sum_x2[2] - samples[j,2])
        u_x2 = [sum_x2[1]/len; sum_x2[2]/len]
        u_n = sig_n*(len*sig_known^-1*u_x2+sig_p^-1*u_p)
        xj = vec(samples[j,:])
        f_xj = (2*π)^-1*det(sig_n+sig_known)^(-1/2)*e^((-1/2*(xj-u_n)'*(sig_n+sig_known)^-1*(xj-u_n))[1])
        p_k2 = (alpha/K+len-1)/(alpha+N*2-1)*f_xj

        #normalization
        p2 = p_k2/(p_k1+p_k2)

        #sampling
        zj = rand(Bernoulli(p2))+1
        M[j,zj] += 1
        z[j] = zj
    end
    println(string(i, " out of ", "20"))
end

x1 = Array(Float64, 0, 2)
x2 = Array(Float64, 0, 2)
for i = 1:N*2
    if (M[i,1] > M[i,2]) 
        x1 = [x1; samples[i, :]]
    else
        x2 = [x2; samples[i, :]]
    end
end


subplot(122)
scatter(x1[:,1],x1[:,2], c="r")
scatter(x2[:,1],x2[:,2], c="g")


