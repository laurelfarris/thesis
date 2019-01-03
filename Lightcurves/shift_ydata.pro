


function SHIFT_YDATA_OLD, p
    ; Last modified: ... sometime before 18 November 2018.
    ;  (old version)

    ; Shift data in Y-direction
    ;for i = 0, n_elements(p)-1 do begin
    ;endfor
    ;ytitle = 'Counts (DN s$^{-1}$)'

    m = 1.0
    format = '(F0.1)'
    ;---
    p[0].GetData, x, y
    b = min(y)
    p[0].SetData, x, y-b
    ax = p[0].axes
    ax[1].tickformat = format
    ax[1].coord_transform = [b,m]
    ;---
    p[1].GetData, x, y
    b = min(y)
    p[1].SetData, x, y-b
    ax = p[1].axes
    ax[3].coord_transform = [b,m]
    ax[3].tickformat = format
    ax[3].showtext = 1

    return, p
end

;----------------------------------------------------------------------------------

pro SHIFT_YDATA, $
    plt, $
    ;background=background, $
    delt=delt, $
    ytitle=ytitle

    ; Last modified:    18 November 2018

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



    ;- 01 December 2018
    ;- Pretty sure aa is the only variable that changes
    ;-    depending on how you want to shift the data.

    bb = 1.0
    for ii = 0, n_elements(plt)-1 do begin
        ax = plt[ii].axes
        plt[ii].GetData, xx, yy


        ;- subtract min, mean, or background
        ;- Or just have user input amount to shift...

        if not keyword_set(delt) then $
            aa = mean(yy) $
            ;aa = background[ii]
            ;aa = min(yy)
        else aa = delt[ii]

        plt[ii].SetData, xx, yy-aa

        if ii eq 0 then ax[1].coord_transform = [aa,bb]
        if ii eq 1 then ax[3].coord_transform = [aa,bb]

        ;- Even if this was already set, for some reason the text on ax[3]
        ;- disappears, and have to put it back.
        ax[3].showtext = 1

        if keyword_set(ytitle) then begin
            ax[1].title = ytitle[0]
            ax[3].title = ytitle[1]
        endif

        ;format = '(F0.1)'
        ;ax[1].tickformat = format
        ;ax[3].tickformat = format

    endfor
end
