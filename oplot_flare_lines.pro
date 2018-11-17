

;- Last modified:   17 November 2018

;- Currently has hardcoded values for Sep 15, 2011 flare.

;- To do:   Need to go straight from time string to jd and vice versa.


function OPLOT_FLARE_LINES, $
    plt, $
    t_obs, $
    jd, $
    ;target=target, $
    shaded=shaded, $
    ;yrange=yrange, $
    send_to_back=send_to_back, $
    _EXTRA=e


    flare_times = [ '01:44', '01:56', '02:06' ]
    name = flare_times + [ ' UT (start)', ' UT (peak)', ' UT (end)' ]
    linestyle = [1,2,3]

    time = strmid( t_obs, 0, 5 )
    N = n_elements(flare_times)
    x_indices = intarr(N)
    for ii = 0, N-1 do $
        x_indices[ii] = (where( time eq flare_times[ii] ))[0]

    ;Result = JULDAY( Month, Day, Year, Hour, Minute, Second)

    ;win = GetWindows( /current, NAMES=window_names )
    ;win.Select, /all
    ;result = win.GetSelect()

    plt[0].GetData, xx, yy
    yrange = plt[0].yrange

    vert = objarr(N)
    foreach vx, x_indices, jj do begin
        vert[jj] = plot( $
            [ xx[vx], xx[vx] ], $
            yrange, $
            /current, $
            overplot=plt[0], $
            ystyle = 1, $
            linestyle = linestyle[jj], $
            thick = 1, $
            name = name[jj], $
            color = 'gray', $
            _EXTRA=e )
        if keyword_set(send_to_back) then vert[jj].Order, /SEND_TO_BACK
    endforeach

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
    return, vert
end
