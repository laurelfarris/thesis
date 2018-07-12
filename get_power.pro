
; Last modified:   05 June 2018

; Purpose:      Get power as function of time, 
;                either from total flux or from total power maps

; Input:        flux, cadence
; Keywords:     dz (sample length for fourier2.pro in data units)
;               fmin, fmax (frequency_bandwidth)
; Output:       Returns 1D array of power as function of time.
; To do:        Add test codes
;               Create new saturation routine (this currently addresses
;                 saturation and calculation of total power with time.



function GET_POWER_FROM_MAPS, $
    data, $
    channel, $
    threshold=threshold, $
    dz=dz

    if not keyword_set(threshold) then threshold = 10000

    ; Create data mask (saturated pixels = 0.0, others = 1.0)
    sz = size( data, /dimensions )
    mask = fltarr(sz)
    mask[where( data lt threshold )] = 1.0
    mask[where( data ge threshold )] = 0.0

    ; Create power map mask (this takes a while to run...)
    sz[2] = sz[2]-dz
    mask_map = fltarr(sz)
    for i = 0, sz[2]-1 do $
        mask_map[*,*,i] = product( mask[*,*,i:i+dz-1], 3 )

    num_unsaturated_pixels = total(total(mask_map,1),1)

    restore, '../aia' + channel + 'map.sav'
    power = total( total( map, 1), 1 )
    power_per_pixel = power / num_unsaturated_pixels

    return, power_per_pixel
end


function GET_POWER_FROM_FLUX, $
    flux, cadence, $
    dz=dz, $
    fmin=fmin, $
    fmax=fmax, $
    ;z_start=z_start, $
    norm=norm

    ; This first bit is exactly like power_maps.pro....
    N = n_elements(flux)

    ;if n_elements(z_start) eq 0 then z_start = indgen(N-dz)
    z_start = indgen(N-dz)

    ; initialize power array
    power = fltarr(N-dz)

    ; Calculate power for time series between each value of z and z+dz
    foreach z, z_start, i do begin
        struc = CALC_FT( flux[z:z+dz-1], cadence, fmin=fmin, fmax=fmax, norm=norm )
        power[i] = struc.mean_power
    endforeach
    return, power
end


function GET_POWER, $
    flux, $
    cadence=cadence, $
    channel=channel, $
    data=data, $
    threshold=threshold, $
    _EXTRA=e

    ; Power from total flux (doesn't take long at all)
    ; Default frequency bandpass = 1 mHz (centered at 3-minute period)
    power = GET_POWER_FROM_FLUX( $
        flux, cadence, $
        dz = 64, $
        fmin = 0.005, $
        fmax = 0.006, $
        norm = 0, $
        _EXTRA = e)

    if keyword_set(data) then begin
        sz = size(data,/dimensions)
        n_pixels = sz[0] * sz[1]
        power = power / n_pixels
    endif

    return, power
end
