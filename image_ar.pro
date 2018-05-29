


; 2018 April 19 (updated April 23)
; see 2018-05-13 for imaging of full disk.

function get_full_disk_data

    ; Read in full disk data for first image only:
    ;path = '/solarstorm/laurel07/Data/AIA/'
    path = '/solarstorm/laurel07/Data/AIA_prepped/'

    channel = '1600'
    ;files = '*aia*' + channel + '*2011-02-15*.fits'
    files = 'AIA20110215_*_1600*.fits'
    fls = (file_search(path + files))[0]
    READ_SDO, fls, index, aia1600full

    channel = '1700'
    ;files = '*aia*' + channel + '*2011-02-15*.fits'
    files = 'AIA20110215_*_1700*.fits'
    fls = (file_search(path + files))[0]
    READ_SDO, fls, index, aia1700full

    full = [ [[ aia1600full ]], [[ aia1700full ]] ]
    return, full
end


function image_ar, data, layout=layout, _EXTRA=e

    common defaults
    dpi = 96

    cdelt = 0.6
    crpix = 2048.5

    x0 = 2420 - 35
    y0 = 1665
    ;data2 = data[ x0-(xl/2):x0+(xl/2)-1, y0-(yl/2):y0+(yl/2)-1, * ]

    if not keyword_set(layout) then layout=[1,1]

    cols = layout[0]
    rows = layout[1]

    im = objarr(cols*rows)

    wx = 8.5
    wy = wx / 1.8
    w = window( dimensions=[wx,wy]*dpi )

    kk = 0
    for jj = 0, rows-1 do begin
        for ii = 0, cols-1 do begin

            temp = data[*,*,ii]
            sz = size(temp, /dimensions)
            X = ( indgen(sz[0])-crpix ) * cdelt
            Y = ( indgen(sz[1])-crpix ) * cdelt

            if jj eq 1 then begin
                temp = crop_data( temp, center=[x0,y0] )
                X = X[ x0-(500/2):x0+(500/2)-1 ]
                Y = Y[ y0-(330/2):y0+(330/2)-1 ]
            endif

;            w = 2.0
;            h = w * (sz[1]/sz[0])
;            x1 = 1.25
;            y1 = 0.5
;            x2 = x1 + w
;            y2 = y1 + w * (sz[1]/sz[0])
;            pos = [x1,y1,x2,y2]

            im[kk] = image2( $
                temp, X, Y, $
                /current, /device, $
                layout=[cols,rows,kk+1], $
                margin=[2.25, 0.05, 0.05, 0.5]*dpi, $
                xtitle='X (arcseconds)', $
                ytitle='Y (arcseconds)', $
                _EXTRA=e $
            )

            xs = -0.06 * ii
            ys =  0.07 * jj

            pos = im[kk].position
            im[kk].position = pos + [xs,ys,xs,ys]

            ax = im[kk].axes
            ax[0].showtext = jj
            if ii eq 0 then ax[1].showtext = 1 else ax[1].showtext=0

            kk = kk + 1

        endfor
    endfor

    return, im

end



pro image_hmi, data

    dpi = 96
    common defaults
    sz = float(size(data, /dimensions))
    wx = 8.5/2
    wy = wx * (sz[1]/sz[0])
    w = window( dimensions=[wx,wy]*dpi )
    im = image2( $
        data, $
        /current, $
        title='HMI B$_{LOS}$ 2011-February-15 00:00:27.30', $
        xtitle='X (arcseconds)', $
        ytitle='Y (arcseconds)' $
        )
     im.xtickname = strtrim([50:350:50],1)
     im.ytickname = strtrim([-340:-140:50],1)
end





goto, start


; 23 May 2018

; full disk

channel = '1600'
;channel = '1700'
path = '/solarstorm/laurel07/Data/AIA_prepped/'
fls = (file_search( path + '*' + channel + '*.fits' ))[0]

read_sdo, fls, aia1600index, aia1600image
;read_sdo, fls, aia1700index, aia1700image

read_my_fits, channel, hmiBLOSindex, hmiBLOSimage, /hmi

stop


hmi = create_struct( hmi, 'ar', hmiBLOSar, 'ct', 1 )

