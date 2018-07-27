

function PLOT_HORIZONTAL_LINES, xrange, y, names=names, $
    linestyle=linestyle, $
    _EXTRA=e

    N = n_elements(y)
    if not keyword_set(names) then names = strarr(N)
    line = objarr(N)

    for i = 0, N-1 do begin
        line[i] = plot( $
            xrange, $
            [y[i],y[i]], $
            /overplot, $
            xstyle = 1, $
            ;linestyle = i+2, $
            linestyle = linestyle[i], $
            name = names[i], $
            _EXTRA=e )
    endfor
    return, line
end
