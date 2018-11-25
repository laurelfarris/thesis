

;- 21 November 2018

goto, start

start:;---------------------------------------------------------------------------------
z_start = [ $
    16, 58, 196, $
    216, 248, 280, $
    314, 386, 450, $
    525, 600, 658 ]

center = [ $
    [ 80, 120], $
    [115, 090], $
    [115, 115], $
    [160, 155], $
    [230, 145], $
    [230, 190], $
    [255, 155], $
    [280, 180], $
    [367, 213], $
    [382, 193] ]

color = [ $
    'blue', $
    'red', $
	'lime green', $
    'deep sky blue', $
	'dark orange', $
	'dark cyan', $
	'dark orchid', $
	'sienna', $
	'dim gray', $
    'hot pink', $
    '' ]
stop


dw

z_start = 450
zz = z_start
dz = 64

for cc = 0, 1 do begin
    time = strmid(A[cc].time,0,5)
    ;time = A[cc].time

    ;- Intensity
    ;imdata = mean(A[cc].data[*,*,[z_start:z_start+dz-1]], dim=3)
    ;title = A[cc].name + ' (' + A[cc].time[zz] + '-' + A[cc].time[zz+dz-1] + ' UT)'
    ;file = 'aia' + A[cc].channel + 'big_image'
    ;imdata = aia_intscale( data, wave=1600, exptime=1.0 ) ;exptime=A[cc].exptime )

    ;- Maps
    imdata = A[cc].map[*,*,z_start]
    title = A[cc].name + ' 5.6 mHz (' + time[zz] + '-' + time[zz+dz-1] + ' UT)'
    file = 'aia' + A[cc].channel + 'big_map'

    imdata = alog10(imdata)
    resolve_routine, 'image3', /either
    im = image3( $
        imdata, $
        rgb_table=A[cc].ct, $
        xshowtext=0, yshowtext=0, $
        rows = 1, $
        cols = 1, $
        wx = 4.0, $
        buffer = 1, $
        left = 0.10, right = 0.10, bottom = 0.10, top = 0.50, $
        ;left = 0.25, right = 0.25, bottom = 0.25, top = 0.50, $
        title = title )
     
    ;- HMI contours
    resolve_routine, 'contours', /either
    CONTOURS, mag_contour, time=time[zz+(dz/2)], target=im, channel='mag'

    ;foreach zz, z_start, ii do begin
        ;im[ii].title = A[cc].name + $
        ;    ' 5.6 mHz ' + $
        ;    ' (' + time[zz] + '-' + time[zz+dz-1] + ' UT)'
        ;CONTOURS, mag_contour, time=time[zz+(dz/2)], target=im[ii], channel='mag'
        ;CONTOURS, cont_contour, time=time[zz+(dz/2)], target=im[ii], channel='cont'
    ;endforeach

    ;leg = legend2( target=[mag_contour, cont_contour] )
    save2, file

endfor

stop


;- Polygon around enhanced regions
r = 20
nn = (size(center,/dimensions))[1]

resolve_routine, 'polygon2', /either
pol = objarr(nn)
for ii = 0, nn-1 do begin
    pol[ii] = polygon2( $
        target=im, center=center[*,ii], dimensions=[r,r],  $
        color=color[ii], $
        ;name='AR_' + strtrim(ii+1,1), $
        thick=1.0 )
    txt = text( $
        center[0,ii], center[1,ii] + r/2 + 1, $
        strtrim(ii+1,1), $
        /data, target=im, font_size=fontsize )
endfor

file = 'aia' + A[cc].channel + 'maps_contours_subregions'
save2, file
stop


dw

;- LC of bright point in right ss
zz = [0:259]
zz = [0:748]
nn = (size(center,/dimensions))[1]
win = window(dimensions=[8.0, 8.0]*dpi, location=[500,0], buffer=0)
;name = [ 'AR_1', 'AR_2', 'AR_3', 'AR_4' ]
;resolve_routine, 'get_position', /either
;rows = 1
;cols = 1
;pos = get_position( layout=[cols,rows,1], width=6.5, height=2.5 )

center=[ [382,192], [382,193], [382,194], [381,193], [383,193] ]

plt = objarr(5)
for ii = 0, nn-1 do begin
    flux = reform(A[0].data[center[0,ii],center[1,ii],zz])
    plt[ii] = plot2( $
        zz, $
        flux, $
        ;(flux-min(flux)), $
        ;((flux-min(flux))/(max(flux)-min(flux))), $ ; + ii*0.5, $
        /current, $
        /device, $
        layout = [1,1,1], $
        margin=0.50*dpi, $
        ;position = pos*dpi, $
        overplot = ii<1, $
        ylog = 1, $
        xtitle = 'time', $
        ytitle = 'intensity', $
        name = 'AR_' + strtrim(ii+1,1), $
        color=color[ii])
endfor
if plt[0].ylog eq 1 then plt[0].ytitle = 'log intensity'

save2, 'lc_bp'
stop

dw
zz = [196:196+dz-1]
;fmin = 0.002
;fmax = 0.02
fmin = 0.0035
fmax = 0.010
plt = objarr(nn)
;pos = get_position( layout=[cols,rows,2], width=6.5, height=2.5 )
win = window(dimensions=[8.0, 8.0]*dpi, location=[500,0], buffer=0)
for ii = 0, nn-1 do begin
    flux = reform(A[0].data[center[0,ii],center[1,ii],zz])
    @batch_ft
    @plot_spectra
endfor
ax[2].showtext = 1
ax[2].title = 'period (seconds)'
stop

save2, 'lc_bp'

end
