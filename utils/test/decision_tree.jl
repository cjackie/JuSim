using Base.Test
include("../decision_tree.jl")

#test get_pk function
meta = {"labels_size" => 2}
labels = [1,2,2,1,2,2,2,1,2,2]
r = get_pk(labels,meta)
@test r[1] == 0.3
@test r[2] == 0.7

#test lost function
@test_approx_eq loss_func(labels,meta) 0.42

#test pick_spoint
d = [(i,j) for i = 1:10,j=1:10]
m = Array(Float64,length(d),3)
for i = 1:length(d) 
    if d[i][1] < 5.5
        m[i,:] = [d[i][1],d[i][2],1]
    else
        m[i,:] = [d[i][1],d[i][2],2]
    end
end
meta["total_step"] = 500
meta["range"] = [(1,10),(1,10)]
featid,spoint = pick_spoint(m[:,1:2],map(x->int(x),(m[:,3])),meta)
@test featid == 1
@test spoint > 5 && spoint < 6

for i = 1:length(d) 
    if d[i][2] < 8.5
        m[i,:] = [d[i][1],d[i][2],1]
    else
        m[i,:] = [d[i][1],d[i][2],2]
    end
end
meta["total_step"] = 500
meta["range"] = [(1,10),(1,10)]
featid,spoint = pick_spoint(m[:,1:2],map(x->int(x),(m[:,3])),meta)
@test featid == 2
@test spoint > 8 && spoint < 9

#test build tree
