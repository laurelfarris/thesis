;+
;- LAST MODIFIED:
;-   29 April 2019
;-
;-


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
time = strmid(A[cc].time, 0, 5)
ti = (where( time eq '01:30' ))[0]
tf = (where( time eq '02:30' ))[0]

dw

;- Calling sequence, with default values commented
resolve_routine, 'axis2', /is_function
resolve_routine, 'sdbwave2', /either

SDBWAVE2, $
    ;curve, $  ; 1-D time series (e.g. light curve)
    ;A[cc].flux[ti:tf], $
    detrended[*,cc], $
    ;short=, long=, ; = min/max period by default
    short = 50, $
    long = 2000, $
    ylog=1, $
    ;xtickname = time[ti:tf], $
    color=20, $  ; rgb_table --> 1
    /fast, $ ; don't know what this does, but skips call to randomwave...
    /cone, $
    delt=A[cc].cadence ;(1*10.), $
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
