

function OPLOT_VERTICAL_LINES, x, yrange, names=names, $
    linestyle=linestyle, $
    _EXTRA=e

    N = n_elements(x)
    if not keyword_set(names) then names = strarr(N)
    line = objarr(N)

    for i = 0, N-1 do begin
        line[i] = plot( $
            [x[i], x[i]], $
            yrange, $
            /overplot, $
            ystyle = 1, $
            ;linestyle = i+2, $
            linestyle = linestyle[i], $
            name = names[i], $
            _EXTRA=e )
    endfor
    return, line
end
