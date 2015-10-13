using PyPlot

#dummy data
data = map(x->rand(), 1:100)

for i = 1:100000
    input = rand()                  #dummy input
    data[1:end-1] = data[2:end]
    data[end] = input
    cla()
    plot(data)
    sleep(0.05)
end
