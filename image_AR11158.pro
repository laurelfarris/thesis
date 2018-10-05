
; Last modified:   06 July 2018


pro IMAGE_AR, S
;function image_ar, data, X, Y, layout=layout, _EXTRA=e
    ;X = ( (indgen(sz[0]) + image_location[0]) - crpix ) * cdelt
    ;Y = ( (indgen(sz[1]) + image_location[1]) - crpix ) * cdelt

    common defaults

    cols = 3
    rows = 2
    im = objarr(cols,rows)

    left = 0.5
    bottom = 0.5
    right = 0.5
    top = 0.5

    ; width (w) and height (h) of individual panels
    w = 2.0
    h = w

    ; Center of AR* --> lower left corner of AR
    ;   *according to green book (page 50, February 2)
    x0 = 2375
    y0 = 1660
    xl = x0 - 250
    yl = y0 - 165

    ;wx = 8.5/2
    ;wy = wx * (sz[1]/sz[0]) * 2
    wx = 8.0
    wy = 5.0
    dw
    win = window( dimensions=[wx,wy]*dpi, buffer=1 )

    ;----------------------------------------------------------------------------
    ; Need to speed this part up a little bit...

    for j = rows-1, 0, -1 do begin
        for i = 0, cols-1 do begin

            ; Set up X/Y axis labels in solar coords (arcsec, rel to disk center)
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

            ; Image positions

            ; Multiply by i to add space between panels
            x1 = 0.75 + i*(w+0.1)

            ; shift in h moves TOP row up and down
            y1 = 0.40 + j*(h)
            ;y1 = 0.40 + j*(h-0.5) ; not enough space
            ;y1 = 0.40 + j*(h+0.5) ; too much space

            position=[x1,y1,x1+w,y1+h]

            ;data = aia_intscale(data, wave=wave, exptime=exptime)

            im[i,j] = image2( $
                data, X, Y, $
                /current, /device, $
                position=position*dpi, $
                xshowtext=0, $
                yshowtext=0, $
                _EXTRA=S.(i).extra )

            ; Show x-labels for full disk and AR, since they don't match.
            ax = im[i,j].axes
            ax[0].showtext = 1

            ; Far left column
            if i eq 0 then begin
                ax[1].showtext = 1
                ax[1].title='Y (arcseconds)'
            endif

            ; bottom row
            if j eq 0 then begin
                im[i,j].title = ''
                ax[0].title='X (arcseconds)'
            endif
        endfor
    endfor
    ;----------------------------------------------------------------------------

    resolve_routine, 'save2'
    file = 'color_images.pdf'
    save2, file;, /add_timestamp
    return

    ; Polygons - Draw rectangle around (temporary) area of interest.
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
        color='white' )
end

; External routine to save single image in structure S
;resolve_routine, 'get_image_data', /either
;S = get_image_data()

IMAGE_AR, S

end
