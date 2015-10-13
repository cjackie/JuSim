#Gibbs sampling for a DAG consists of Dirichlet and Multinomial

using Distributions
using PyPlot


H = Normal(0, 40)
alpha = 2
delta = 1
lower_bound = -100
upper_bound = 100
N = 2000

#total of (upper_bound-lower_bound)/delta+2 partitions
dir_v = Array(Float64, int((upper_bound-lower_bound)/delta)+2)
#assign prior partition probabilities
for i = 1:(int((upper_bound-lower_bound)/delta)+2)
    if (i == 1)
        dir_v[i] = cdf(H,lower_bound)
    elseif (i == (int((upper_bound-lower_bound)/delta)+2))
        dir_v[i] = 1-cdf(H,lower_bound+delta*(i-1))
    else
        dir_v[i] = cdf(H,lower_bound+delta*(i-1))-cdf(H,lower_bound+delta*(i-2))
    end
end
println(dir_v)
PyPlot.clf()
PyPlot.scatter(1:(int((upper_bound-lower_bound)/delta)+2),dir_v)
sleep(2)

dir = Dirichlet(dir_v)


x = Array(Int, N)
for i = 1:N
    v = rand(dir)
    multin = Multinomial(1, v)
    x_v = rand(multin)
    for j = 1:size(x_v,1)
        if (x_v[j] == 1)
            x[i] = j
            break
        end
    end
end
PyPlot.figure()
PyPlot.clf()
PyPlot.hist(x,200)




