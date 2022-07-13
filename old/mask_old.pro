

;- LAST MODIFIED:   27 November 2018

;- NAME:
;-   MASK
;- PURPOSE:
;-   Calculate mask cube of 1s and 0s,
;-   = 0 where data pixels are saturated (GE threshold),
;-   = 1 where data pixels are not saturated (LT threshold).
;- Calling sequence:
;-    result = MASK( data, kw=kw )
;- INPUT:
;-   data - data cube
;-   threshold - optional keyword
;- Output:   Mask array with same dimensions as data cube


function MASK, $
    data, $
    threshold=threshold


    ;- Set default threshold.
    if not keyword_set(threshold) then threshold = 15000

    ; Create mask (saturated pixels = 0.0, others = 1.0)
    sz = size( data, /dimensions )
    mask = fltarr(sz)
    mask[where( data lt threshold )] = 1.0
    mask[where( data ge threshold )] = 0.0

    return, mask

end



;-----------------------------------------------------------------------------------
;- 23 October 2018
;-   (Older code that possibly does the same thing, or similar.)

;- If data is exptime-corrected, make sure input threshold is as well
;- This may take a while if data is large. Run on one data set first to make
;- sure everything looks right before the next one.


pro GET_MASK, data, mask, threshold, dz, data_avg, graphic=graphic


    ;- "sat" = saturated data mask
    sz = size(data, /dimensions)
    sat = fltarr(sz)

    
    sat[ where(data ge threshold) ] = 0.0
    sat[ where(data lt threshold) ] = 1.0

    ;- "mask" = product of data mask over length dz
    mask = fltarr( sz[0], sz[1], sz[2]-dz+1 )
    data_avg = fltarr( sz[0], sz[1], sz[2]-dz+1 )

    for ii = 0, sz[2]-dz do begin
        mask[*,*,ii] = product( sat[*, *, ii:ii+dz-1], 3 )
        data_avg[*,*,ii] = mean( data[*,*,ii:ii+dz-1], dim=3 )
    endfor

    if keyword_set(graphic) then begin
        im = objarr(n_elements(graphic))
        ;for ii = 0, n_elements(graphic) - 1 do begin
        foreach zz, graphic, ii do begin
            im[ii] = image2( mask[*,*,zz], /current ) 
        endforeach
    endif
end
