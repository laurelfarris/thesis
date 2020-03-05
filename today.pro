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

dw
rr = 10
for cc = 0, 0 do begin
    time = strmid(A[cc].time,0,8)
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
    ;save2, 'roi_' + A[cc].channel
endfor



rr = 10


;+
;- 05 March 2020
;-   "offset" is the distance between ROI center and tip of arrow
;-   "side" is the length of the x and y vector components of the arrow
;-     (value determined based on desired length of arrow shaft,
;-      and good 'ol Pythagorean theorem. Yay, geometry!! )
;-

offset = 5
length = 20
side = sqrt( (length^2)/2 )
print, side
x2 = x0 + offset
y2 = y0 - offset
x1 = x2 + side
y1 = y2 - side
print, x1, y1
print, x2, y2
myarrow.delete

myarrow2 = arrow2( $
    [x1,x2]+10, [y1,y2], /data, $
    thick=3.0, $
    fill_background=1, $
    head_angle=30, $
    head_indent=0, $
    ;head_size=0, $
    color='purple' $
)


;- other values used while playing with IDL's ARROW function... is fun :)
;xx = [385, 395]
;yy = [172, 182]
;
;x1 = 10
;x2 = 50
;y1 = 20
;y2 = 80


    ;[ [x1,x2], [y1,y2] ], $
    ;[ [x0+rr, x0+(2*rr)], [y0+rr, y0+(2*rr)] ], $
    ;[ xx, yy], $

;myarrow.delete
myarrow2 = ARROW( $
    ;[x1,x2], [y1,y2], $
    [20, 10]+150, [20, 50]+20, $
    /data, $
    color='black', $
    thick=4.0, $
    line_thick=2.0, $
    fill_background=0 $
)
;myarrowtoo.delete
myarrowtoo2 = ARROW( $
    ;[x1,x2], [y1,y2], $
    [20, 10]+250, [20, 50]+20, $
    ;[ [x1,x2], [y1,y2] ], $
    ;[ [x0+rr, x0+(2*rr)], [y0+rr, y0+(2*rr)] ], $
    ;[ xx, yy], $
    /data, $
    color='gray', $
    thick=4.0, $
    line_thick=2.0, $
    fill_background=0 $
)

myarrow.thick=10.0


mypolygon1.delete
mypolygon2.delete

rr = 4
mypolygon1 = polygon2( center=[x1, y1], dimensions=[rr,rr], /data )
mypolygon2 = polygon2( center=[x2, y2], dimensions=[rr,rr], /data )










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



filename = 'map_with_arrow'


end
