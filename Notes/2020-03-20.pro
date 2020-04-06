;+
;- 13 March 2020
;-
;- Today's project:
;-   Restore maps from .sav files and multiply them by global mask,
;-   rather than 3D cube of map_masks where pixels only = 0 if saturated
;-   during that particular window -->   [t_i : t_i+T-1]
;-

;-
;- User-defined variables
dz = 64
buffer = 1
;threshold = 15000.
threshold = 10000.
;-

z_ind = 280

;+
;--- Global mask (see 2020-03-13.pro)
mask = product( A.data LT threshold, 3 )
;-

;+
;- 20 March 2020
;- What should threshold value be for bleeding?
;-    Less than 15000 obviously, but how much less?
;-
;imdata = A[cc].data[*,*,z_ind]
;-
im = objarr(2)
;-


;for ii = 75,84 do print, imdata[212:217,ii]

z_ind=[281,283]
dw
;sat = objarr(2)
resolve_routine, 'contour2', /is_function
resolve_routine, 'save2', /either
for cc = 0, 0 do begin
    ;imdata = AIA_INTSCALE( A[cc].data[*,*,z_ind], wave=A[cc].channel, exptime=A[cc].exptime )
    imdata = A[cc].data[*,*,z_ind[cc]]
    im[cc] = image2( $
        imdata, $
        ;imdata[210:220,75:90], $
        ;alog10(imdata), $
        ;A[cc].data[*,*,z_ind], $
        ;map[*,*,z_ind,cc], $
        margin=0.1, $
        rgb_table=AIA_COLORS(wave=A[cc].channel), $
        buffer=buffer $
        )
    ;-
    print, max(imdata)
    print, max(A[cc].data)
    sat0 = contour2( imdata, c_value=threshold, color='red', c_thick=0.5)
    sat1 = contour2( imdata, c_value=2000, color='yellow', c_thick=0.5 )
    ;-
    fname = 'sat_bld_contours_' + A[cc].channel
    SAVE2, fname, /overwrite
endfor
;-


;- Plot 1D array of pixel values through saturated pixels,
;-   overplot array of values farther down in Y, thru pixels with bleeding, not sat
;print, max(imdata[190:220,85])
;print, max(imdata[190:220,100])
;dw
;plt1 = plot2(imdata[190:220,85], buffer=buffer)
;plt2 = plot2(imdata[190:220,100], color='blue', /overplot)
;save2, 'sat_plots_1600_'


;imdata = [ [[map]], [[map[*,*,280,1]]] ]
;help, imdata
;cols = 1
;rows = 2
;IMAGE_POWERMAPS, imdata, cols, rows, buffer=buffer



;-
;- For Global mask:
map = A.map
for cc = 0, 1 do begin
    for ii = 0, 685 do begin
        map[*,*,ii,cc] = A[cc].map[*,*,ii] * mask[*,*,cc]
    endfor
endfor
;-
;-
;+
;- Sum over x and y in each power map to get 3min power as function of time: P(t)
power = total(total( map, 1),1)
;-


;- Sum over maps WITHOUT excluding contaminated pixels
;power = total(total( A.map, 1),1)


;-
;-
help, power
;-
format="(e0.2)"
print, min(power[*,0]), format=format
print, max(power[*,0]), format=format
print, min(power[*,1]), format=format
print, max(power[*,1]), format=format
;--



;+
;--- Plot 3-minute power as function of time -- P(t)
;-


;ind = [470:500]
resolve_routine, 'plot_pt', /is_function
dw
;power[*,0] = power[*,0] * ((A[0].exptime)^2)
;power[*,1] = power[*,1] * ((A[1].exptime)^2)
plt = PLOT_PT( $
    A[0].time, $
    power, $
    ;A[0].time[ind], $
    ;power[ind,*], $
    ;alog10(power), $
    dz, $
    buffer=buffer, $
    stairstep = 1, $
    ;yminor = 4, $
    ;yrange=[-250,480], $   ; maps
    title = '', $
    name = A.name )
;-
;ax = plt[0].axes
;ax[1].tickname = strtrim([68, 91, 114, 137, 160],1)
;ax[3].tickname = strtrim([1220, 1384, 1548, 1712, 1876],1)
ax2 = (plt[0].axes)[1]
ax2.title = plt[0].name + " 3-minute power"
ax2.text_color = plt[0].color
ax3 = plt[1].axes
ax3.title = plt[1].name + " 3-minute power"
;-
;-

;filename = 'pt_maskGlobal_' + class
filename = 'time-3minutepower_maps_' + class
resolve_routine, 'save2'
save2, filename, /timestamp, /overwrite

end
