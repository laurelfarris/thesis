



; Test all kinds of FT scenerios
;   dz
;   constant vs. changing signal
;   damping
;   normalizing

; Real data:
;   quiet vs. flaring region (subregion)
;   central frequency/period
;   bandpass


; 22 August 2018
; Test to see how variability in 3-minute power with time, P(t),
;   changes for different time segment lengths (dz)


; (dz*cadence)/180 = # cycles in dz = 8.53 for dz=64
; 1 full 3-min cycle --> dz = 7.5
; 2 cycles --> dz = 15.

j = 1
time = strmid(A[j].time,0,5)
dz_values = [0:15:3] + 60
cadence = 24

;f_center = 1./300
f_center = 1./180
bandwidth = 0.001
fmin = f_center - (bandwidth/2)
fmax = f_center + (bandwidth/2)
;fmin = 0.005
;fmax = 0.006

colors = [ $
    ; 'black', $
    'blue', 'red', 'green', $
    'deep sky blue', 'dark orange', 'dark cyan', $
    'purple', 'saddle brown', 'deep pink' ]


p = objarr(n_elements(dz_values))
N = n_elements(A[j].flux)

wx = 8.5
wy = 11.0

dw
;window_title = $
;    '3-minute power vs. time from integrated AR emission for various time segment lengths'
;win = WINDOW2( title=window_title, buffer=1, font_style='bold')
win = WINDOW2( buffer=1, font_style='bold')

height = 5.0

x1 = 1.0
x2 = wx - 1.0
y2 = wy - 1.5
y1 = y2 - height
position = [x1,y1,x2,y2]

foreach dz, dz_values, i do begin

    z_start = indgen(N-dz)
    power = fltarr(N-dz)

    foreach z, z_start, k do begin
        struc = CALC_FT( A[j].flux[z:z+dz-1], cadence, fmin=fmin, fmax=fmax )
        power[k] = struc.mean_power
    endforeach

    n_minutes = strtrim((dz*cadence)/60., 1)
    name = $
        'dz = ' + strtrim(dz,1) + $
          ' = ' + strmid( n_minutes, 0, 4) + ' minutes'

    ydata = NORMALIZE(power) + i
    xdata = [ 0 : n_elements(ydata)-1] $
        + round(dz/2.)

    ;xrange = [ 0, N-1 ]
    ;xrange = [225, 375]
    ;xmajor = 7

    xrange = [225, 350]
    xmajor = 6

    p[i] = plot2( $
        xdata, $
        ydata, $
        /current, $
        /device, $
        position = position*dpi, $
        overplot = i<1, $
        xmajor = xmajor, $
        ymajor = 0, $
        xrange = xrange, $
        xshowtext = 1, $
        ytitle = '3-minute power (normalized)', $
        symbol = '.', $
        sym_size = 4.0, $
        thick = 0.0, $
        color = colors[i], $
        name = name )
endforeach

ydata = NORMALIZE(A[j].flux) + i
xdata = [ 0 : N-1 ]

lc = plot2( $
    xdata, $
    ydata, $
    overplot=1, $
    xrange=xrange, $
    stairstep = 1, $
    thick = 0.0, $
    name = 'intensity (normalized)' )

ax = p[0].axes
ax[0].tickname = time[ ax[0].tickvalues ]
ax[0].title = 'Start time (UT) on 15-Feb-2011 00:00'
ax[2].title = 'Index (aka frame number)'
ax[2].showtext = 1

lx = position[0]
ly = position[1] - 0.5
leg = legend2( $
    target=[p,lc], $
    /device, $
    sample_width=0.10, $
    horizontal_alignment = 'Left', $
    vertical_alignment = 'Top', $ ; default?
    position = [lx,ly]*dpi )

save2, 'fourier_test.pdf', /add_timestamp

end
