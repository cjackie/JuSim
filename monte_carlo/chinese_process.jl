using Distributions
using PyPlot



alpha = 10             
N = 10000              #total customers

Ks = [1;]              #number of elems for each cluster
partitions = [(1,1);]
for i = 2:N
    #draw from the process
    n = foldr(+,Ks)
    prob = map((k_n) -> k_n/(n+alpha), Ks)
    prob = [prob; alpha/(n+alpha)]
    r = rand(Multinomial(1, prob))
    
    #figure out each table i belong
    k = nothing
    for j = 1:length(r)
        if (r[j] == 1)
            k = j
            break
        end
    end

    #update the cluster
    if (k > length(Ks))
        Ks = [Ks; 1]
    else
        Ks[k] += 1
    end
    partitions = [partitions; (i,k)]
end

x = map(x -> x[1], partitions)
y = map(x -> x[2], partitions)

clf()
scatter(x,y,s=1,c="blue")
