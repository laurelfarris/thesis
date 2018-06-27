;; Last modified:   18 May 2018 02:55:42

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

    sz = size( data, /dimensions )
    mask = fltarr(sz)
    mask[where( data lt threshold )] = 1.0
    mask[where( data ge threshold )] = 0.0
    return, mask

end


function MASK_MAP, cube

    threshold = 10000
    mask = SATURATION_MASK( cube, threshold )
    sz = size(mask, /dimensions)

    dz = 64
    mask_map = fltarr(sz[0],sz[1],sz[2]-dz-1)
    foreach z,[0:sz[2]-dz-1] do begin
        mask_map[*,*,z] = product( mask, 3 )
    endforeach
end

print, max(cube)

end
