using Distributions

q = Normal(10,3)
u = Uniform(0,1)
g(x) = 8x
w(x) = pdf(u,x)/pdf(q,x)

N = 1000000

r, c = 0, 0
while (true)
    #don't know why this doesn't work
    x = rand(q)
    
    if (c >= N)
        break
    end

    if (c != 0)
        r = (r*(c-1)+g(x)*w(x))/c
    else
        r = g(x)*w(x)
    end
    
    println(r)
    
    c += 1
    
end

for i = 1:100
    #it works!
    println(string("all together: ",foldr((x,r) -> r += g(x)*w(x), 0, rand(q, N))/N))
end

