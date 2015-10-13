const NO_BEST = (0,0)

type Leaf
    pk::Vector{Float64}
end

type Node
    featid::Int
    spoint::Float64
    pk::Vector{Float64}
    left::Union(Node,Leaf)
    right::Union(Node,Leaf)
end

#get probability for each k class
function get_pk(labels::Vector{Int}, meta::Dict{Any,Any})
    #meta["labels_size"] is the labels size, 1 to K
    label_size = meta["labels_size"]
    label_count = zeros(Int, label_size)
    N = length(labels)
    for i = 1:N
        label_count[labels[i]] += 1
    end
    map(x->x/N, label_count)
end

#loss function is Gini index
#return a loss function. 
function loss_func(labels::Vector{Int}, meta::Dict{Any,Any})
    pk = get_pk(labels, meta)
    foldr(+,0,map(x->x*(1-x), pk))
end

#TODO some loss is NaN???
#return feature id and split point
function pick_spoint(matrix::Array{Float64,2}, labels::Vector{Int}, meta::Dict{Any,Any})
    #meta["total_step"] is the discretization factor for continuous signal
    #meta["range"] is a vector of tuples, range of each features
    steps = meta["total_step"]
    feats_range = meta["range"]

    best = NO_BEST
    minloss = Inf
    for i = 1:size(matrix,2)
        stepsize = (feats_range[i][2]-feats_range[i][1])/steps
        for t = feats_range[i][1]:stepsize:feats_range[i][2]
            l = matrix[:,i] .< t
            left,right = labels[l],labels[!l]
            loss = loss_func(left, meta) + loss_func(right, meta)
            if loss < minloss
                minloss = loss
                best = i,t
            end
        end
    end
    best
end

function build_tree(matrix::Array{Float64,2}, labels::Vector{Int}, depth, meta::Dict{Any,Any})
    if depth > meta["maxdepth"] || all(x->x==labels[1], labels)
        return Leaf(get_pk(labels,meta))
    else
        featid,spoint = pick_spoint(matrix, labels, meta)
        t = matrix[:,featid] .< spoint
        m_left,m_right = matrix[t,:],matrix[!t,:]
        l_left,l_right = labels[t], labels[!t]
        left_node = build_tree(m_left, l_left, depth+1, meta)
        right_node = build_tree(m_right, l_right, depth+1, meta)
        return Node(featid, spoint, get_pk(labels, meta), left_node, right_node)
    end
end

function build_tree(matrix::Array{Float64,2}, labels::Vector{Int}, meta::Dict{Any,Any})
    build_tree(matrix, labels, 0, meta)
end

function predict(tree::Node, x::Vector{Float64})
    current::Union{Leaf,Node} = tree
    while typeof(current) != Leaf
        current =  x[current.featid] < current.spoint ? current.left : current.right
    end
    current.pk
end

