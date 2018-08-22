

function WA_AVERAGE, flux, power, dz=dz


    ;sz = size(power, /dimensions)
    ; sz[0] = 685
    ; sz[1] = 2

    ;arr = fltarr( 749, 686 ) ; dimensions I should have...
    ;arr = fltarr( 749, sz[0], sz[1] )


    flux_len = n_elements(flux)
    power_len = n_elements(power)
    arr = fltarr( flux_len, power_len )


    ;for ii = 0, sz[1]-1 do begin

        ;power = power[*,ii]
        ;ones = fltarr(dz, sz[0]) + 1
        ;arr[0,0] = ones ; supposedly don't need '*' to do this...

        ;for jj = 0, sz[0]-1 do begin
        for jj = 0, power_len-1 do begin
            ;arr[ jj: jj+dz-1, jj, ii] = power[jj]
            arr[ jj: jj+dz-1, jj ] = power[jj]
        endfor
    ;endfor


    new_power = mean( arr, dimension=2 )
    N = n_elements(new_power)

    new_power = new_power[ dz-1 : N-dz ]

    return, new_power

end

arr = WA_AVERAGE( A.power_flux )


end
