##########################################
# Stump, a tree with only two level
#########################################


#=
#  Stump to classify data with binary labels
#  @featid, a value from 1 to N to denote the column being splitted
#  @sp, seperation value
#  @label, label for the left w.r.t @sp at @featid. The right will be the opposite of it
=#
immutable Stump
    featid::Int
    sp::Real
    label::Float64
end

# assume that the y is with labels either 1 or -1
function build_stump(x::Array{Float64,2}, y::Vector{Float64}, weights::Vector{Float64})
    best = Stump(1,x[1,1], 1), _loss(Stump(1,x[1,1], 1), x, y, weights)
    for i = 1:size(x,2)
        for j in unique(x[:,i])
            for k in [1.0,-1.0]
                s_tmp = Stump(i, j, k)
                l = _loss(s_tmp, x, y, weights)
                best = l < best[2] ? (s_tmp, l) : best
            end
        end
    end
    best[1]
end

function _loss(stump::Stump, x::Array{Float64,2}, y::Vector{Float64}, weights::Vector{Float64})
    
    left = x[:,stump.featid] .<= stump.sp
    pred_y = map(x -> x ? stump.label : -stump.label, left)
    miss_classificaitons = pred_y .!= y
    r = 0
    for i = 1:length(miss_classificaitons)
        if miss_classificaitons[i]
            r += weights[i]
        end
    end
    r
end

function predict(stump::Stump, x::Vector{Float64})
    x[stump.featid] <= stump.sp ? stump.label : -stump.label
end

