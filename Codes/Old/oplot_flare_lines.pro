

;- Last modified:   17 November 2018

;- Currently has hardcoded values for Sep 15, 2011 flare.

;- To do:   Need to go straight from time string to jd and vice versa.


pro OPLOT_FLARE_LINES, $
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


    linestyle = [1,2, 4]

    foreach vx, x_indices, jj do begin
        vert[jj] = plot( $
            [ xx[vx], xx[vx] ], $
            yrange, $
            /current, $
            /overplot, $
            ;overplot = plt[0], $
            thick = 0.5, $
            ;linestyle = linestyle[jj], $
            ;LINESTYLE = linestyle[*,jj], $
            ystyle = 1, $
            name = name[jj], $
            color = 'dark gray', $
            _EXTRA=e )
        if keyword_set(send_to_back) then vert[jj].Order, /SEND_TO_BACK
    endforeach

    ; 1  0001
    ; 2  0010
    ; 3  0011
    ; 4  0100
    ; 5  0101
    ; 6  0110
    ; 7  0111

    ; C  1100
    ; D  1101
    ; E  1110
    ; F  1111


    ;- Dots:
    ; 1111 - spread out
    ; 5555 - closer together

    ;- Dashes
    ; 3333
    ; F0F0

    ;- Dash dot
    ; 7272

    ;- Dash dot dot (IDL doesn't have a linestyle option for this...)
    ; 7F92

    ;- Dash dot dot dot
    ; 7C92

    linestyle = [ $
        [1, '1111'X], $
        [2, '7C92'X], $
        [1, 'F0F0'X] ]


    ; Shaded region
    if keyword_set(shaded) then begin
        ;for ii = 0, n_elements(graphic)-1 do begin
            ;yrange = (graphic[ii]).yrange
            v_shaded = plot2( $
                [ vx[0]-32, vx[0]-32, vx[-1]+32-1, vx[-1]+32-1 ], $
                [ yrange[0], yrange[1], yrange[1], yrange[0] ], $
                /overplot, ystyle=1, linestyle=6, $
                fill_transparency=50, $
                fill_background=1, $
                fill_color='light gray' )
            v_shaded.Order, /SEND_TO_BACK
        ;endfor



        ;- Another way to shade:
        v_shaded = polygon( $
            [x1, x2, x2, x1], $
            [y1, y1, y2, y2], $
            /data, $
            linestyle = 4, $
            fill_background = 0, $
            fill_color='light gray' )
        v_shaded.Order, /send_to_back

    endif


        


    plt = [ plt, vert ]
    ;return, vert
end
