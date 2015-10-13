using Distributions

N = 100000

unif = Uniform(0,1)
p(x) = 0.3e^(-0.2x^2)+0.7e^(-0.2(x-10)^2)
q_var = 10
q(x_r, x_g) = pdf(Normal(x_g, q_var), x_r)
A(x_i1, x_i) = min(1, (p(x_i1)*q(x_i, x_i1))/(p(x_i)*q(x_i1, x_i)))

x = zeros(N)
x[1] = 0
for i = 2:N
    u = rand(unif)
    x_i = rand(Normal(x[i-1], q_var))
    if (u < A(x_i, x[i-1]))
        x[i] = x_i
    else
        x[i] = x[i-1]
    end
end

