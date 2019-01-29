

;- Mon Jan 28 14:27:42 MST 2019

;- compute 2D mask to see all pixels that saturate at some point in the
;-  time series.

goto, start

dz = 64


;- Map on which to plot ROI polygons

cc = 0

center = [ $
    [230, 145], $
    [230, 190], $
    [255, 155], $
    [280, 180], $
    [230, 175], $
    [203, 188], $
    [280, 162], $
    [198, 155], $
    [212, 186], $
    [270, 190], $
    [210, 150], $
    [192, 184] $
    ]
mm = (size(center, /dimensions))[1]
r = 5

@color

width = 6.0
resolve_routine, 'get_position', /either

wx = 8.5
wy = 11.0
win = window( dimensions=[wx,wy]*dpi, location=[750,0] )

im = objarr(2)
foreach zz, [0,201], jj do begin


    title = A[cc].name + ' ' + time[zz] + '-' + time[zz+dz-1] + ' UT' + $
        ' (' + strtrim(zz,1) + '-' + strtrim(zz+dz-1,1)  + ')'

    position = GET_POSITION( layout=[1,2,jj+1], $
        width=width, height=width*(330./500), $
        left=1.25, top=1.0, ygap=1.0 $
        )

    im[jj] = image2( $
        alog10(A[cc].map[*,*,zz]), $
        /current, $
        /device, $
        position = position*dpi, $
        title = title, $
        rgb_table=A[0].ct )

    ;continue


    c_data = GET_CONTOUR_DATA( time[zz+(dz/2)], channel='mag' )
    c = contours( c_data, target=im[jj], channel='mag' ) 


    pol = objarr(mm)
    for ii = 0, mm-1 do begin
        pol[ii] = POLYGON2( $
            target=im[jj], $
            center=center[*,ii], $
            dimensions=[r,r], $
            thick=1.0, $
            color=color[ii], $
            name=strtrim(ii,1) )
    endfor
endforeach

stop
start:;---------------------------------------------------------------------------------
save2, 'powermap_contours_ROIs', /add_timestamp

stop



z_ind = [0:197]
sz = size(A[0].data, /dimensions)

flux = fltarr( sz[2], mm )

sz2 = size(A[0].map, /dimensions)
power = fltarr( sz2[2], mm )


for ii = 0, mm-1 do begin

    flux[*,ii] = mean(mean( crop_data( $
        A[0].data, center=center[*,ii], dimensions=[r,r] ), $
        dimension=1 ), dimension=1 )
    power[*,ii] = mean(mean( crop_data( $
        A[0].map, center=center[*,ii], dimensions=[r,r] ), $
        dimension=1 ), dimension=1 )

endfor

flux_avg = fltarr( sz2[2], mm )

;- compute time-averaged intensity over dz
for jj = 0, mm-1 do begin
    for ii = 0, sz2[2]-1 do begin
        flux_avg[ii,jj] = mean( flux[ii:ii+dz-1, jj] )
    endfor
endfor


stop


rows = 4
cols = 3
wx = 8.5
wy = 11.0
win = window( dimensions=[wx,wy]*dpi, location=[750,0] )


xdata = z_ind + (dz/2)

resolve_routine, 'get_position', /either

for ii = 0, mm-1 do begin

    position = dpi * GET_POSITION( $
        layout=[cols,rows,ii+1], $
        top = 0.5, $
        width=2.00, $
        xgap=0.50, $
        ygap=0.40, $
        wy=wy)

    y1 = flux[ z_ind, ii]
    plt = plot2( $
        xdata, $
        y1 - mean(y1), $
        /current, $
        /device, $
        position=position, $
        name='intensity' )

    y2 = flux_avg[ z_ind, ii]
    plt2 = plot2( $
        xdata, $
        y2 - mean(y2), $
        /overplot , $
        linestyle=[1, '3C3C'X], $
        name='time-averaged intensity' )


    y3 = power[z_ind, ii]
    plt3 = plot2( $
        xdata, $
        y3 - mean(y3), $
        /overplot, $
        thick=1.0, $
        color=color[ii], $
        name = '3-minute power')

    ;plt.aspect_ratio=(201./( (plt.yrange)[1] - (plt.yrange)[0] ))
    plt.xtickname = time[plt.xtickvalues]

    ;offset=0.10
    ;if (ii eq 0) OR (ii eq 2) OR (ii eq 4) OR (ii eq 6) then $
    ;    plt.position = plt.position + [offset, 0, offset, 0]

endfor

leg = legend2( $ ;/upperright, $
    /device, $
    position=[5.0, 2.0]*dpi, $
    target=[plt,plt2,plt3], $
    sample_width=0.10 )

stop
save2, 'ROI_power_time', /add_timestamp


stop




;- Image AR center (AR_1b and AR_2a)

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


end
