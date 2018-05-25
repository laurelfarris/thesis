
; Last modified: 25 April 2018


pro image_powermaps, map, title, cbar=cbar, _EXTRA=e

    common defaults

    xoff = -0.05
    yoff = 0.0

    i = 0
    cols = 3
    rows = 5
    im = objarr(cols,rows)
    w = window2( dimensions=[8.5,9.0]*dpi )
    for y = 0, rows-1 do begin
    for x = 0, cols-1 do begin
        im[x,y] = image2( $
            map[*,*,i], $
            layout=[cols,rows,i+1], $
            margin=[0.1, 0.1, 1.50, 0.75]*dpi, $
            /current, /device, $
            title=title[i], $
            axis_style=0, $
            _EXTRA=e )
        im[x,y].position = $
            im[x,y].position + [x*xoff, y*yoff, x*xoff, y*yoff]
        i = i + 1
    endfor
    endfor

    if keyword_set(cbar) then begin
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

end

pro image_powermaps_2, map, title, cbar=cbar, _EXTRA=e
end

goto, start
start:




end
