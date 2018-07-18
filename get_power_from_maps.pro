
; Last modified:   17 June 2018

; Purpose:      Get power as function of time from total power maps

; Input:        flux, cadence
; Keywords:     dz (sample length for fourier2.pro in data units)
;               fmin, fmax (frequency_bandwidth)
; Output:       Returns 1D array of power as function of time.
; To do:        Add test codes
;               Create new saturation routine (this currently addresses
;                 saturation and calculation of total power with time.



function GET_POWER_FROM_MAPS, $
    data=data, $
    channel=channel, $
    dz=dz, $
    threshold=threshold

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
