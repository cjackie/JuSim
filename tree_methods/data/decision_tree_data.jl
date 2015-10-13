##########################################################
# generate data with x1,x2,y. x1,x2 are features and y is
# the label. This is simulation data for testing purposes
##########################################################

### generate data
N = 1000                #number of data points
outpath = "decision_tree_data.csv"
header = "x1,x2,label\n"

outfile = open(outpath,"w")
write(outfile, header)
data = Array(Float64, N, 3)
for i = 1:N
    x1,x2 = rand()*10,rand()*10
    y = sqrt((x1-5)^2+(x2-5)^2) < 4 ? 1 : 2
    data[i,:] = [x1; x2; y]
    write(outfile, "$x1,$x2,$y\n")
end
close(outfile)

### visualize it
using PyPlot
data0 = Array(Float64, N, 3)
data0_i = 0
data1 = Array(Float64, N, 3)
data1_i = 0
for i = 1:N
    if data[i,3] == 1
        data0_i += 1
        data0[data0_i,:] = data[i,:]
    else
        data1_i += 1
        data1[data1_i,:] = data[i,:]
    end
end
scatter(data0[1:data0_i,1],data0[1:data0_i,2],c="g")
scatter(data1[1:data1_i,1],data1[1:data1_i,2],c="r")
        
        
