
; Last modified: 25 April 2018


function image_powermaps, map, cbar=cbar, layout=layout, _EXTRA=e


    common defaults

    ;xoff = -0.05
    xoff = 0.0
    yoff = 0.0

    if keyword_set(layout) then begin
        cols = layout[0]
        rows = layout[1]
    endif else begin
        cols = 3
        rows = 5
    endelse


    sz = size(map, /dimensions)
    ext = fltarr( 2, sz[2] )
    for i = 0, sz[2]-1 do $
        ext[*,i] = [ min(map[*,*,i]), max(map[*,*,i]) ]

    min_value = max( ext[0,*] )
    max_value = min( ext[1,*] )

    i = 0
    im = objarr(cols,rows)
    wx = 8.5
    wy = wx * (float(rows)/cols)
    w = window( dimensions=[wx,wy]*dpi )
    for y = 0, rows-1 do begin
    for x = 0, cols-1 do begin
        im[x,y] = image2( $
            map[*,*,i], $
            layout=[cols,rows,i+1], $
            ;margin=[0.1, 0.1, 1.50, 0.75]*dpi, $
            margin=0.5*dpi, $
            /current, /device, $
            axis_style=0, $
            _EXTRA=e )
        im[x,y].position = $
            im[x,y].position + [x*xoff, y*yoff, x*xoff, y*yoff]
        i = i + 1
    endfor
    endfor

    if keyword_set(cbar) then begin
        ; cx1 = ( im[cols-1,0].position)[0] + 0.1
        im_lower = im[cols-1,rows-1]
        im_upper = im[cols-1,0]
        cx1 = (im_lower.position)[2] + 0.01
        cy1 = (im_lower.position)[1]
        cx2 = cx1 + 0.03
        cy2 = (im_upper.position)[3]
        c = colorbar2( position=[cx1,cy1,cx2,cy2], $
            tickformat='(I0)', $
            major=11, $
            title='3-minute power^0.5' )
            ;range=[0,mx], $  mx = ??
    endif
    return, im

end
