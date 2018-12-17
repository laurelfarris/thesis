;-
;- 14 December 2018
;-
;- (Copied this bit from bda.pro)
;-
;- Calculate saturation mask at given threshold and
;-   multiply by AIA powermaps
;-
;- NOTE:
;-  each map in AIA structure array ('A') is changed,
;-  not simply making a copy
;-
;-
;-
;-




function POWERMAP_MASK, $
    data, $
    dz, $
    exptime=exptime, $
    threshold=threshold

    
    start_time = systime(/seconds)


    if not keyword_set(threshold) then threshold = 15000.

    if keyword_set(exptime) then threshold = threshold/exptime

    ;print, "Exposure-time corrected threshold = ", threshold
    ;-  Values look correct.

    data_mask = data lt threshold

    sz = size(data_mask, /dimensions)
    sz[2] = sz[2]-dz+1


    ; Create power map mask (this takes a while to run...)
    map_mask = fltarr(sz)
    for ii = 0, sz[2]-1 do $
        map_mask[*,*,ii] = PRODUCT( data_mask[*,*,ii:ii+dz-1], 3 )

    print, "Finished computing mask in ", $
        (systime(/seconds)-start_time)/60., $
        " minutes."

    return, map_mask
end
