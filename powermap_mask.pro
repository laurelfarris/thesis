;-
;- 14 December 2018
;-
;- (Copied this bit from bda.pro)
;-
;- Calculate saturation mask at given threshold and
;-   multiply by AIA powermaps
;-
;- NOTE:
;-  each map in AIA structure array ('A') is changed, not making a copy
;-
;-

function POWERMAP_MASK, $
    data, $
    dz=dz, $
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


;+
;- Thu Dec 20 09:59:36 MST 2018
;- Multiply maps by saturation mask (from bda.pro)
;-

@restore_maps


print, ''
print, ' Type ".CONTINUE" to apply saturation mask to powermaps.'
print, ''
stop


for cc = 0, 1 do begin
    map_mask = POWERMAP_MASK( $
        A[cc].data, $
        dz=64, $
        exptime=A[cc].exptime, $
        threshold=10000. )

    A[cc].map = A[cc].map * map_mask
endfor

end
