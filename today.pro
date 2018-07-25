; 25 July 2018

; Standard deviation of each channel:

; What exactly is the period at returned frequencies??

; 24 July 2018

goto, start

; To Do:   Overplot a grid!
win.erase

print, min(A[0].flux)/1e7
print, max(A[0].flux)/1e7

print, min(A[1].flux)/1e7
print, max(A[1].flux)/1e7


dw

wx = 11.0
wy = 8.5
win = window( dimensions=[wx,wy]*dpi, location=[300,0] )

START:;---------------------------------------------------------------------------------
win.erase

margin=[1.0, 3.0, 1.0, 3.0]

aa = [ min(A[0].flux), min(A[1].flux) ]
bb = [ 1., 1. ]
for i = 0, 1 do begin
    flux = A[i].flux - aa[i]
    p = plot2(  $
        [0:748], flux, $
        /current, $
        /device, $
        xtickinterval=75, $
        ymajor=7, $
        xticklen=0.02, $
        yticklen=0.05, $
        color=A[i].color, $
        xtitle='index', $
        overplot=i<1, $
        margin=margin*dpi, $
        stairstep=1 )
endfor

width = (p.position)[2] - (p.position)[0]
height = (p.position)[3] - (p.position)[1]

time = strmid(A[0].time,0,5)
ax = p.axes

ax[2].tickname = time[ax[0].tickvalues]
ax[2].title = 'index.date_obs'
ax[2].showtext = 1

ax[1].coord_transform = [aa[0],bb[0]]
ax[1].title='1600$\AA$ (DN s$^{-1}$)'


ax[3].coord_transform = [aa[1],bb[1]]
ax[3].title='1700$\AA$ (DN s$^{-1}$)'
ax[3].showtext = 1




stop



dz = 64
N = 749

pow = indgen(N-dz+1) + 1
arr = intarr(N,N)

for i = 0, n_elements(pow)-1 do $
    arr[ i : i+dz-1, i] = replicate( pow[i], dz, 1 )

i = 680
;print, strtrim(arr[i:i+9,i:i+9],2)
;print, arr[i:i+9,i:i+9];, format='(I4)'

arr = arr[ $
    (dz-1) : (N-dz-1), $
         0 : (N-dz+1)     ]


stop

; 23 July 2018
;; HMI contours, etc. (see hmi.pro, or whatever I may end up
;;  renaming it to...)

;; subregions - LC and FT in same window
test = indgen(500) + 2150
print, test[0]
print, test[-1]


; Tired of errors when taking power of negative or zero values.
map = map > 0.1
map = map < 10000.0

aia_lct, wave=1600, /load

im = image2(map[*,*,153], layout=[1,1,1], rgb_table=ct )

ct = aia_colors(wave=1600)
xc = 382
yc = 192
r = 50

temp = map[ xc-r : xc+r-1, yc-r : yc+r-1, * ]
xstepper, temp^0.5

im = image2(temp[*,*,425], layout=[1,1,1], rgb_table=ct )

; restored map with no adjustments to min/max to data itself,
; just what's actually being imaged.
im = image2( (map[*,*,425])^0.1, layout=[1,1,1], rgb_table=ct )



xc = 382
yc = 192
r = 25
im = image( map[ xc-r : xc+r-1, yc-r : yc+r-1, 425 ], layout=[1,1,1], rgb_table=ct)

subset = A[0].data[ xc-r : xc+r-1, yc-r : yc+r-1, * ]
flux = total( total( subset, 1), 1 )

xdata = indgen(n_elements(flux))
xtickname = strmid( A[0].time, 0, 5 )

ydata = flux / A[0].exptime


cols = 1
rows = 3



;win = getwindows('Subset FT')
if win eq !NULL then begin
    print, 'creating new window'
    win = window( dimensions=[8.5,11.0]*dpi, location=[600,0], $
        name='Subset FT')
endif else win.erase


win = window( dimensions=[8.5,11.0]*dpi, location=[600,0] )

win = getwindows(/current)
win.erase

p = plot2( xdata, ydata, /current, /device, $
    layout=[cols,rows,1], margin=1.0*dpi, $
    xshowtext=1, $
    xtitle = 'index', ytitle = 'counts (DN s$^{-1}$)' )
ax = p.axes
ax[0].tickname = xtickname[ ax[0].tickvalues ]
ax[0].title = 'time (UT)'

struc = CALC_FT( ydata, 24 );, fmin=0.005, fmax=0.006 )

resolve_routine, 'plot_power_spectrum', /either
p = PLOT_POWER_SPECTRUM( $
    struc.frequency, struc.power, $
    fmin=0.000, $
    fmax=0.009, $
    /current, $
    /device, $
    layout=[cols,rows,2], margin=1.0*dpi )

stop




; 16 July 2018

;dat = fltarr(sz[0],sz[1],6)
;dat[*,*,0] = map[*,*,150]
N = 8
dat = fltarr( sz[0], sz[1], N )
temp = map[*,*,162]
max_value = 600

aia_lct, r, g, b, wave=fix(channel)
dat[*,*,0] = temp
dat[*,*,1] = temp^0.1
dat[*,*,2] = temp^0.5
dat[*,*,3] = temp<max_value
dat[*,*,4] = alog10(temp)
dat[*,*,5] = aia_intscale( temp, wave=fix(channel), exptime=A[ii].exptime )
dat[*,*,6] = aia_intscale( temp, wave=fix(channel), exptime=0.5*A[ii].exptime )
dat[*,*,7] = aia_intscale( temp, wave=fix(channel), exptime=2.0*A[ii].exptime )
dat_title = [ $
    'power', $
    'power^0.1', $
	'power^0.5 (sqrt)', $
	'99% pixels LE <value>', $
	'log power', $
	'aia_intscale (exptime)', $
	'aia_intscale (0.5*exptime)', $
	'aia_intscale (2.0*exptime)' $
    ]



; 13 July 2018

; Does graphic really need to have actual data?
; When overplotting data that lies outside of current axis range,
; does plot expand to include all of the new plot?
x = indgen(10)
y = x^2
graphic = plot2( x, y, /nodata, /buffer )
x = indgen(20)
y = x^2
p = plot2( x, y, /overplot )
save2, 'test_overplot.pdf'

stop



; 12 July 2018


restore, '../aia1600map.sav'
sz = size(map, /dimensions)
n_zeros = intarr(sz[2])
stop
for i = 0, sz[2]-1 do begin
    n_zeros[i] = n_elements( where( map[*,*,i] eq 0.0 ) )
endfor
; nevermind... power is 0.0 in some map pixels where data did not saturate


power = get_power(A[0].flux, cadence=24, channel='1600', data=A[0].data)
print, max(power)
stop
power = get_power_from_maps( A[0].data, '1600', threshold=10000, dz=64 )


stop

; 07 July 2018

; test plot, then hide, then v-lines, then show again.


x = indgen(10)
y = x^2


w = window( /buffer )
p = plot2( x, y, /current, /nodata )
;p.hide = 1

v = plot2( [5,5], p.yrange, /overplot, ystyle=1, thick=3 )
p = plot2( x, y, /overplot, ystyle=1, color='red', thick=3)

;p.hide = 0

save2, 'test.pdf'

; Works if first create graphic with /nodata,
;   then plot in order from background to foreground.


end
