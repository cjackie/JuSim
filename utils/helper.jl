using KernelDensity

function isnumtype(str::String)
    reg = r"^[0-9]+.?[0-9]*$"
    ismatch(reg, str)
end

function isbooltype(str::String)
    str == "false" ||  str == "true"
end

function iswhitespace(c::Char)
    c == ' ' || c == '\t' || c == '\r' || c == '\n'
end


#trim out white space and "
function trim(str::String)
    i_b = 1
    i_e = length(str)
    for i = 1:length(str)
        if !iswhitespace(str[i])
            i_b = i
            break
        end
    end
    for i = length(str):-1:1
        if !iswhitespace(str[i])
            i_e = i
            break
        end
    end
    if i_e >= i_b
        str = str[i_b:i_e]
    end

    if length(str) > 1 && str[1] == '"' && str[end] == '"'
        str = str[2:end-1]
    end
    str
end

#return a function that produce counter of n size
function counter(n::Int)
    function f()
        i = 1
        while true
            produce(i)
            i = (i % n)+1
        end
    end
    Task(f)
end

#count number of accurance of discrete elements
#return a dictionary of counts
function discrete_count(a::AbstractArray, t::Type)
    d = Dict{t, Int}()
    s = Set{t}()
    for elm in a
        if elm in s
            d[elm] += 1
        else
            d[elm] = 1
            push!(s,elm)
        end
    end
    d
end

#multinomial model with two clusters(0 and 1). prior is an equal prior
function multinomial_with2(data::Array{ASCIIString}, labels::Array{Int}, prior::Int = 20)
    distinct_alphabets = Set{ASCIIString}()
    for d in data
        push!(distinct_alphabets, d)
    end
    
    #remap the discrete value
    mapping = Dict{ASCIIString, Int}()
    n = 0
    for s in distinct_alphabets
        n += 1
        mapping[s] = n
    end
    #find a distinct others mapping
    others = ""
    while true
        others = string(rand())
        if !(others in distinct_alphabets)
            break
        end
    end
    n += 1
    mapping[others] = n

    #counting
    a0_i,a1_i = 0,0
    a0 = zeros(Int, n)
    a1 = zeros(Int, n)
    for j = 1:length(data)
        if labels[j] == 0
            a0[mapping[data[j]]] += 1
        else
            a1[mapping[data[j]]] += 1
        end
    end

    sum_a0 = foldr(+, a0)
    sum_a1 = foldr(+, a1)
    p_a0 = map(x->(x+prior)/(sum_a0+prior*length(a0)), a0)
    p_a1 = map(x->(x+prior)/(sum_a1+prior*length(a1)), a1)
    
    #contruct the predict function. likelihood of x given label c
    function predict(x::ASCIIString, c::Int)
        p = 1
        if c == 0
            p = x in distinct_alphabets ? p_a0[mapping[x]] : p_a0[mapping[others]]
        else
            p = x in distinct_alphabets ? p_a1[mapping[x]] : p_a1[mapping[others]]
        end
        p
    end

    predict
end

#kernel density estimation with 2 clusters(0,1)
function kde_with2(data::Array{Float64}, labels::Array{Int})
    n_col = length(data)
    num0 = Array(Float64, n_col)
    num1 = Array(Float64, n_col)
    num0_i,num1_i = 0,0
    for j = 1:n_col
        if labels[j] == 0
            num0_i += 1
            num0[num0_i] = data[j]
        else
            num1_i += 1
            num1[num1_i] = data[j]
        end
    end 

    k0 = kde(num0[1:num0_i])
    k1 = kde(num1[1:num1_i])

    function predict(x::String, c::Int)
        x = float(x)
        p0 = pdf(k0, x)
        p1 = pdf(k1, x)
        p = 1.0

        if isnan(p0) ||  isnan(p1)
            #this is wierd.....
            p = 0.5
        else
            p = c == 0 ? p0 : p1
        end
        p
    end
    
    predict
end

#normalize a discrete probability
function normalize(p::Union(Array{Float64},Array{Int}))
    sum_p = foldr(+,0,p)
    map(x->x/sum_p, p)
end

    


                   
