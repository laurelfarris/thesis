; Last modified:        24 April 2017
; Programmer:           Laurel Farris
; Description:          Get array of locations to run cc on


function REF_LOCS, dims, x0, y0, s


    map = intarr(dims[0],dims[1])
    map[ x0-s:x0+s, y0-s:y0+s ] = 1
    locs = where(map eq 1)
    refs = array_indices( map, locs )

    num_refs = n_elements(locs)
    if num_refs eq 1 then refs = reform( refs, 2, 1)

    return, refs

end
