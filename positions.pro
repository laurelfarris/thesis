;; Last modified:   14 October 2017 10:16:57


pro POSITIONS, cols, rows, width, height, margin, gap, $
    pos, dim

    ;; Position array(s)
    pos = fltarr(4, rows*cols)
    x1 = []
    y1 = []
    x2 = []
    y2 = []

    i = 0
    ;; y in reverse to put layout in same order as default.
    for y = rows-1, 0, -1 do begin
        for x = 0, cols-1 do begin
            x1 = [ x1, margin + (gap+width)  * x ]
            y1 = [ y1, margin + (gap+height) * y ]
            x2 = [ x2, x1[i] + width ]
            y2 = [ y2, y1[i] + height ]
            i = i + 1
        endfor
    endfor
    pos[0,*] = x1
    pos[1,*] = y1
    pos[2,*] = x2
    pos[3,*] = y2

    wx = 2*margin + cols*width  + (cols-1)*gap
    wy = 2*margin + rows*height + (rows-1)*gap
    dim = [wx,wy]


end
