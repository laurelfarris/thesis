
; LAST MODIFIED:
;   28 November 2018
;
; PURPOSE:
;   Get power as function of time from total power maps
; INPUT:
;   flux, cadence
; KEYWORDS:
;   dz (sample length for fourier2.pro in data units)
;   fmin, fmax (frequency_bandwidth)
; OUTPUT:
;   Returns 1D array of power as function of time.
; TO DO:
;   Add test codes
;   Create new saturation routine (this currently addresses
;      saturation and calculation of total power with time.



function GET_POWER_FROM_MAPS, $
    data, $
    channel=channel, $
    dz=dz, $
    threshold=threshold


    ;-  Calculate saturation mask

    if not keyword_set(threshold) then threshold = 10000

    resolve_routine, 'mask', /either
    data_mask = MASK( data, threshold=threshold )
    ;- NOTE: default value of threshold will be returned to this
    ;-  level from MASK routine.

    sz = size(data_mask, /dimensions)

    sz[2] = sz[2]-dz+1

    ; Create power map mask (this takes a while to run...)
    map_mask = fltarr(sz)
    for ii = 0, sz[2]-1 do $
        map_mask[*,*,ii] = PRODUCT( data_mask[*,*,ii:ii+dz-1], 3 )

    return, map_mask
end


;- 25 November 2018
;- P(t) plots from maps.

goto, start
start:;----------------------------------------------------------------------------------------

dz = 64

; Calculate P(t) from power maps

map_mask = fltarr(500,330,686,n_elements(A))


;- This can take a while. Make .sav file, or at least don't overwrite variable.
for cc = 0, n_elements(A)-1 do begin
    map_mask[*,*,*,cc] = GET_POWER_FROM_MAPS( $
        A[cc].data, $
        channel=A[cc].channel, $
        threshold=10000./A[cc].exptime, $
        dz = dz )
endfor

;- In case maps weren't restored in prep.pro:
;restore, '../aia1600map_2.sav'
;A[0].map = map
;restore, '../aia1700map_2.sav'
;A[1].map = map

;- Correct maps for saturation
map = A.map * map_mask

;- 1D array of power summed over each map.
power_from_maps = total(total(map,1),1)

;- 1D array of # unsaturated pixels at each index.
unsat = float(total(total(map_mask,1),1))

;- Divide power array by # (unsaturated) pixels
power_per_pixel = power_from_maps/unsat


;- Correct for exposure time.
power = power_per_pixel
power[*,0] = power_per_pixel[*,0]*A[0].exptime
power[*,1] = power_per_pixel[*,1]*A[1].exptime


    sz = size(power,/dimensions)
    xdata = [ [indgen(sz[0])], [indgen(sz[0])] ] + (dz/2)

    resolve_routine, 'batch_plot', /either
    dw
    plt = BATCH_PLOT( $
        xdata, power, $
        xrange=[0,748], $
        ytitle='3-minute power', $
        yrange=[-250,480], $
        yminor=4, $
        color=A.color, $
        name=A.name, $
        buffer=0 )


    ax = plt[0].axes
    ax[1].tickvalues=[-100:500:100]
    ax = plt[1].axes
    ax[3].tickvalues=[1200:1900:100]
    ax[1].title = A[0].name + ' 3-minute power'
    ax[3].title = A[1].name + ' 3-minute power'

    resolve_routine, 'shift_ydata', /either
    SHIFT_YDATA, plt

    resolve_routine, 'normalize_ydata', /either
    NORMALIZE_YDATA, plt

    resolve_routine, 'label_time', /either
    LABEL_TIME, plt, time=A.time;, jd=A.jd

    resolve_routine, 'oplot_flare_lines', /either
    OPLOT_FLARE_LINES, plt, t_obs=A[0].time;, jd=A.jd

    resolve_routine, 'legend2', /either
    leg = LEGEND2( target=plt, sample_width=0.30 )

stop

resolve_routine, 'save2', /either
file = 'time-3minpower_maps'
save2, file

end
