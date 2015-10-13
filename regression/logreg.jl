###########################################
# simple logistic regression demo
#########################################

using Regression
using Distributions
using PyPlot

function plot2d_binary(xs, ys)
    xs0 = xs[ys .== -1,:]
    xs1 = xs[ys .== 1,:]
    scatter(xs0[:,1],xs0[:,2],c="g")
    scatter(xs1[:,1],xs1[:,2],c="b")
end

clf()
sample_n = 500
real_thetas = [2,2,-1]
real_dim = 2
xs = Array(Float64, sample_n, real_dim)
axis_range = (-10,10)
ys = Array(Float64, sample_n)
noise = Normal(0,3)
for i = 1:sample_n
    x1 = (rand()-1/2)*(axis_range[2]-axis_range[1])
    x2 = (rand()-1/2)*(axis_range[2]-axis_range[1])
    xs[i,:] = [x1,x2]
    anoise = rand(noise)
    u = (real_thetas'*[1,x1,x2])[1]
    ys[i] = sign(1/(1+e^(-u-anoise))-0.5)
end
# quick check on the data
plot2d_binary(xs,ys)

# start using logreg
dim = 2
reg_c = 1.0
rmodel = riskmodel(AffinePred(dim), LogisticLoss())
reg = SqrL2Reg(reg_c)
objective_function = Regression.RegRiskFun(rmodel, reg, xs', ys)
es_thetas = [1.0, 1.0, 0.0]
options = Regression.Options(verbosity=:iter)
function cb(t, theta, v, g)
    f(x) = -theta[1]/theta[2]*x-theta[3]/theta[2]
    line_x =[axis_range[1]:0.1:axis_range[2]]
    if t % 10 == 0
        # plot the data
        clf()
        plot2d_binary(xs,ys)
        plot(line_x, map(f, line_x), c="k")
        sleep(1)
    end
end
Regression.solve!(GD(),objective_function, es_thetas, options, cb)


    
