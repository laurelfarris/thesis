;- Only works for 1D array!
function mynorm, arr


    norm_arr = ( arr - min(arr) )/( max(arr) - min(arr) )
    return, norm_arr
end
