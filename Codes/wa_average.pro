
; To-do:    This is a little hacky... optimize later.

function WA_AVERAGE, flux, power, dz=dz


    x = n_elements(flux)
    y = n_elements(power)
    arr = fltarr( x, y )

    ; Set sub-arrays of length dz equal to power[i]
    ; step in x and y at the same time
    for i = 0, y-1 do begin
        arr[ i : i+dz-1, i ] = power[i]
        ;arr[ 0 : dz-1, i ] = power[i]
        ;arr[ *, i ] = shift(...)
    endfor

    ; Set new power to average(arr)
    arr2 = mean( arr, dimension=2 )
    N = n_elements(arr2)

    i1 = dz-1
    i2 = N-dz ; no need to subtract 1 because of inclusivity of indices.

    new_power = arr2[i1:i2]
    return, new_power
end

arr = WA_AVERAGE( A.power_flux )

end
