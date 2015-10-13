##################################################################
# implementation of a decision tree
# based on the book "Elem of Statistical Learning Data.."
# by T. Hastie at. el. chp 8.
# non recursion is used.
##############################################################
include("../utils/matrix_builder.jl")
include("../decision_tree.jl")

### start testing
datapath = "./data/decision_tree_data.csv"
datafile = open(datapath, "r")
header = readline(datafile)
data = Array(Float64, 0, 3)
data_i = 0
while true
    line = readline(datafile)
    if line == ""
        break
    end

    row = map(x->float(x), split(line,","))
    data_i += 1
    data = add_row(data, data_i, row)
end
data = data[1:data_i,:]
matrix = data[:,1:end-1]
labels = map(x->int(x), data[:,end])

meta = Dict()
meta["labels_size"] = 2
meta["total_step"] = 100
meta["range"] = [(0,10), (0,10)]
println(pick_spoint(matrix, labels, meta))
readline()



meta["labels_size"] = 2
meta["total_step"] = 100
feats_range = Array(Tuple,size(matrix,2))
for i = 1:size(matrix,2)
    feat_max = foldr(max, -Inf, matrix[:,i])
    feat_min = foldr(min, Inf, matrix[:,i])
    feats_range[i] = (feat_min, feat_max)
end
meta["range"] = feats_range
meta["maxdepth"] = 10

tree = build_tree(matrix, labels, meta)





