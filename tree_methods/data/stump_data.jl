using PyPlot

visualization = true
N = 100
featid = 1
split_point = 5
x = reshape(rand(N)*10, int(N/2), 2)
y = map(x->x ? 1 : -1, x[:,featid] .< 5)
if visualization
    for i = 1:length(y)
        if y[i] == 1
            scatter(x[i,1],x[i,2],c="g")
        else
            scatter(x[i,1],x[i,2],c="b")
        end
    end
end

out = open("stump_data1.csv","w")
write(out, "x1,x2,y\n")
for i = 1:length(y)
    write(out, "$(x[io,1]),$(x[i,2]),$(y[i])\n")
end
close(out)
