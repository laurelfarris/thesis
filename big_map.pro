

;- 21 November 2018

goto, start

z_start = [ $
    16, 58, 196, $
    216, 248, 280, $
    314, 386, 450, $
    525, 600, 658 ]
channel = 'mag'
dz = 64

cc = 0
time = strmid(A[cc].time,0,5)

;data = mean(A[cc].data[*,*,[z_start:z_start+dz-1]], dim=3)
;imdata = aia_intscale( data, wave=1600, exptime=1.0 ) ;exptime=A[cc].exptime )
;file = 'big_image'
imdata = alog10(A[cc].map[*,*,z_start])
file = 'big_map'

rows=1
cols=1
dw
win = window(dimensions=[8.0, 8.0]*dpi, /buffer)
im = image3( imdata, $
    rgb_table=A[cc].ct, $
    xshowtext=0, yshowtext=0, $
    rows=rows, cols=cols, $
    xgap = 0.15, ygap=0.25, $
    left = 0.50, top = 0.50 )

;- HMI contours
resolve_routine, 'contours', /either
foreach zz, z_start, ii do begin
    im[ii].title = A[cc].name + ' (' + time[zz] + '-' + time[zz+dz-1] + ' UT)'
    CONTOURS, time=time[zz+(dz/2)], target=im[ii], channel=channel
endforeach

;- Polygon around enhanced regions
center = [ $
    [115, 115], $
    [230, 190], $
    [280, 180], $
    [367, 213]]
;    [ 80, 120], $
;    [160, 155], $
;    [230, 145], $
;    [255, 155], $
;    [115, 090], $
;    [382, 193] ]
r = 20
nn = (size(center,/dimensions))[1]

resolve_routine, 'polygon2', /either
color = [ 'blue', 'red', 'lime green', 'dark cyan', 'dark orange', 'dark orchid', 'white']
pol = objarr(nn)
for ii = 0, nn-1 do begin
    pol[ii] = polygon2( $
        target=im, center=center[*,ii], dimensions=[r,r],  $
        color=color[ii], $
        thick=1.0 )
    txt = text( $
        center[0,ii], center[1,ii] + r/2 + 1, $
        strtrim(ii+1,1), $
        /data, target=im, font_size=fontsize )
endfor

;save2, 'aia' + A[cc].channel + 'maps_contours'
save2, file
stop

start:;---------------------------------------------------------------------------------

;- LC of bright point in right ss

color = [ 'blue', 'red', 'lime green', 'dark cyan', 'dark orange', 'dark orchid', 'white']
zz = [0:748]

rows = 2
cols = 1

;flux_array = A[0].flux[zz]
flux_array = []
nn = (size(center,/dimensions))[1]
for ii = 0, nn-1 do $
    flux_array = [ [flux_array], [ reform(A[0].data[center[0,ii],center[1,ii],zz]) ] ]
;nn = nn + 1

dw
win = window(dimensions=[8.0, 8.0]*dpi, /buffer)
name = [ 'AR_1', 'AR_2', 'AR_3', 'AR_4' ]
resolve_routine, 'get_position', /either
pos = get_position( layout=[cols,rows,1], width=6.5, height=2.5 )


plt = objarr(nn)
for ii = 0, nn-1 do begin
    yy = flux_array[*,ii]
    plt[ii] = plot2( $
        zz, yy, $; (yy-min(yy))/(max(yy)-min(yy)), $
        /current, $
        /device, $
        position = pos*dpi, $
        overplot = ii<1, $
        ylog = 1, $
        xtitle = 'time', $
        ytitle = 'intensity', $
        name = name[ii], $
        color=color[ii])
endfor
leg = legend2( target=plt )

pos = get_position( layout=[cols,rows,2], width=6.5, height=2.5 )
;fmin = 0.002
;fmax = 0.02
fmin = 0.0035
fmax = 0.010
for ii = 0, nn-1 do begin
    flux = flux_array[*,ii]    
    @batch_ft
    @plot_spectra
endfor

period = [120, 180, 200]
for ii = 0, 2 do begin
    xx = 1./period[ii]
    v = plot2( [xx,xx], plt[0].yrange, /overplot, ystyle=1, linestyle=ii+1 )
endfor


ax[2].showtext = 1
save2, 'lc_bp'

end
