;; Last modified:   21 September 2017 02:09:15

;; Add extra right/top size to make room for colorbar

function positions, cols, rows, b=b, l=l, t=t, r=r, gap=gap

    pos = fltarr( 4, cols*rows )
    w = (1.0 - ( r + l + gap*(cols-1) ))/cols
    h = (1.0 - ( t + b + gap*(rows-1) ))/rows
    
    i = 0
    for y = 0, rows-1 do begin
    for x = 0, cols-1 do begin
        
        x1 = l + x*(w+gap)
        y1 = b + y*(h+gap)
        x2 = x1 + w
        y2 = y1 + h

        pos[0,i] = [x1,y1,x2,y2]
        i = i + 1


    endfor
    endfor


    return, pos


end
