using HDF5
using PyPlot
using Distributions

# visualization flag
v_flag = true

# generate simulation data and save it to a file in HDF5 format
N = 1000
data_dist = Normal(1.0, 2.0)
data = rand(data_dist, N)
labels = map((x)->pdf(data_dist, x), data)*10
let xs = nothing, ys = nothing, d = nothing
    if v_flag
        clf()
        d = sort(collect(zip(data,labels)), by=(x)->x[1])
        xs = map((x)->x[1], d)
        ys = map((x)->x[2], d)
        plot(xs,ys)
    end
end

# write out to the disk
fn = "train.hdf5"
fid = h5open(fn, "w")
write(fid, "data", data)
write(fid, "labels", labels)
close(fid)

# create file list text file
open("data.txt", "w") do f
    write(f, "$(pwd())/$(fn)\n")
end

    
