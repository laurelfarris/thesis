goto, start

; 22 July 2018

restore, '../test_data.sav'

colors=['black', 'blue', 'red', 'green', 'purple', 'dark orange', 'dark cyan']
;common defaults

dz = 64
cols = 1
rows = 4
cadence = 24
N = 99
length = cadence * N / 60. ; length of ts, in minutes
cycles = length / 3

x = ( findgen(N)/N ) * ( 2*!PI * cycles )

y = A[0].flux
ysm = smooth( y, 8 )
;z_start = [ 80, 180, 280, 380, 480]


win = window2( buffer=0, lx=300 );, /delete_existing )
;foreach z, z_start, i do begin
    ;ind = [ z : z+99 ]
    ;flux = ysm[ind] + (1e5*sin(x))
    ;flux = A[0].flux[ind]
    ;flux = lc1[ind]
    flux = lc1
    ind = indgen(n_elements(lc1))
    p = plot2( ind, flux, /current, $;overplot=i<1, $
        layout=[cols,rows,1], $
        title='fake flare data' );, $
        ;title='raw flare data', $
        ;color=colors[i])
;endforeach
yrange = [1e8,1e14]

START:
z_start = [ 0: 749: dz ] + 40
;foreach z, z_start, i do begin
for i = 0, 5 do begin

    ind = [ z_start[i] : z_start[i+1] ]
    ;flux = ysm[ind] + (1e5*sin(x))
    ;flux = A[0].flux[ind]
    flux = lc1[ind]
    result = fourier2( flux, cadence )
    frequency = reform(result[0,*])
    power = reform(result[1,*])

    p = plot2( frequency, power, /current, overplot=i<1, $
        layout=[cols,rows,4], $
        ylog=1, $
        title='smoothed flare + 3-minute oscillation', $
        ;yrange=yrange, $
        sym_filled = 1, $
        symbol='circle', $
        sym_size = 0.5, $
        color=colors[i])
endfor

fc = 1./180
v = plot( [fc,fc], p.yrange, /overplot, linestyle=2 )

stop


; 36-minute time segment (random multiple of 3),
;   --> 12 full cycles of 3-minute oscillation.
cadence = 24
N = (36.*60)/cadence
;N = N*2

x = (findgen(N)/N) * (2*!PI) * 12

xdata = x * (3./(2*!PI))

line = findgen(N)/N

cols = 1
rows = 4

ydata3 = [ $
    [ sin(x) ], $
    [ sin(x) + (5.*line)^1.1 ], $
    [ sin(x) + (5.*line)^2.0 ], $
    [ sin(x) + (5.*line)^2.1 ] ]


ydata1 = [ $
    [ sin(x) ], $
    [ 2.0*sin(x) ], $
    [ 5.0*sin(x) ], $
    [ 10.0*sin(x) ]  ]

ydata2 = [ $
    [ sin(x) ], $
    [ sin(x) +  1.0*line ], $
    [ sin(x) +  5.0*line ], $
    [ sin(x) + 10.0*line ]  ]

ydata4 = [ $
    [ sin(x) ], $
    [  2.0*sin(x) +  1.0*line ], $
    [  5.0*sin(x) +  5.0*line ], $
    [ 10.0*sin(x) + 10.0*line ]  ]

ydata5 = [ $
    [ sin(x) ], $
    [ 10.0*sin(x) +  1.0*line ], $
    [  5.0*sin(x) +  5.0*line ], $
    [  2.0*sin(x) + 10.0*line ]  ]
    





;ydata = [ [[ydata1]], [[ydata2]], [[ydata3]] ]
ydata = [ [[ydata1]], [[ydata2]], [[ydata4]], [[ydata5]] ]

;s = CALC_FT( sin(x)+(slope*line), cadence, fmin=0.001, fmax=0.009 )
;print, s.frequency[9]
;print, s.power[9]

win = window2( buffer=0, lx=300, /delete_existing )
for j = 0, (size(ydata, /dimensions))[2]-1 do begin
    for i = 0, (size(ydata, /dimensions))[1]-1 do begin

        p = plot2( $
            xdata, $
            ydata[*,i,j], $
            /current, $
            overplot = i<1, $
            color = colors[i], $
            layout = [cols,rows,j+1], $
            xtitle = 'time (minutes)' , $
            ytitle = 'intensity' )
    endfor
endfor

resolve_routine, 'plot_power_spectrum', /is_function
win = window2( buffer=0, lx=1100 )
for j = 0, (size(ydata, /dimensions))[2]-1 do begin
    p = objarr(4)
    k = 0
    for i = 0, (size(ydata, /dimensions))[1]-1 do begin
        p[k] = PLOT_POWER_SPECTRUM( $
            ydata[*,i,j], $
            cadence, $
            fmin = 0.002, $
            fmax = 0.009, $
            norm=0, $
            /current, $
            overplot = i<1, $
            layout=[cols,rows,j+1], $
            xrange = [1.0, 9.0], $
            color = colors[i] )
        k = k + 1
    endfor
    leg = legend2( position=[0.95,0.9], target=[p], /relative )
endfor



stop




; 20 July 2018

x = findgen(3600)
cadence = 30

y1 = sin(x*(2*!PI/2))
y2 = sin(x*(2*!PI/5))
y3 = sin(x*(2*!PI/3))
ydata = [ [y1], [y2], [y3] ]
yz = size(ydata, /dimensions)

cols = 1
rows = 3

for  i = 0, yz[1]-1 do begin
    p = plot2( x, ydata[*,i], /current, overplot=i<1, $
        layout=[cols,rows,1], $
        color=colors[i] )
endfor


y = total( ydata, 2)

p = plot2( x, y, /current, $
    layout=[cols,rows,2] )

p = PLOT_POWER_SPECTRUM( $
    y, cadence, $
    ;xrange = [0, 400], $
    layout=[cols,rows,3] )

save2, 'mytest.pdf'
stop

restore, '../test_data.sav'
N = n_elements(lc1)
cadence = time[1] - time[0]

resolve_routine, 'plot_power_spectrum', /is_function

yrange=[0,200]
ind = [296:349]
p = PLOT_POWER_SPECTRUM( lc1[ind], cadence, layout=[1,2,1], $
    yrange=yrange, $
    ;ylog=1, $
    ytitle='log power' )

ind = [270:375]
p = PLOT_POWER_SPECTRUM( lc1[ind], cadence, layout=[1,2,2], $
    yrange=yrange, $
    ytitle='log power' )

file = 'test_data_mine.pdf'
save2, file
stop


;; Power vs. time

dz = 64

;; Initialize power array
power = fltarr(N-dz)
power_norm = fltarr(N-dz)
var = fltarr(N-dz)

fmin = 0.005
fmax = 0.006
;fmin = 0.0078
;fmax = 0.0088


;;--------- Calculate FT of fake data ---------------------------
fmin = 1./400 ; 2.5 mHz
fmax = 1./50 ;  20 mHz
struc = CALC_FT( lc1, cadence, fmin=fmin, fmax=fmax )
help, struc
ax = p.axes
ax[2].showtext = 1
ax[2].title = 'period (s)'
period = 1./(ax[0].tickvalues)
ax[2].tickname = strtrim( fix(period), 1 )
p = plot2(  $
    struc.frequency, $
    struc.power, $
    /current, $
    xtitle = 'frequency (Hz)', $
    ytitle='Power', $
    _EXTRA=e )

;; Plot power spectrum

;p = plot2( time, lc1, layout=[1,1,1], color='red', current=1 )
;p = plot2( time, lc1, layout=[1,1,1], color='red', buffer=1 )



end
