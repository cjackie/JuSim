################################################
# adaboost 
#############################################


#=
 metadata that can be passed to the adaboost.
 @itr_n, number of iterations to run
=#
type Options
    itr_n::Int
    verbose::Bool
end

function adaboost(x::Array{Float64,2}, y::Vector{Float64}, clasf::Classifier, options::Options)
    vn = length(y)
    itr_n, verbose = options.itr_n, options.verbose
    weights = ones(vn)/vn                    # data weights, init with equal weights
    hs = Array(Any, vn)                      # prediction models
    alphas = zeros(itr_n)                    # weights of each models
    verbose ? println("iteration") : 0
    for i = 1:options.itr_n
        m = clasf.build(x,vec(y),weights)
        pred_y = Array(Float64, vn)
        err = 0.0
        for j = 1:vn
            pred_y[j] = clasf.predict(m, vec(x[j,:]))
            if pred_y[j] != y[j]
                err += weights[j]
            end
        end
        alphas[i] = 1/2*log((1-err)/err)
        hs[i] = m
        weights = map(t->t[1]*e^(-alphas[i]*t[2]*t[3]), collect(zip(weights,y,pred_y)))
        weights = weights/foldr(+, 0, weights)
        verbose ? println(i) : 0
    end
    
    function predict(x::Vector{Float64})
        r = 0
        for i = 1:itr_n
            r += alphas[i]*clasf.predict(hs[i],x)
        end
        sign(r)
    end
end


