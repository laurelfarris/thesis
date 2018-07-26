
; Last modified:   17 June 2018

; Purpose:      Get power as function of time from total flux

; Input:        flux, cadence
; Keywords:     dz (sample length for fourier2.pro in data units)
;               fmin, fmax (frequency_bandwidth)
; Output:       Returns 1D array of power as function of time.
; To do:        Add test codes
;               Create new saturation routine (this currently addresses
;                 saturation and calculation of total power with time.



function GET_POWER_FROM_FLUX, $
    flux=flux, $
    cadence=cadence, $
    dz=dz, $
    fmin=fmin, $
    fmax=fmax, $
    norm=norm, $
    data=data

    ; This first bit is exactly like power_maps.pro....
    N = n_elements(flux)
    z_start = indgen(N-dz)
    power = fltarr(N-dz)  ; initialize power array

    ; Calculate power per pixel
    ;   23 July 2018
    ;   - moved this to divide flux by n_pixels before calculating FT
    if keyword_set(data) then begin
        sz = size(data,/dimensions)
        n_pixels = float(sz[0]) * sz[1]
        flux = flux / n_pixels
        ;power = power / n_pixels
    endif

    ; Calculate power for time series between each value of z and z+dz
    foreach z, z_start, i do begin
        struc = CALC_FT( flux[z:z+dz-1], cadence, fmin=fmin, fmax=fmax, norm=norm )
        power[i] = struc.mean_power
    endforeach

    ; Default frequency bandpass = 1 mHz (centered at 3-minute period)

    return, power
end

; Save power arrays to variable ---------------------------------------------------------------------------------
    for i = 0, n_elements(A)-1 do begin
        ;A[i].power_flux = GET_POWER_FROM_FLUX( $
power_flux = GET_POWER_FROM_FLUX( $
            flux=A[i].flux, $
            cadence=A[i].cadence, $
            dz=64, $
            fmin=0.005, $
            fmax=0.006, $
            norm=0, $
            data=A[i].data )
    endfor

stop;---------------------------------------------------------------------------------



power_test = get_power_from_flux( $
    flux=A[0].flux/(330.*500), cadence=24, dz=64, $
    fmin=0.005, fmax=0.006, norm=0 ) 

p1 = plot2( A[0].power_flux, name='FT(flux)/N', ylog=1)
p2 = plot2( power_test, /overplot, name='FT(flux/N)', color='red', ylog=1 )


end
