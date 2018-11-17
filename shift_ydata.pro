

; Last modified:        17 November 2018

pro SHIFT_YDATA, plt
    ; Shift data in Y-direction
    ;- using same notation as typical line formula: y = mx + b
    ;- where y = new coordinates, linearly transformed from old coordinates x
    ;- by a factor of the slope, m.



    ;- Get shift (aa) and slope (bb) to use for coord_transform
    ;aa = [ mean(ydata[*,0]), mean(ydata[*,1]) ]
    ;bb = [ 1.0, 1.0 ];- slope

    ;x = xdata[*,ii]
    ;y = ( ydata[*,ii] - aa[ii] ) / bb[ii]
    ;ax[1].coord_transform = [aa[0],bb[0]]
    ;ax[3].coord_transform = [aa[1],bb[1]]

    bb = 1.0
    ;---
    ax = plt[0].axes
    plt[0].GetData, xx, yy
    aa = mean(yy)
    plt[0].SetData, xx, yy-aa
    ax[1].coord_transform = [aa,bb]
    ;---
    ax = plt[1].axes
    plt[1].GetData, xx, yy
    aa = mean(yy)
    plt[1].SetData, xx, yy-aa
    ax[3].coord_transform = [aa,bb]

    ax[3].showtext = 1

    ;format = '(F0.1)'
    ;ax[1].tickformat = format
    ;ax[3].tickformat = format
end
