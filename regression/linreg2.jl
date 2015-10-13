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

# prepare simulation data
f(x) = 0.22*x^2-1.3*x^3+0.1*x^5
noise = Normal(0,0.9)
xs_o = rand(100)*4
ys = map(f, xs_o) + rand(noise, 100)

dim = 6                      # feature vector with n dimension
model = LinearPred(dim)      # the equatin (2)
sqrloss = SqrLoss()          # the loss function (3)
reg = SqrL2Reg(2.0)          # squared L2 regularizer with coefficient 1
xs = tranform(xs_o,dim)

# this is (4)
rmodel = riskmodel(model,sqrloss)
# assume xs is the 10 by m matrix(list of feature vectors)
# and the ys is a vector of labels either -1 or 1
objective_function = Regression.RegRiskFun(rmodel, reg, xs', ys)

thetas = ones(Float64, dim) 
# some adjustable parameters for optimization
options = Regression.Options()
# use gradient descent
solver = Regression.GD()
# run the optimization
Regression.solve!(solver, objective_function, thetas, options, Regression.no_op)
# clean up weak features
thetas = map(x-> abs(x) < 0.0001? 0 : x, thetas)

# visualize the data and the line
clf()
scatter(xs_o,ys,c="g")
min_x,max_x = foldr(min, Inf, xs_o),foldr(max, -Inf, xs_o)
plot_x = [min_x:0.01:max_x]
plot_y = map(x->f_e(x,thetas), plot_x)
plot(plot_x, plot_y, c="b")

     






  
