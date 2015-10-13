using PyPlot

f = open("data.csv","r")
readline(f)
data = readcsv(f)
close(f)
x = float(data[:,1:end-1])
y = float(data[:,end])

clf()
for i = 1:length(y)
    if y[i] == 1
        scatter(x[i,1],x[i,2],c="g")
    else
        scatter(x[i,1],x[i,2],c="b")
    end
end
