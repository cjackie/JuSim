######################################################
# sample script to run the adaboost with stump as the
# blackbox classifier
######################################################
using PyPlot
include("../stump.jl")
include("../adaboost.jl")

f = open("../data/data.csv","r")
readline(f)
data = readcsv(f)
x = float(data[:,1:end-1])
y = float(data[:,end])

opt = Options(50,true)
p = adaboost(x ,y ,stump_classifier, opt)

# try use the model to predict
x1_max, x1_min = foldr(max, -Inf, x[:,1]), foldr(min, Inf, x[:,1])
x2_max, x2_min = foldr(max, -Inf, x[:,2]), foldr(min, Inf, x[:,2])
N = 50
delta1 = (x1_max-x1_min)/N
delta2 = (x2_max-x2_min)/N
d = Array(Float64, N*N, 3)
for i = 1:N
    for j = 1:N
        k = N*(i-1)+j
        d[k,1:2] = [x1_min+delta1*i,x2_min+delta2*j]
        d[k,3] = p(vec(d[k,1:2]))
    end
end

# visualize the result
let
    y_1 = d[:,3] .== 1.0
    x_1 = d[y_1,1:2]
    x_not1 = d[!y_1,1:2]
    scatter(x_1[:,1],x_1[:,2],c="g")
    scatter(x_not1[:,1],x_not1[:,2],c="b")
end




