

; Last modified:    18 November 2018

pro SHIFT_YDATA, plt

    ; Shift data in Y-direction
    ;- by subtracting either mean or min,
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



    for ii = 0, n_elements(plt)-1 do begin

        ax = plt[ii].axes

        plt[ii].GetData, xx, yy

        ;- subtract either the minimum or mean y-value.
        aa = mean(yy)
        ;aa = min(yy)

        plt[ii].SetData, xx, yy-aa

        if ii eq 0 then ax[1].coord_transform = [aa,bb]
        if ii eq 1 then ax[3].coord_transform = [aa,bb]


        ;- Even if this was already set, for some reason the text on ax[3]
        ;- disappears, and have to put it back.
        ax[3].showtext = 1

        ;format = '(F0.1)'
        ;ax[1].tickformat = format
        ;ax[3].tickformat = format

    endfor
end
