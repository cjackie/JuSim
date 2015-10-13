using Base.Test
using KernelDensity

include("../helper.jl")

#test discrete_count
a = [1,4,5,1,3,5,2,1]
c = discrete_count(a, Int)
@test c[1] == 3
@test c[2] == 1
@test c[3] == 1
@test c[4] == 1
@test c[5] == 2

#test multinomial_with2
data = map(x->string(x), a)
labels = [1,0,0,0,1,0,0,1]
m = multinomial_with2(data,labels,1)
@test m("1", 1) == 3/9
@test m("3", 1) == 2/9
@test m("5", 1) == 1/9
@test m("?", 1) == 1/9
total_prob = foldr(+, 0, map(x->m(x,1), ["1","2","3","4","5","??"]))
@test total_prob == 1
@test m("1", 0) == 2/11
@test m("5", 0) == 3/11
@test m("/?", 0) == 1/11

#sort of test kde_with2
a0 = map(x->(x,0),rand(100))
a1 = map(x->(x,1),rand(100))
a = [a0,a1]
shuffle!(a)
m = kde_with2(map(x->x[1], a), map(x->x[2],a))
d0 = kde(map(x->x[1],a0))
d1 = kde(map(x->x[1],a1))
samples = [[-2:0.1:2], 100]
for s in samples
    if isnan(pdf(d0, s)) || isnan(pdf(d1, s))
        @test m(string(s), 1) == 0.5
        @test m(string(s), 0) == 0.5
    else
        @test_approx_eq m(string(s), 1) pdf(d1, s)
        @test_approx_eq m(string(s), 0) pdf(d0, s)
    end
end

#test normalize
a = [2,3,4,1]
b = normalize(a)
@test b[1] == 0.2
@test b[end] == 0.1
b = normalize(map(x->float(x), a))
@test b[1] == 0.2
@test b[end] == 0.1

println("helper.jl passed the test")
