
# add a row to a 2d matrix, return the new array
function add_row{T}(m::Array{T,2}, i::Int, row::Array{T})
    if i > size(m, 1)
        N = size(m,1)
        while i > N
            N = (N+1)*2
        end
        m_new = Array(T, N, size(m,2))
        m_new[1:size(m, 1),:] = m
        m = m_new
    end
    m[i,:] = row
    m
end