; lower left corner to center up active region
; (for FIRST image in series!)
; Should use image in middle of time series --> reference for alignment
x1 = 2120
x2 = x1 + 500-1
y1 = 1500
y2 = y1 + 330-1

;hmiBLOSar = hmi.data[x0-250:x0+250-1, y0-165:y0+165-1, 0]
hmiBLOSar = hmi.data[x1:x2,y1:y2]

image_struc = { $
    aia1600full : aia1600image, $
    aia1700full : aia1700image, $
    hmiBLOSfull : hmi.data, $
    aia1600ar : A[0].data[*,*,0], $
    aia1700ar : A[1].data[*,*,0], $
    hmiBLOSar : hmiBLOSar $
}

; Scaling data (see documentation on SDO data)
; log10 moves values much closer together.
; should try this for power maps (be sure to account for values=0)
;im = image( temp^0.5, min_value=0.0 )
;im = image( alog10(temp), min_value=0.001)

;color_tables = [ A[0].ct, A[1].ct, 1 ]
;names = [ A[0].name, A[1].name, hmi.name ]

START:;--------------------------------------------------------------------
hmi.ct = 0

resolve_routine, 'image_ar', /is_function
w = window(dimensions=[10.0,6]*dpi, location=[500,0])
im = objarr(6)

j = 0

a6 = { $
    name : A[0].name, $
    data : aia1600image, $
    ar : A[0].data[*,*,0], $
    ct : A[0].ct }
a7 = { $
    name : A[1].name, $
    data : aia1700image, $
    ar : A[1].data[*,*,0], $
    ct : A[1].ct }

S = { a6:a6, a7:a7, hmi:hmi }

j=0
for i = 0, 2 do begin
    im[j] = image_ar( $
        S.(i).data, $
        ;image_struc.(j), $
        ;min_value=0.0, $
        ;max_value=100, $
        layout=[3,2,j+1], $
        rgb_table=S.(i).ct, $
        name=S.(i).name )
    j=j+1
endfor

for i = 0, 2 do begin
    im[j] = image_ar( $
        S.(i).ar, $
        layout=[3,2,j+1], $
        rgb_table=S.(i).ct, $
        image_location=[x1,y1], $
        name=names[i] )

    xtickname = round( (im[j].xtickvalues - aia1600index[0].crpix1) $
        * aia1600index[0].cdelt1 )
    ytickname = round( (im[j].ytickvalues - aia1600index[0].crpix2) $
        * aia1600index[0].cdelt2 )
    im[j].xtickname = strtrim(xtickname,1)
    im[j].ytickname = strtrim(ytickname,1)
    j = j + 1
endfor


; Another option:
; for i = 0, 1 ... top and bottom images for one channel/instrument.

end



x0 = 2375
y0 = 1660
;aia1 = create_struct( aia1, 'data2' , A[0].data[*,*,0] )
;aia2 = create_struct( aia2, 'data2' , A[1].data[*,*,0] )
;hmi2 = create_struct( hmi2, 'data2' , hmi2.data[x0-250:x0+250-1, y0-165:y0+165-1])
;aia1.data2 = aia1.data[x0-250:x0+250-1, y0-165:y0+165-1]
;aia2.data2 = aia2.data[x0-250:x0+250-1, y0-165:y0+165-1]
;hmi2.data2 = hmi.data[x0-250:x0+250-1, y0-165:y0+165-1]
;S = { aia1:aia1, aia2:aia2, hmi2:hmi2 }

cols = 3
rows = 1
im = objarr(cols*rows)
;im = objarr(n_tags(S))

for i = 0, cols*rows-1 do begin
    im[i] = image_ar( $
        data, $
        layout=[cols,rows,i+1] $
        )
endfor

