using Base.Test

include("../matrix_builder.jl")

m_t = [2 3;
       1 3;
       3 1]
       
m = Array(Int, 0, 2)
m = add_row(m, 1, m_t[1,:])
m = add_row(m, 2, m_t[2,:])
m = add_row(m, 3, m_t[3,:])
@test m[1:3,:] == m_t

m = add_row(m, 1000, [2;3])
@test vec(m[1000,:]) == [2;3]


println("test for matrix_builder.jl is passed")


