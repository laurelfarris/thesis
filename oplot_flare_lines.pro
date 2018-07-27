

function OPLOT_FLARE_LINES, time, graphic=graphic, shaded=shaded


    ;; Add way to get X data from current graphic;
    ;; may not necessarily be in indgen(N) coordinates...

    flare_times = [ '01:44', '01:56', '02:06' ]
    names = flare_times + [ ' (start)', ' (peak)', ' (end)' ]
    linestyle = [4,5,4]


    ; Need to make sure time is in form 'hh:mm', not 'hh:mm:ss.dd'...
    ; If it already is, does strmid change anything?
    new_time = strmid( time, 0, 5 )

    N = n_elements(flare_times)
    vx = intarr(N)

    for i = 0, N-1 do $
        vx[i] = (where( new_time eq flare_times[i] ))[0]

    ;win = GetWindows( /current, NAMES=window_names )
    ;print, window_names
    ;result = win.GetSelect()


    for ii = 0, n_elements(graphic)-1 do begin
        for jj = 0, n_elements(vx)-1 do begin
            v = plot( $
                [ vx[jj], vx[jj] ], $
                overplot = graphic[ii], $
                yrange = (graphic[ii]).yrange, $
                ystyle = 1, $
                linestyle = linestyle[jj], $
                name = names[jj], $
                _EXTRA=e )
        endfor
    endfor

    if keyword_set(shaded) then begin

        for ii = 0, n_elements(graphic)-1 do begin

            yrange = (graphic[ii]).yrange

            v_shaded = plot ( $
                [ vx[0]-32, vx[0]-32, vx[-1]+32-1, vx[-1]+32-1 ], $
                [ yrange[0], yrange[1], yrange[1], yrange[0] ], $
                /overplot, ystyle=1, linestyle=6, $
                fill_transparency=50, $
                fill_background=1, $
                fill_color='light gray' )
            v_shaded.Order, /SEND_TO_BACK
        endfor
    endif


    return, v


end