;; Yet another bunch of code...
;full = image_full_disk()
;sz = float( size( full, /dimensions ) )
;
;    ; Coordinates (relative to full disk) from prep.pro
;    x_center = 2400
;    y_center = 1650
;    x_length = 500
;    y_length = 330
;    x1 = x_center - x_length/2
;    y1 = y_center - y_length/2
;    x2 = x1 + x_length -1
;    y2 = y1 + y_length -1
;
;    wx = 8.5/2
;    wy = wx * (sz[1]/sz[0]) * 2
;    w = window( dimensions=[wx,wy]*dpi )
;    im = objarr(2)
;
;    for i = 0, 1 do begin
;        im[i] = image2( $
;            (full[*,*,i])^0.5, $
;            /device, $
;            /current, $
;            layout=[1,2,i+1], $
;            margin=[1.00, 0.75, 0.2, 0.75]*dpi, $
;            ;axis_style=0, $
;            rgb_table=A[i].ct, $
;            ;title=A[i].name + ' 2011-February-15 ' + t_array[i], $
;            title=A[i].name + ' 2011-February-15 ' + A[i].time[0], $
;            xtitle='X (arcseconds)', $
;            ytitle='Y (arcseconds)', $
;            name=A[i].name $
;        )
;
;        ; Draw rectangle around (temporary) area of interest.
;        rec = polygon2( x1, y1, x2, y2, target=im[i])
;
;        ; Change axis labels from pixels to arcseconds
;        ;xname =  round( (im[i].xtickvalues * 0.6) - 1200 )
;        ;im[i].xtickname = strtrim( xname, 1 )
;        ;im[i].ytickname = strtrim( xname, 1 )
;
;        values = [-1000, -500, 0, 500, 1000]
;        im[i].xtickvalues = (values + 1200) / 0.6
;        im[i].ytickvalues = (values + 1200) / 0.6
;        im[i].xtickname = strmid( values, 1 )
;        im[i].ytickname = strmid( values, 1 )
;
;
;    endfor


;; Polygons
; Draw rectangle around (temporary) area of interest.
rec = polygon2( 40, 90, 139, 189, target=im[i])
; Draw rectangle around Active Region (for full disk)
; Coordinates (relative to full disk) from prep.pro:
x_center = 2400
y_center = 1650
x_length = 500
y_length = 330
x1 = x_center - x_length/2
y1 = y_center - y_length/2
x2 = x1 + x_length -1
y2 = y1 + y_length -1
; Draw rectangle around (temporary) area of interest.
;rec = polygon2( 40, 90, 139, 189, target=im[i])
;rec = polygon2( x1, y1, x2, y2, target=im[i])


;; Pixels --> Arcseconds

; Label with arcseconds after polygon creation.
; Because I'm too tired to convert the polygon coords.
;xnames = round(A[i].X)
;im[i].xtickname = strtrim( xnames, 1 )
;ynames = round(A[i].Y)
;im[i].ytickname = strtrim( ynames, 1 )
;im[i].xmajor = 5
;im[i].ymajor = 5

; Label opposite axis in units of arcseconds
;ax = im[i].axes
;ax[2].tickname = strtrim(round(ax[0].tickvalues * 0.6), 1)
;ax[3].tickname = strtrim(round(ax[1].tickvalues * 0.6), 1)
;ax[2].title = "X (arcseconds)"
;ax[3].title = "Y (arcseconds)"
;ax[2].showtext = 1
;ax[3].showtext = 1

im[i].xtickvalues = (im[i].xtickvalues)[1:-2]
im[i].xtickname = strtrim([100:300:50],1)
;im[i].xtickname = strtrim([50:350:50],1)
im[i].ytickname = strtrim([-340:-140:50],1)
;im[i].xtickname = strtrim([-1000:1000:500],1)
;im[i].ytickname = strtrim([-1000:1000:500],1)


;; Position graphics
im[1].yshowtext = 0
im[2].yshowtext = 0
xoff = 0.04
yoff = 0.0
im[0].position = im[0].position + 2.*[xoff, yoff, xoff, yoff]
im[1].position = im[1].position + 1.*[xoff, yoff, xoff, yoff]

; Use methods or whatever to grab current graphics
;    as a way to attach text, e.g. to a plot.
; Shouldn't need to feed the data back and forth.
txt = [ '(a)', '(b)' ]
t = text2( $
    position[0,i], position[3,i], $  ; upper left corner of each panel
    ;0.03, 0.9, $
    txt[i], $
    device=1, $
    ;relative=1, $
    target=im[i], $
    vertical_alignment=1.0, $
    color='white' $
)

;save2, 'color_images_9.pdf'
;save2, 'full_color_boxed_2.pdf'

end
