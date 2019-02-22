

;- Mon Jan 28 14:27:42 MST 2019

;- compute 2D mask to see all pixels that saturate at some point in the
;-  time series.

goto, start

dz = 64
time = strmid(A[cc].time,0,5)


;- Map on which to plot ROI polygons

cc = 0

center = [ $
    [192, 184], $
    [198, 155], $
    [203, 188], $
    [210, 150], $
    [212, 186], $
    [230, 145], $
    [230, 175], $
    [230, 190], $
    [255, 155], $
    [270, 190], $
    [280, 162], $
    [280, 180] $
    ]



center = [ $
    [110, 115], $
    [127, 143], $
    [192, 184], $
    [204, 148], $
    [230, 140], $
    [232, 180], $
    [257, 156], $
    [283, 180], $
    [290, 165], $
    [342, 211], $
    [370, 212], $
    [382, 196] $
    ]
mm = (size(center, /dimensions))[1]
r = 10

@color

;----- Image powermap with polygons around ROIs --------


;xx = [125:325]
;yy = [75:275]
;file = 'AR_center'

;xx = [0:200]
;yy = [0:200]
;file = 'AR_left'

;xx = [300:500]
;yy = [100:300]
;file = 'AR_right'

xx = [0:499]
yy = [0:329]

wx = 8.5
wy = 11.0
win = window( dimensions=[wx,wy]*dpi, location=[750,0] )

width = 6.0
height=width*(330./500)
;height = width
resolve_routine, 'get_position', /either

cols = 1
rows = 2

im = objarr(2)
foreach zz, [0,201], jj do begin

    title = A[cc].name + ' ' + time[zz] + '-' + time[zz+dz-1] + ' UT' + $
        ' (' + strtrim(zz,1) + '-' + strtrim(zz+dz-1,1)  + ')'

    position = GET_POSITION( $
        layout=[cols,rows,jj+1], $
        width=width, height=height, $ 
        left=1.25, $
        top=1.0, $
        ;ygap=1.0 $
        xgap=0.25 $
        )

    imdata = alog10(A[cc].map[xx,yy,zz]+0.0001)
    
    im[jj] = image2( $
        imdata, $
        xx, yy, $
        /current, $
        /device, $
        ;xtickinterval = 20, $
        ;ytickinterval = 20, $
        ;xminor = 9, $
        ;yminor = 9, $
        position = position*dpi, $
        title = title, $
        ;min_value = -10.0, $
        rgb_table=A[0].ct )

    ;continue
    ;c_data = GET_CONTOUR_DATA( time[zz+(dz/2)], channel='mag' )
    c_data = GET_CONTOUR_DATA( time[zz:zz+dz-1], channel='mag' )
    c = contours( c_data[xx,yy,0], xx, yy, target=im[jj], channel='mag' ) 
    ;save2, file, /add_timestamp, idl_code = 'today.pro'

    pol = objarr(mm)
    for ii = 0, mm-1 do begin
        pol[ii] = POLYGON2( $
            target=im[jj], $
            center=center[*,ii], $
            dimensions=[r,r], $
            thick=1.0, $
            color=color[ii], $
            name=strtrim(ii,1) )
        txt = text( $
            center[0,ii]-(r/2)-2, center[1,ii], $
            strtrim(ii+1,1), $
            target=im[jj], $
            /data, $
            color = color[ii], $
            font_size=9, $
            ;font_style=1, $
            alignment = 1.0, vertical_alignment = 0.5 )
    endfor
endforeach

save2, 'powermap_contours_ROIs', /add_timestamp, idl_code = 'today.pro'
stop




; -- Plot P(t) with flux and time-averaged flux -----------


; ---- Calculations --


sz = size(A[0].data, /dimensions)
flux = fltarr( sz[2], mm )
sz2 = size(A[0].map, /dimensions)
power = fltarr( sz2[2], mm )
;- time-averaged intensity over dz
flux_avg = fltarr( sz2[2], mm )


for ii = 0, mm-1 do begin
    flux[*,ii] = mean(mean( crop_data( $
        A[0].data, center=center[*,ii], dimensions=[r,r] ), $
        dimension=1 ), dimension=1 )
    power[*,ii] = mean(mean( crop_data( $
        A[0].map, center=center[*,ii], dimensions=[r,r] ), $
        dimension=1 ), dimension=1 )
    for jj = 0, sz2[2]-1 do begin
        flux_avg[jj,ii] = mean( flux[jj:jj+dz-1, ii] )
    endfor
endfor

;- pad with zeros and shift by dz/2 to plot as func of t-seg center.
flux_avg = [flux_avg, fltarr(63,mm) ]
power = [power, fltarr(63,mm) ]
flux_avg = shift( flux_avg, (dz/2), 0 )
power = shift( power, (dz/2), 0 )
stop


; ---- Graphics --
start:;---------------------------------------------------------------------------------

resolve_routine, 'get_position', /either
resolve_routine, 'vline', /either

rows = 4
cols = 3
wx = 8.5
wy = 11.0

plt = objarr(mm)

ylog = 0

z_ind = [50:230]
win = window( dimensions=[wx,wy]*dpi, location=[750,0] )

