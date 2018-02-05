
FUNCTION radius, arr, x0=x0, y0=y0


    arr = reform( arr, n_elements(arr), /overwrite )

    dims = size( arr, /dimensions )
    locs = indgen( n_elements(arr) ) ;; unecessary variable, but keeps things less messy
    ind = float( array_indices( arr, locs ) )

    if not keyword_set(x0) then begin
        x0 = dims[0]/2
        y0 = dims[1]/2
    endif

    rad = fltarr( n_elements(arr) )
    for i = 0, n_elements(arr)-1 do begin
        x = ind[0,i] & y = ind[1,i]
        rad[i] = sqrt( (x0-x)^2 + (y0-y)^2 )
    endfor

    return, rad
    ;return, reform(rad, dims[0], dims[1])



END
