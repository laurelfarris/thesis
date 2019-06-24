;+
;- LAST MODIFIED:
;-   29 April 2019
;-
;- Subroutines:
;-   filter.pro
;-   sdbwave.pro
;- Used detrended signal from filter.pro as input to sdbwave to get WA figure
;-  with a long-period cutoff.
;- Found out that overplotting curves with vastly different values and/or
;-   range of values between min and max can more easily be done without
;-   setting /overplot, which assumes the same data space.
;-   One plot: kw axis_style=4 so there are no axes, but give same position
;-   as the plot to overlay. Then use AXIS to create set of axes with independent
;-   values that sits on the same panel.


goto, start

@restore_maps

;r = 600
;dimensions = [r, r]
;center=[1700,1650]

sz = size( A.map, /dimensions )

power = fltarr( sz[2], 2 )
for cc = 0, 1 do begin
    power[*,cc] = total( total( A[cc].map, 1), 1)
endfor

xdata = indgen(sz[2])

for ii = 0, 1 do begin

    ydata = power[*,ii]

    plt = plot2( $
        xdata, $
        ;ydata, $
        ;ydata - mean(ydata), $
        (ydata-min(ydata))/(max(ydata)-min(ydata)), $
        overplot=ii<1, $
        color=A[ii].color )

endfor

stop

;save2, 'newflare_pt'
;save2, 'newflare_1600maps'
;save2, 'newflare_1700maps'

dw
p1 = plot2( A[0].flux, color=A[0].color, axis_style=1 )
;p2 = plot2( A[1].flux, /overplot, color=A[1].color)
p2 = plot2( A[1].flux, /current, color=A[1].color, axis_style=4 )
ax3 = axis2( 'Y', location='right', target=p2 )

stop


;- NOTE: need to run filter.pro first ( IDL> .run filter )
;-   to get detrended signal. Variable "detrended" is input curve for sdbwave2.pro

start:;-------------------------------------------------------------------------------
cc = 0


resolve_routine, 'sdbwave', /either
SDBWAVE, detrended[*,cc], short = 50, long = 2000, $
    ;/fast, $
    /cone, ylog=1, delt=A[cc].cadence
;- Unclear what kw "fast" is for, but skips call to randomwave...

stop

time = strmid(A[cc].time, 0, 5)
ti = (where( time eq '01:30' ))[0]
tf = (where( time eq '02:30' ))[0]

dw

;- Calling sequence, with default values commented
resolve_routine, 'axis2', /is_function
resolve_routine, 'sdbwave2', /either

SDBWAVE2, $
    ;A[cc].flux[ti:tf], $
    detrended[*,cc], $
    short = 50, long = 2000, $ ; = min/max period by default
    ylog=1, $
    ;xtickname = time[ti:tf], $
    color=20, $  ; rgb_table --> 1
    /fast, $ ; don't know what this does, but skips call to randomwave...
    /cone, $
    delt=A[cc].cadence ;(1*10.), $
    title=A[cc].name + ' light curve on ' + date, $
    ;print=print, $
    ;pc=255, $
    ;nocon=nocon, $
    ;mother='morlet', $
    ;offset=0, $
    ;title='a) Time series'
    ;sigg=sigg

;- max value for low-pass filter
;- significance (=0.99)

save2, 'aia1600wavelet'
;save2, 'aia1700wavelet'

end
