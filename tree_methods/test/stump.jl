include("../stump.jl")

f = open("../data/stump_data1.csv")
data = readcsv(f)
x = float(data[2:end,1:2])
y = float(data[2:end,3])
weights = ones(Float64,length(y))/length(y)
s = build_stump(x,vec(y),vec(weights))
close(f)
println(s)



