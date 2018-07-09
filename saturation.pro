; Last modified:   27 June 2018

; Saturation (from 15 May 2018 notes)
pro one_D
    ; 26 June 2018
    ; I think this creates an array showing the total number of pixels
    ; that are saturated in each image throughout time series.
    z = [0:684]
    n = n_elements(z)
    sat_arr = fltarr(n)
    data = A[0].data
    threshold = 10000
    for i = 0, n-1 do begin
        for y = 0, sz[1]-1 do begin
        for x = 0, sz[0]-1 do begin
            flux = data[ x, y, z[i]:z[i]+dz-1 ]
            sat = [where( flux ge threshold )]
            if not sat[0] eq -1 then begin
                sat_arr[i] = sat_arr[i] + 1
            endif
        endfor
        endfor
    endfor
    ;pixels = fltarr(n) + (500.*330.)
    ;good_pix = pixels / ( pixels - sat_arr )
    ;good_pix = [ good_pix, fltarr(dz) ]
    ; Divide power2 by this array ('this array' being good_pix, I think)
end

pro mask_3D, A
    for i = 0, n_elements(A)-1 do begin
        print, n_elements(where(A[i].map2 eq 0))

        sz = size(A[i].data, /dimensions)
        threshold = 10000
        mask_cube = fltarr(sz) + 1.0
        mask_cube[ where( A[i].data ge threshold ) ] = 0.0

        sz = size(A[i].map2, /dimensions)
        mask_map = fltarr(sz)
        dz = 64
        z_start = [0:sz[2]-1]
        foreach z, z_start do $
            mask_map[*,*,z] = product(mask_cube[*,*,z:z+dz-1], 3)
        A[i].map2 = A[i].map2 * mask_map
        print, n_elements(where(A[i].map2 eq 0))
    endfor
end

function SATURATION_MASK, data, threshold
    ; return array (mask) with same dimensions as data, with values
    ; set to 1.0 where data is UNsaturated, and 0.0 where data is saturated.

    sz = size( data, /dimensions )
    mask = fltarr(sz)
    mask[where( data lt threshold )] = 1.0
    mask[where( data ge threshold )] = 0.0
    return, mask
end

function MASK_MAP, mask, dz=dz

    ; This takes a while to run...

    ; cube = data cube with saturated pixels
    ;threshold = 15000
    ;mask = SATURATION_MASK( cube, threshold )
    sz = size(mask, /dimensions)
    mask_map = fltarr( sz[0], sz[1], sz[2]-dz )
    sz_new = size(mask_map, /dimensions)
    for i = 0, sz_new[2]-1 do begin
        mask_map[*,*,i] = product( mask[*,*,i:i+dz-1], 3 )
    endfor
    return, mask_map

end

function total_power_map, data, channel, threshold

    mask = SATURATION_MASK( data, threshold )
    mask_map = MASK_MAP( mask, dz=64 )
    ;if i eq 0 then aia1600map = map * mask_map
    ;if i eq 1 then aia1700map = map * mask_map
    num_unsaturated_pixels = total(total(mask_map,1),1)

    stop
    restore, '../aia' + channels[i] + 'map.sav'

    return, power

end

; 27 June 2018
; Currently, all I need to do here is use output from MASK_MAP to convert
;  TOTAL(map) to total per pixel,
; assuming that saturation threshold for newest set of maps is satisfactory.
; Shouldn't have to do anything for the 2D maps.


; 04 July 2018
; May 15, 16, 17 notes (IDL) on saturation (cool images!)
; Two purposes for saturation map/mask
; 1. multiply by power maps created with different threshold (possibly not needed).
; 2. divide total power by # pixels so power vs. time plot shows comparable values.
; Would also have two masks, one for each image (data) and
; one for product of dz images (map).
; = 1 where NOT saturated and = 0 where saturation happens.
