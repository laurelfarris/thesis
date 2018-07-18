

pro IMAGE_ARRAY, data, layout=layout
;    wx=wx, wy=wy

    ; string array of letters: (a), (b), ..., (z)
    alph = '(' + string( bindgen(1,26)+(byte('a'))[0] ) + ')'

    common defaults
    sz = size(data, /dimensions)
    cols = layout[0]
    rows = layout[1]

    ; No axis labels in "network" of images
    ;xgap = 0.25
    ;ygap = 0.25

    ; Leave room for axis labels
    xgap = 0.50
    ygap = 0.50

    ; Outer margins
    left = 0.75
    bottom = 0.50
    right = 0.5
    ;right = right + 1.25 ; room for colorbar
    top = 0.5
    margin = [ left, bottom, right, top ]

    wx = 8.5
    ;wy = wx * (float(rows)/cols) * (float(sz[1])/sz[0])
    ;wy = wx * (float(rows)/cols) * (height/width)

    ; image dimensions
    ;  (adjust width only. Height probably won't need to be changed)
    width = (wx/cols) - (xgap*(cols-1)) - (left + right)
    height = width * float(sz[1])/sz[0]

    wy = (height*rows) + (ygap*(rows-1)) + (bottom + top)

    dw
    win = window( dimensions=[wx,wy]*dpi, /buffer )
    im = objarr(cols,rows)

    ii = 0
    for y = 0, rows-1 do begin
        for x = 0, cols-1 do begin
            x1 = left + x*(width + xgap)
            x2 = x1 + width
            ;y1 = bottom + y*(height + ygap)
            ;y2 = y1 + height
            y2 = wy - top - y*(height + ygap)
            y1 = y2 - height
            position = [ x1, y1, x2, y2 ] * dpi

            im[x,y] = image2( $
                data[*,*,ii], $
                /current, /device, $
                ;layout=layout, margin=margin, $
                position=position, $
                ;xshowtext=0, $
                ;yshowtext=0, $
                _EXTRA=e )

            ;tx = (x2-10)*dpi
            ;ty = (y2-10)*dpi
            tx = 0.85
            ty = 0.85
            t = TEXT( $
                tx, ty, $
                alph[ii], $
                ;/device, $
                /relative, $
                target=im[x,y], $
                fill_background=1, $
                fill_color='white', $
                font_color='black', $
                font_style='Bold', $
                font_size=9 )
            ii = ii + 1
        endfor
    endfor
    save2, 'test.pdf', /add_timestamp 
end

pro IMAGE_ARRAY_WRAPPER, data, _EXTRA=e
    IMAGE_ARRAY, data ; , $ .... other stuff
end

test = map[*,*,0:5]
mx = 0.9*max(test)
mx = 2500
test = test > 0.001 < mx
IMAGE_ARRAY, test, layout=[2,3]

end
