using PyPlot
using Mocha


# use mocha TODO
logit_layer = InnerProductLayer(name="logit", neuron=Neurons.Sigmoid(), output_dim=4,  tops=[:logit], bottoms=[:data])
ip_layer = InnerProductLayer(name="sum", output_dim=1,  tops=[:loss], bottoms=[:logit])
common_layer = [logit_layer, ip_layer]

data_layer = AsyncHDF5DataLayer(name="data", source="data/data.txt", batch_size=64, tops=[:data,:labels], shuffle=true)
loss_layer = SquareLossLayer(name="loss", bottoms=[:loss,:labels])

backend = DefaultBackend()
init(backend)

training_net = Net("my_first_neural_net", backend, [data_layer, common_layer, loss_layer])
println(training_net)
exp_dir = "snapshots"
method = SGD()
params = make_solver_parameters(method, max_iter=1000, regu_coef=0.0005,
                       mom_policy=MomPolicy.Fixed(0.9),
                       lr_policy=LRPolicy.Inv(0.01, 0.0001, 0.75),
                       load_from=exp_dir)
solver = Solver(method, params)

add_coffee_break(solver, TrainingSummary(), every_n_iter=10)
add_coffee_break(solver, Snapshot(exp_dir), every_n_iter=500)

solve(solver, training_net)

# visualize predicted values
mem_data = MemoryDataLayer(name="data", tops=[:data], batch_size=1,
                           data=Array[zeros(1)])
out_layer = IdentityLayer(name="output", tops=[:output], bottoms=[:loss])

run_net = Net("model", backend, [mem_data, common_layer, out_layer])
println(run_net)

xs = [-6:0.1:6]
ys = zeros(length(xs))
for i = 1:length(xs)
    mem_data.data[1][1] = xs[i]
    forward(run_net)
    ys[i] = run_net.output_blobs[:output].data[1]
end

plot(xs, ys)









