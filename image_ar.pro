;; Last modified:   29 May 2018 14:41:22


; 2018 April 19 (updated April 23)
; see 2018-05-13 for imaging of full disk.


;resolve_routine, 'image_ar', /is_function
;function image_ar, data, X, Y, layout=layout, _EXTRA=e
    ;X = ( (indgen(sz[0]) + image_location[0]) - crpix ) * cdelt
    ;Y = ( (indgen(sz[1]) + image_location[1]) - crpix ) * cdelt


function get_image_data

    resolve_routine, 'read_my_fits';, /compile_full_file


    ; Start from scratch - Read new data (only what you want to image).

    read_my_fits, 'hmi', 'mag', index, data, ind=[0]
    sz = size( data, /dimensions )
    X = (indgen(sz[0]) - index.crpix1) * index.cdelt1
    Y = (indgen(sz[1]) - index.crpix2) * index.cdelt2
    time = strmid(index.date_obs, 11, 11)
    hmi = { $
        data : data<300>(-300), $
        X : X, $
        Y : Y, $
        extra : { $
            title : 'HMI B$_{LOS}$ ' + time } $
        }

    read_my_fits, 'aia', '1600', index, data, ind=[0];, /prepped
    sz = size( data, /dimensions )
    X = (indgen(sz[0]) - index.crpix1) * index.cdelt1
    Y = (indgen(sz[1]) - index.crpix2) * index.cdelt2
    time = strmid(index.date_obs, 11, 11)
    aia_lct, wave=1600, r, g, b
    aia1600 = { $
        ;data : aia_intscale(data,wave=1600,exptime=index.exptime), $
        data : data, $
        X : X, $
        Y : Y, $
        extra : { $
            title : 'AIA 1600$\AA$ ' + time, $
            rgb_table : [[r],[g],[b]] } }

    read_my_fits, 'aia', '1700', index, data, ind=[0];, /prepped
    sz = size( data, /dimensions )
    X = (indgen(sz[0]) - index.crpix1) * index.cdelt1
    Y = (indgen(sz[1]) - index.crpix2) * index.cdelt2
    time = strmid(index.date_obs, 11, 11)
    aia_lct, wave=1700, r, g, b
    aia1700 = { $
        ;data : aia_intscale(data,wave=1700,exptime=index.exptime), $
        data : data, $
        X : X, $
        Y : Y, $
        extra : { $
            title : 'AIA 1700$\AA$ ' + time, $
            rgb_table : [[r],[g],[b]] } }

    S = { aia1600:aia1600, aia1700:aia1700, hmi:hmi }
    return, S
end

pro image_ar, S

    cols = 3
    rows = 2

    left = 0.5
    bottom = 0.5
    right = 0.5
    top = 0.5

    w = 2.0
    h = w

    ; Center of AR according to green book (page 50, February 2)
    x0 = 2375
    y0 = 1660
    ; lower left corner of AR
    xl = x0 - 250
    yl = y0 - 165

    im = objarr(cols,rows)
    win = window( dimensions=[8.0,4.5]*dpi )
    for j = rows-1, 0, -1 do begin
        for i = 0, cols-1 do begin

            if j eq 0 then begin
                data = crop_data(S.(i).data, center=[x0,y0])
                X = (S.(i).X)[xl:xl+500-1]
                Y = (S.(i).Y)[yl:yl+330-1]
            endif
            if j eq 1 then begin
                data = S.(i).data
                X = S.(i).X
                Y = S.(i).Y
            endif

            x1 = 0.75 + i*(w+0.1)

            ; Lowering y position a little to make room for correct axis labels
            ; on full disk.
            ;y1 = 0.40 + j*(h-0.2)
            y1 = 0.30 + j*(h-0.2)

            position=[x1,y1,x1+w,y1+h]

            im[i,j] = image2( $
                data, X, Y, $
                /current, /device, $
                position=position*dpi, $
                xshowtext=0, $
                yshowtext=0, $
                xtitle='X (arcseconds)', $
                ytitle='Y (arcseconds)', $
                _EXTRA=S.(i).extra )

            ax = im[i,j].axes

            ; Show x-labels for full disk and AR, since they don't match.
            ax[0].showtext = 1

            if i eq 0 then ax[1].showtext = 1
            if j eq 0 then begin
                ;ax[0].showtext = 1
                im[i,j].title = ''
            endif
        endfor
    endfor

    ;; Polygons
    ; Draw rectangle around (temporary) area of interest.
    ;rec = polygon2( x1, y1, x2, y2, target=im[i])
    ;rec = polygon2( 40, 90, 139, 189, target=[im[0,0],im[1,0],im[2,0])
    rec = polygon2( xl, yl, xl+500, yl+330,/device, target=[im[0,0],im[1,0],im[2,0]])

    ; Add text to graphics
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


end

;save2, 'color_images_10.pdf'
;save2, 'full_color_boxed_2.pdf'

S = get_image_data()

end
