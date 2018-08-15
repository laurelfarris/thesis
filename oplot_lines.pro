

function OPLOT_VERTICAL_LINES, $
    ;x, yrange, $
    coords, range, $
    names=names, $
    linestyle=linestyle, $
    horizontal=horizontal, $
    vertical=vertical, $
    send_to_back=send_to_back, $
    _EXTRA=e


    N = n_elements(coords)

    if not keyword_set(names) then names = strarr(N)

    line = objarr(N)


    ;; Plot vertical lines
    if keyword_set(vertical) then begin

        x = coords
        yrange = range

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
    endif


    ;; Plot horizontal lines
    if keyword_set(horizontal) then begin

        xrange = range
        y = coords

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
    endif

    if keyword_set(send_to_back) then begin
        for i = 0, N-1 do begin
            line[i].Order, /send_to_back
        endfor
    endif

    return, line
end