for ii = 0, mm-1 do begin

    position = dpi * GET_POSITION( $
        layout=[cols,rows,ii+1], $
        top = 0.5, $
        left = 1.0, $
        width=2.25, $
        height=2.25, $
        xgap=0.1, $
        ygap=0.1, $
        wy=wy)

    y1 = flux[ z_ind, ii]
    plt[ii] = plot2( $
        z_ind, $
        ;y1, $
        ;y1 - mean(y1), $
        (y1-min(y1))/(max(y1)-min(y1)), $
        /current, $
        /device, $
        position=position, $
        yrange=[0,1.2], $
        ytickvalues=[0,2,4,6,8,10]/10., $
        ylog = ylog, $
        xtickinterval=50, $
        ;xminor=9, $
        yminor=4, $
        xticklen=0.025, $
        yticklen=0.025, $
        xsubticklen=0.3, $
        ysubticklen=0.3, $
        name='intensity' )

    y2 = flux_avg[z_ind, ii]
    plt2 = plot2( $
        z_ind, $
        ;y2, $
        ;y2 - mean(y2), $
        (y2-min(y2))/(max(y2)-min(y2)), $
        /overplot , $
        ylog=ylog, $
        linestyle=[1, '3C3C'X], $
        name='time-averaged intensity' )

    y3 = power[z_ind, ii]
    plt3 = plot2( $
        z_ind, $
        ;y3, $
        ;y3 - mean(y3), $
        (y3-min(y3))/(max(y3)-min(y3)), $
        /overplot, $
        ylog = ylog, $
        thick=1.0, $
        color=color[ii], $
        name = '3-minute power')

    ;plt.aspect_ratio=(201./( (plt.yrange)[1] - (plt.yrange)[0] ))
    plt[ii].xtickname = time[plt[ii].xtickvalues]

    ;vline, plt[ii], [260-(dz/2),260], /bg, linestyle='-'

    if ii lt 9 then plt[ii].xshowtext=0

    txt = text( $
        0.03, 0.97, $
        strtrim(ii+1,1) + ')', $
        target=plt[ii], $
        /relative, $
        color = color[ii], $
        font_size=9, $
        font_style=1, $
        alignment = 0.0, $
        vertical_alignment = 1.0 )

endfor


foreach pind, [1,2,4,5,7,8,10,11] do $
    plt[pind].yshowtext=0


;leg.delete
leg = legend2( $ ;/upperright, $
    /device, $
    position=[wx-1.0, 0.2]*dpi, $
    target=[plt[mm-1],plt2,plt3], $
    horizontal_alignment = 1.0, $
    sample_width=0.10 )

mytitle = text( $
    dpi*(wx/2), dpi*(wy-0.25), $
    'Pre-flare P$_{3min}$(t) for 12 ROIs (' + $
        time[z_ind[0]] + '-' + time[z_ind[-1]] + ')', $
    ;target=plt[ii], $
    /device, $
    ;color = color[ii], $
    font_size=fontsize, $
    ;font_style=1, $
    alignment = 0.5, $
    vertical_alignment = 1.0 )
stop
save2, 'ROI_power_time', /add_timestamp, idl_code = 'today.pro'
stop




;----------- Image AR center (AR_1b and AR_2a) ----------------

wx = 14.0
wy = 7.0
win = window( dimensions=[wx,wy]*dpi, location=[750,0] )

imdata = alog10( A[0].data[125:325,75:275,z_ind] + 0.0001 )
;imdata = alog10( A[0].map[125:325,75:275,z_ind] + 0.0001 )

foreach zz, [0,100,200], ii do begin
    im = image2( imdata[*,*,zz], /current, /device, $
        layout=[3,1,ii+1], margin=0.1*dpi, $
        rgb_table=A[0].ct )
endforeach

stop


aia_lct, wave=1600, /load
xstepper, imdata, xsize=512, ysize=512

stop


;im = image( imdata, rgb_table = A[0].ct )



;- Code moved from image_powermaps.pro so I can develop that one into
;-  a more general routine:



cc = 0
time = strmid(A[cc].time,0,5)

dz = 64

;- Crop data to 200x200 centered on AR center
center = [ 225, 175 ]
r = 200

;- Pre-flare
z_ind = [0, 197]

data = CROP_DATA( $
    A[cc].data, center=center, dimensions=[r,r] )


;- initialize IMAGE array to hold "composite" image data (not maps yet)
imdata = fltarr( r, r, n_elements(z_ind) )

;- Create "composite" images to represent intensity distribution
;-  from which power map was obtained.
;-    --> Did I use product or mean for SDO figures??
;-         Neither one looks correct, though haven't used aia_intscale yet.
;-  Looks like aia_intscale is what I was missing.
;-   Used mean... product would reduce values for anything less than 1,
;-    which isn't what we want.

foreach zz, z_ind, ii do $
    imdata[*,*,ii] = MEAN( data[*,*,zz:zz+dz-1], dimension=3 )




;- Crop maps, after bit of a detour with the data. Won't need to do that every time.
mapdata = CROP_DATA( $
    A[cc].map, $
    center=center, dimensions=[r,r], z_ind=z_ind )


imdata = aia_intscale( imdata, exptime=A[cc].exptime, wave=1600 )
mapdata = alog10( mapdata + 0.0001 )

rows = 1
cols = 3


wx = 12.0
wy = 4.0
win = window( dimensions=[wx,wy]*dpi, location=[750,0] )

foreach zz, z_ind, ii do begin

    title = A[cc].name + ' ' + time[zz] + '-' + time[zz+dz-1] + $
        ' (' + strtrim(zz,1) + '-' + strtrim(zz+dz-1,1)  + ')'

    im = image2( $
        mapdata[*,*,ii], $
        /current, $
        /device, $
        layout=[cols,rows,ii+1], $
        margin=0.50*dpi, $
        xshowtext=0, $
        yshowtext=0, $
        rgb_table=A[cc].ct, $
        title = title )

    endforeach

end
