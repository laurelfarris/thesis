;+
;- 21 February 2020
;-
;- To do:
;-   1.
;-   2.
;-
;-

;+
;- User input
;-

;- center and z_ind from zoomed-in figures of power maps
;-  (3 total : far left, center, far right.  Far right is where
;-    "interesting feature" is seen.)


offset = [0,0]
;offset = [-10,10] ;- offset from center
;
center = [382,192] + offset ;- AR_1p


;center = [280,180] ;- AR_2p
z_ind = 201
dz = 64
;rr = 50  ;- dimensions of box around ROI



;+
;- general code (no user input required)
;-

x0 = center[0]
y0 = center[1]


;rr = 100
;imdata = A[cc].data[ $
;imdata = A[cc].map[ $
;    x0-(rr/2):x0+(rr/2)-1, $
;    y0-(rr/2):y0+(rr/2)-1, $
;    z_ind]
;help, imdata

dw
rr = 10
for cc = 0, 1 do begin
    imdata = A[cc].map[*,*,z_ind]
    im = image2( $
        alog10(imdata), $
        margin=0.1, $
        title = $
            A[cc].name + ' 3-minute power (' $
            + time[z_ind] + ' - ' + time[z_ind+dz-1] + ')' ,$
        rgb_table=AIA_COLORS( wave=fix(A[cc].channel) ) $
    )
    pol = polygon2( $
        target=im, $
        center=[x0, y0], $
        dimensions=[rr,rr], $
        color='black' $
    )
    time = strmid(A[cc].time,0,8)
    save2, 'roi_' + A[cc].channel
endfor

stop

;-
;------------------------------------------------------
;- ROI to average over

x1 = x0-(rr/2)
x2 = x0+(rr/2)-1
y1 = y0-(rr/2)
y2 = y0+(rr/2)-1

roi_flux = fltarr(749, 2)
;foreach rr, [10,50,100], ii do begin
for cc = 0, 1 do begin
    ;
    ;roi = A[cc].data[ $
    roi = A[cc].data[x1:x2, y1:y2, *] / A[cc].exptime
    ;
    ;- average over ROI xy dimensions to get 1D flux array
    roi_flux[*,cc] = mean( mean( roi, dimension=1 ), dimension=1 )
    ;
    ;plt = plot2( roi_flux[*,0], location=[500.*(ii+1),0], $
    ;     title='rr = ' + strtrim(rr,1)  )
    ;
;endforeach
endfor


;- Create smoothed LC
;-   Running average
;-   FFT filter

;- .run plot_lc --> works! Check hardcoded values tho
;-    (ydata, filename, others that don't matter if x-axis doesn't change)


dt = 400
dz_avg = dt/( (fix(A.cadence))[0]  )
print, dz_avg

lc_avg = fltarr( (749-dz_avg), 2)
sz = size(lc_avg, /dimensions)
help, lc_avg
print, sz


for cc = 0, 1 do begin
    ;
    for ii = 0, sz[0]-1 do begin
        ;
        lc_avg[ii,cc] = mean(roi_flux[ii:ii+dz_avg-1, cc])
        ;
    endfor
;
endfor
print, max(lc_avg[*,0])
print, max(lc_avg[*,1])

;xdata = [ [indgen(sz[0])], [indgen(sz[0])] ] + (dz_avg/2)

;help, xdata
;print, xdata[ 0,0]
;print, xdata[-1,0]

;ydata = ( roi_flux[ dz_avg/2 : (749-1)-(dz_avg/2), * ] )
;filename = 'lc_ROI'
;ydata = lc_avg
;filename = 'lc_ROI_avg'
ydata = ( roi_flux[ dz_avg/2 : (749-1)-(dz_avg/2), * ] ) / lc_avg
filename = 'lc_ROI_flattened'
;

;IDL> .run plot_lc

;----------------------

;
resolve_routine, 'calc_ft', /is_function
resolve_routine, 'plot_spectra', /is_function
;
for cc = 0, 0 do begin
    ft = CALC_FT( ydata[0:100,cc], 24, /norm )
    plt = PLOT_SPECTRA( $
        ft.frequency, ft.power, $
        overplot=cc<1, $
        xrange=[0.0025,0.010], $
        ;xrange=[0.0,0.01], $
        color=A[cc].color, $
        buffer=0, $
        name=A[cc].name, $
        stairstep=1, $
        leg=leg )
endfor

end
