
; LAST MODIFIED:
;   28 November 2018
;
; PURPOSE:
;   Calculate power as function of time, P(t), by summing over power maps.
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
    dz, $
    exptime=exptime, $
    threshold=threshold


    ;-  Calculate saturation mask

    if not keyword_set(threshold) then threshold = 15000./exptime

    ;resolve_routine, 'mask', /either
    ;data_mask = MASK( data, threshold=threshold )
    ;- NOTE: default value of threshold will be returned to this
    ;-  level from MASK routine.

    ;- Don't need a separate routine - can create mask with one line:
    data_mask = data lt threshold

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


;- In case maps weren't restored in prep.pro:
restore, '../aia1600map_2.sav'
A[0].map = map
restore, '../aia1700map_2.sav'
A[1].map = map
stop

;- Compute MAP mask and multiply by AIA power maps.
map_mask = fltarr(500,330,686,n_elements(A))
for cc = 0, n_elements(A)-1 do begin
    ;- This can take a while to run... 
    map_mask[*,*,*,cc] = GET_POWER_FROM_MAPS( $
        A[cc].data, $
        dz, $
        threshold = 10000., $
        exptime=A[cc].exptime )
endfor
stop
;- Move "start:" line down here unless mask needs to be re-calculated.


dz = 64
test = powermap_mask(A[1].data, dz, exptime=A[1].exptime)
print, total(total( test[*,*,280], 1 ), 1)
stop




map_mask = fltarr(500,330,686,n_elements(A)) ; --> returns FLOAT [500,330,686,2]
;map_mask = A.[1].map * powermap_mask(A[1].data, dz, exptime=A[1].exptime)
for cc = 0, 1 do $
    map_mask[*,*,*,cc] = POWERMAP_MASK( $
        A[cc].data, dz, exptime=A[cc].exptime )


;- Multiply maps by mask to set saturated pixels = 0.
map = A.map * map_mask
;im = image2( alog10(map[*,*,260,0]), margin=0.1, rgb_table=A[0].ct )

;- Create 1D array of P(t) by summing over each map.
power = total(total(map,1),1)

;----Covert to power per pixel by dividing by # unsaturated pixels.----;

;- Create 1D array of unsaturated pixels.
n_pix = float(total(total(map_mask,1),1))

;- Divide power array by # (unsaturated) pixels
power = power / n_pix
;power[*,0] = power[*,0]/n_pix[*,0]
;power[*,1] = power[*,1]/n_pix[*,1]

start:;----------------------------------------------------------------------------------------
st = stats( power[*,0], /display )
st = stats( power[*,1], /display )
stop


;power[*,0] = (power_per_pixel[*,0]) * (A[0].exptime)^2
;power[*,1] = (power_per_pixel[*,1]) * (A[1].exptime)^2
;- 02 December 2018
;-  Multiplying by exposure time... why did I do this?
;-  Comparing to old figures?
;-  Original plots of P(t) were generated from power maps
;-  calculated from flux that was NOT exptime-corrected...
;- --> Before multiplying by exptime, the power for AIA 1600 was
;      squished so flat compared to AIA 1700, could barely see
;      the pattern it followed.
; Put "correction" back, and squared exptime --> multiplying flux
;   by some factor C results in power * C^2
;   (overlooked that when I wrote this, apparently).
; This generated P(t) plot that looks exactly like the old one
;   (the one that was in paper, and has been on all recent
;   posters and presentations).

stop


;- Copied this code to "plot_Pt.pro" because it's almost identical
;-  to the code used to plot power from flux.
;- Run that one instead.

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
    ;color=A.color, $
    color=['green', 'purple'], $
    name=A.name, $
    buffer=0 )


ax = plt[0].axes
;ax[1].tickvalues=[-100:500:100]
ax = plt[1].axes
;ax[3].tickvalues=[1200:1900:100]
ax[1].title = A[0].name + ' 3-minute power'
ax[3].title = A[1].name + ' 3-minute power'
;- May need to move these to last line, before saving,
;- if intermediate steps cause ax[3] to disappear again.

resolve_routine, 'shift_ydata', /either
SHIFT_YDATA, plt, delt=[ mean(power[*,0]), mean(power[*,1]) ]

;resolve_routine, 'normalize_ydata', /either
;NORMALIZE_YDATA, plt

resolve_routine, 'label_time', /either
LABEL_TIME, plt, time=A.time;, jd=A.jd

resolve_routine, 'oplot_flare_lines', /either
OPLOT_FLARE_LINES, plt, t_obs=A[0].time;, jd=A.jd

resolve_routine, 'legend2', /either
leg = LEGEND2( target=plt, /upperleft )

resolve_routine, 'save2', /either
file = 'time-3minpower_maps'
;save2, file

end
