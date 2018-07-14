

; Last modified: 13 July 2018

; Input:  3D map,
; Keywords: cbar - set = 1 to create colorbar
;           layout = [cols, rows]


function image_powermaps, map, cbar=cbar, layout=layout, _EXTRA=e

    common defaults
    left = 0.1
    bottom = 0.1
    right = 1.5
    top = 0.75
    margin = [left, bottom, right, top]*dpi

    ;xoff = -0.05
    xoff = 0.0
    yoff = 0.0

    if not keyword_set(layout) then layout = [3,5]
    cols = layout[0]
    rows = layout[1]

    ; 'ext' = 'extreme' values of each map (pretty sure xstepper2 does this...)
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
    win = window( dimensions=[wx,wy]*dpi )
    for y = 0, rows-1 do begin
        for x = 0, cols-1 do begin
            im[x,y] = image2( $
                map[*,*,i], $
                layout=[cols,rows,i+1], $
                ;margin=margin, $
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
