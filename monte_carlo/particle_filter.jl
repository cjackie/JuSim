#from paper On sequential monte carlo sampling methods for abysian filtering
#by arnaud doucet, simon godsill and christophe andrieu
#5. simulations. A.linear gaussian model 

using PyPlot
using Distributions

function normalize(weights)
    d = foldr(+, weights)
    for i in 1:size(weights,1)
        weights[i] /= d
    end
end

N = 100            #number of particles
n_p = 100          #time length of particles to keep track of
var_v = 1          #variance of v
var_w = 1          #variance of w
u_v = 0            #mean of v
u_w = 0            #mean of w

var_k = 1/2         #from the formula
getu_k(x, y) = var_k*(x/var_v+y/var_w) #mean of x_k

#time for the particle filtering
t_end = 1000                #terminat time
#true x in simulation, and corresponding y from the formula
x_true = Array(Float64, t_end)
x_true[1] = rand(Normal(0,1))
for i = 2:t_end
    let n = Normal(x_true[i-1]+u_v, var_v)
        x_true[i] = rand(n)
    end
end
#generate observations
y_ob = Array(Float64, t_end)
for i = 2:t_end
    let n = Normal(x_true[i]+u_w, var_w)
        y_ob[i] = rand(n)
    end
end

#init particles
particles = Array(Float64 , N, n_p)
weights = Array(Float64, N)

#draw form prior
prior = Normal(0,1)
for i = 1:N
    particles[i,1] = rand(prior)
    weights[i] = 1/N
end

#posterior
prob(y, x) = e^((-(y-x)^2)/(2*var_v+2*var_w))

#start the simulation
t_end_sim = t_end     #how long will the simulation run, less or equal to t_end
for i = 2:t_end
    y = y_ob[i]
    t = i%n_p+1                            #current time
    t_p = (t == 1) ? n_p : t-1             #previous time
    #draw from importance functions, update particles
    for j = 1:N
        let n = Normal(getu_k(particles[j, t_p], y), var_k)
            particles[j,t] = rand(n)
        end
        weights[j] =  weights[j]*prob(y, particles[j, t_p])
    end
    normalize(weights)
    #visualize the weights of particles
    PyPlot.clf()
    PyPlot.axis([-50,50,0,0.3])
    sorted_data = sortrows([particles[:,t] weights])
    PyPlot.plot(sorted_data[:,1], sorted_data[:,2])
    PyPlot.scatter(x_true[i], 0, s=200, c="red")
    sleep(0.1)
end
