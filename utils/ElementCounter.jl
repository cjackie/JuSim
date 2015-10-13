
type ElmCounter{T}
    elms::Set{T}
    counts::Dict{T,Int}
end

function ElmCounter(t::DataType)
    ElmCounter(Set{t}(),Dict{t,Int}())    
end

function push!{T}(elmcounter::ElmCounter{T}, elm::T)
    if !(elm in elmcounter.elms)
        elmcounter.counts[elm] = 1
        Base.push!(elmcounter.elms, elm)
    else
        elmcounter.counts[elm] += 1
    end
end

