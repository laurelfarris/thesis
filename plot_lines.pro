

function PLOT_VERTICAL_LINES, x, yrange, names=names, _EXTRA=e

    N = n_elements(x)
    if not keyword_set(names) then names = strarr(N)
    line = objarr(N)

    for i = 0, N-1 do begin
        line[i] = plot( $
            [x[i], x[i]], $
            yrange, $
            /overplot, $
            ystyle = 1, $
            linestyle = i+2, $
            name = names[i], $
            _EXTRA=e )
    endfor
    return, line
end


function PLOT_HORIZONTAL_LINES, xrange, y, names=names, _EXTRA=e

    N = n_elements(y)
    if not keyword_set(names) then names = strarr(N)
    line = objarr(N)

    for i = 0, N-1 do begin
        line[i] = plot( $
            xrange, $
            [y[i],y[i]], $
            /overplot, $
            xstyle = 1, $
            linestyle = i+2, $
            name = names[i], $
            _EXTRA=e )
    endfor
    return, line
end


function PLOT_FLARE_TIMES, time, yrange

    flare_times = [ '01:44', '01:56', '02:06' ]
    names = flare_times + [ ' (start)', ' (peak)', ' (end)' ]
    N = n_elements(flare_times)
    vx = intarr(N)

    ; Need to make sure time is in form 'hh:mm', not 'hh:mm:ss.dd'...
    for i = 0, N-1 do begin
        vx[i] = (where( time eq flare_times[i] ))[0]
    endfor

    ;win = getwindows()
    ;win.Select, /ALL
    v = PLOT_VERTICAL_LINES( ind, yrange, names=names )
    v.Order, /SEND_TO_BACK
    return, v

end
