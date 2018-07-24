
; Last modified:   06 July 2018


pro image_ar_old

; from 2018-05-13.pro

    ;t_array = [ ' 00:00:42.57 UT', ' 00:00:32.21 UT' ]

    ; Coordinates (relative to full disk) from prep.pro
    x_center = 2400
    y_center = 1650
    x_length = 500
    y_length = 330
    x1 = x_center - x_length/2
    y1 = y_center - y_length/2
    x2 = x1 + x_length -1
    y2 = y1 + y_length -1


    for i = 0, 1 do begin
        ;crop = 200
        ;data = full[ crop:sz[0]-crop, crop:sz[1]-crop, i ]
        data = full[ *, *, i ]
        ;data = A[i].data[*,*,0]

        im[i] = image2( $
            data^0.5, $
            /device, $
            /current, $
            layout=[1,2,i+1], $
            margin=[0.75, 0.75, 0.2, 0.75]*dpi, $
            ;axis_style=0, $
            rgb_table=A[i].ct, $
            ;title=A[i].name + ' 2011-February-15 ' + t_array[i], $
            title=A[i].name + ' 2011-February-15 ' + A[i].time[0], $
            xtitle='X (arcseconds)', $
            ytitle='Y (arcseconds)', $
            name=A[i].name $
        )
        ; Change axis labels from pixels to arcseconds
        im[i].xtickname = strtrim(round(im[i].xtickvalues * 0.6),1)
        im[i].ytickname = strtrim(round(im[i].ytickvalues * 0.6),1)

        ; Draw rectangle around (temporary) area of interest.
        rec = polygon2( x1, y1, x2, y2, target=im[i])
    endfor
    save2, 'full_color_boxed.pdf'
end
