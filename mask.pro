


;- 23 October 2018

;- If data is exptime-corrected, make sure input threshold is as well
;- This may take a while if data is large. Run on one data set first to make
;- sure everything looks right before the next one.


function MASK, data, threshold, dz, graphic=graphic


    ;- "sat" = saturated data mask
    sz = size(data, /dimensions)
    sat = fltarr(sz)

    
    sat[ where(data ge threshold) ] = 0.0
    sat[ where(data lt threshold) ] = 1.0

    ;- "mask" = product of data mask over length dz
    mask = fltarr( sz[0], sz[1], sz[2]-dz+1 )

    for ii = 0, sz[2]-dz do begin

        mask[*,*,ii] = product( sat[*, *, ii:ii+dz-1], 3 )

    endfor

    if keyword_set(graphic) then begin


        im = objarr(n_elements(graphic))
        ;for ii = 0, n_elements(graphic) - 1 do begin
        foreach zz, graphic, ii do begin

            im[ii] = image2( mask[*,*,zz], /current ) 

        endforeach

    endif


    return, mask

end
