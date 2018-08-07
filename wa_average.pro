

function WA_AVERAGE, power

    dz = 64
    sz = size(power, /dimensions)
    ; sz[0] = 685
    ; sz[1] = 2

    ;arr = fltarr( 749, 686 ) ; dimensions I should have...
    arr = fltarr( 749, sz[0], sz[1] )


    for ii = 0, sz[1]-1 do begin

        power = power[*,ii]
        ;ones = fltarr(dz, sz[0]) + 1
        ;arr[0,0] = ones ; supposedly don't need '*' to do this...

        for jj = 0, sz[0]-1 do begin
            arr[ jj: jj+dz-1, jj, ii] = power[jj]
        endfor
    endfor

    return, arr

end

arr = WA_AVERAGE( A.power_flux )

end
