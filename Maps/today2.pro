;+
;- LAST MODIFIED:
;-
;- To do:
;- 


goto, start
start:;---------------------------------------------------------------------------------


;- Compare Interesting BP at lower boundary of AR_1p to pixel to the upper left,
;-   just outside of B_LOS boundary (by eye, looked to be relatively high intensity
;-   as well, but did not have strong 3min enhancement.
x1 = 382
y1 = 192
x2 = 338
y2 = 236
f1 = reform(A[0].data[x1,y1,0:260])
f2 = reform(A[0].data[x2,y2,0:260])
ff = [ [f1], [f2] ]


;- Compare dark pixel near center of umbra to brighter pixel above center,
;-  close to B_LOS boundary ("dark" and "light" in 3min power map, not intensity).
x1 = 370
y1 = 216
x2 = 370
y2 = 228
f1 = reform(A[0].data[x1,y1,0:260])
f2 = reform(A[0].data[x2,y2,0:260])
ff = [ [f1], [f2] ]


fmin = 0.003
fmax = 0.020

nu = []
pow = []
for ii = 0, 1 do begin
    result = fourier2( ff[*,ii], 24 )
    frequency = reform(result[0,*])
    power = reform(result[1,*])
    ind = where(frequency ge fmin and frequency le fmax)

    nu = [ [nu], [frequency[ind]] ]
    pow = [ [pow], [power[ind]] ]
endfor


;+
;- Plots!
;-


plt = objarr(2)

props = { $
    margin : [0.05, 0.1, 0.03, 0.2], $
    ;thick: 0.1 $ ; default thick = 0.5
    ylog : 1, $
    sym_size : 0.5, $
    symbol:'circle' $
}

resolve_routine, 'win_quick', /either
win = WIN_QUICK()

name = ['umbra', 'penumbra']

color=['blue', 'black']
for ii = 0, 1 do begin
    plt[ii] = plot2( $
        ff[*,ii], $
        /current, $
        color=color[ii], $
        name=name[ii], $
        ;xrange=[100,260], $
        title='pre-flare lightcurves', $
        overplot=ii<1, $
        _Extra = props)
endfor
leg = legend( target = plt )


win = WIN_QUICK()
color=['red', 'black']
for ii = 0, 1 do begin
    plt[ii] = plot2( $
        nu[*,ii], pow[*,ii], $
        /current, $
        color=color[ii], $
        name=name[ii], $
        ;xrange=[0.002, 0.0083], $
        ;yrange=[0.0, 900.], $
        title = 'pre-flare power spectrum', $
        overplot=ii<1, $
        _Extra = props)
endfor

leg = legend( target = plt )




end
