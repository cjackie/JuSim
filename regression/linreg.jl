using Regression
using Distributions
using PyPlot

function tranform(x::Array{Float64}, dim::Int64=10)
    len = length(x)
    d = Array(Float64, len, dim)
    for i = 1:len
        for j = 1:dim
            d[i,j] = (x[i])^(j-1)
        end
    end
    d
end

function f_e(x,thetas)
    r = 0
    for i = 1:length(thetas)
        r += thetas[i]*x^(i-1)
    end
    r
end


f(x) = 3+0.22*x^2-1.3*x^3+0.1*x^5
noise = Normal(0,0.9)
xs = rand(100)*4
ys = map(f, xs) + rand(noise, 100)

clf()
scatter(xs,ys,c="g")

dim = 10
t_xs = tranform(xs,dim)
delta = 0.1
threshold = 0.001
min_x = foldr(min, Inf, xs)
max_x = foldr(max, -Inf, xs)
for i = 1:10
    r = 1.1*i
    sols = ridgereg(t_xs,ys,r)
    sols = map(x-> abs(x) < threshold? 0 : x, sols) #check against threshhold
    clf()
    scatter(xs,ys,c="g")
    plot_x = [min_x:delta:max_x]
    plot_y = Array(Float64, length(plot_x))
    for i = 1:length(plot_x)
        plot_y[i] = f_e(plot_x[i], sols)
    end
    plot(plot_x, plot_y, c="b")
    println(sols)
    sleep(2)
end

     






  
