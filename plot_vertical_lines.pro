

function PLOT_VERTICAL_LINES, xvalues, yrange, $
    names=names

    N = n_elements(xvalues)

    if not keyword_set(names) then names = strarr(N)

    v = objarr(N)

    for i = 0, N-1 do begin
        v[i] = plot( $
            [ xvalues[i], xvalues[i] ], $
            yrange, $
            /overplot, $
            ystyle = 1, $
            linestyle = i+2, $
            name = names[i], $
            _EXTRA=e )
    endfor

    return, v

end
