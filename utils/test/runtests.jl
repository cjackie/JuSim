testfiles = [
             "helper",
             "matrix_builder"
             ]
             
for t in testfiles
    test_fn = "$t.jl"
    print_with_color(:blue, "* $test_fn\n")
    include(test_fn)
end
