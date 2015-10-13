using Base.Test
include("../ElementCounter.jl")

data = ["a", "a", "b", "a", "c","b"]
c = ElmCounter(ASCIIString)
for e in data
    push!(c, e)
end

@test c.elms == Set(["a", "a", "b", "a", "c", "b"])
@test c.counts["a"] == 3
@test c.counts["b"] == 2
@test c.counts["c"] == 1

println("ElemenetCounter passed the test")
