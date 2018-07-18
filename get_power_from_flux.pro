
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

    ; Calculate power for time series between each value of z and z+dz
    foreach z, z_start, i do begin
        struc = CALC_FT( flux[z:z+dz-1], cadence, fmin=fmin, fmax=fmax, norm=norm )
        power[i] = struc.mean_power
    endforeach

    ; Default frequency bandpass = 1 mHz (centered at 3-minute period)

    ; Calculate power per pixel
    if keyword_set(data) then begin
        sz = size(data,/dimensions)
        n_pixels = sz[0] * sz[1]
        power = power / n_pixels
    endif

    return, power
end
