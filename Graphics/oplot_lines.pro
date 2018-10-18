

function OPLOT_LINES, $
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




function VERT, x, yrange, $
    names=names, $
    _EXTRA=e


    N = n_elements(coords)

    if not keyword_set(names) then names = strarr(N)

    line = objarr(N)

    ;- Plot vertical lines

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

end




;- 18 October 2018
;- Combine "oplot_lines" and "oplot_flare_lines" into one file.

function OPLOT_FLARE_LINES, $
    time, $
    ;target=target, $
    shaded=shaded, $
    yrange=yrange, $
    send_to_back=send_to_back, $
    _EXTRA=e

    ;; Add way to get X data from current graphic;
    ;; may not necessarily be in indgen(N) coordinates...

    flare_times = [ '01:44', '01:56', '02:06' ]
    names = flare_times + [ 'UT (start)', 'UT (peak)', 'UT (end)' ]
    linestyle = [1,2,3]

    new_time = strmid( time, 0, 5 )

    N = n_elements(flare_times)
    vx = intarr(N)

    for i = 0, N-1 do $
        vx[i] = (where( new_time eq flare_times[i] ))[0]

    win = GetWindows( /current, NAMES=window_names )
    ;win.Select, /all
    ;print, window_names
    ;result = win.GetSelect()

    v = objarr(N)
    for jj = 0, n_elements(vx)-1 do begin
        v[jj] = plot( $
            [ vx[jj], vx[jj] ], $
            yrange, $
            /current, $
            /overplot, $
            ystyle = 1, $
            linestyle = linestyle[jj], $
            thick = 1, $
            name = names[jj], $
            _EXTRA=e )
        if keyword_set(send_to_back) then v[jj].Order, /SEND_TO_BACK
    endfor
    ;save2, 'test_in_oplot_flare_lines.pdf'


    ; Shaded region
    if keyword_set(shaded) then begin
        ;for ii = 0, n_elements(graphic)-1 do begin
            ;yrange = (graphic[ii]).yrange
            v_shaded = plot ( $
                [ vx[0]-32, vx[0]-32, vx[-1]+32-1, vx[-1]+32-1 ], $
                [ yrange[0], yrange[1], yrange[1], yrange[0] ], $
                /overplot, ystyle=1, linestyle=6, $
                fill_transparency=50, $
                fill_background=1, $
                fill_color='light gray' )
            v_shaded.Order, /SEND_TO_BACK
        ;endfor
    endif
    return, v
end
