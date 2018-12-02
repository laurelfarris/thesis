

;- Last modified:   25 November 2018
;-  --> Made a few changes to use this with GOES data:
;-       no time array from AIA

;- Currently has hardcoded values for Sep 15, 2011 flare.

;- To do:   Need to go straight from time string to jd and vice versa.


pro OPLOT_FLARE_LINES, $
    plt, $
    t_obs=t_obs, $
    jd=jd, $
    ;target=target, $
    shaded=shaded, $
    goes=goes, $
    ;yrange=yrange, $
    send_to_back=send_to_back, $
    _EXTRA=e



    if keyword_set(goes) then begin
        ;- For plotting GOES data:
        x_indices = fltarr(3)
        flare_times = '15-Feb-2011 ' + [ '01:44:00', '01:56:00', '02:06:00' ]

        ;- Hardcoded this on the fly, but should be user-defined/input value.
        utbase = '15-Feb-2011 00:00:01.725'

        ;- input 7xN array, get msod and ds79
        ;-   (needed for int2secarr routine).
        ex2int, anytim2ex(utbase), msod_ref, ds79_ref

        for ii = 0, 2 do begin
            ex2int, anytim2ex(flare_times[ii]), msod, ds79
            x_indices[ii] = int2secarr( [msod,ds79], [msod_ref,ds79_ref] )
        endfor
    endif


    ;- AIA light curves

    flare_times = [ '01:44', '01:56', '02:06' ]
    name = flare_times + [ ' UT (start)', ' UT (peak)', ' UT (end)' ]
    nn = n_elements(flare_times)
    time = strmid( t_obs, 0, 5 )
    x_indices = intarr(nn)

    for ii = 0, nn-1 do $
        x_indices[ii] = (where( time eq flare_times[ii] ))[0]

    ;- Not sure what these lines are for... can probably delete.
    ;Result = JULDAY( Month, Day, Year, Hour, Minute, Second)
    ;win = GetWindows( /current, NAMES=window_names )
    ;win.Select, /all
    ;result = win.GetSelect()

    plt[0].GetData, xx, yy ;- only needed when xdata = jd... I think.
    yrange = plt[0].yrange
    vert = objarr(nn)
    linestyle = [1,2,4]

    foreach vx, x_indices, jj do begin
        vert[jj] = plot( $
            [ xx[vx], xx[vx] ], $
            ;[ vx, vx ], $
            yrange, $
            /current, $
            /overplot, $
            ;overplot = plt[0], $
            thick = 0.5, $
            linestyle = linestyle[jj], $
            ystyle = 1, $
            name = name[jj], $
            color = 'black', $
            _EXTRA=e )
        ;if keyword_set(send_to_back) then vert[jj].Order, /SEND_TO_BACK
        vert[jj].Order, /SEND_TO_BACK
    endforeach

    ; . . . . . . . . . . .
    vert[0].linestyle = [1, '1111'X]

    ; ....................
    ;vert[0].linestyle = [1, '5555'X]


    ; __  __  __  __  __
    ;vert[1].linestyle = [1, 'F0F0'X]
    ;vert[1].linestyle = [1, '6666'X]
    vert[1].linestyle = [1, '3C3C'X] ;- shift 'F0F0' so it's symmetric



    ; __ . __ . __ . __ . __ .
    ;vert[2].linestyle = [1, '4FF2'X]

    ; __ . . __ . . __ . . __
    ;vert[2].linestyle = [1, '23E2'X]

    ; ___ .. ___ .. ___ .. ___
    vert[2].linestyle = [1, '47E2'X]


    ; __  . . .  __  . . .  __
    ;vert[2].linestyle = [1, '48E2'X]


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
    ; 4FF2 --> symmetry

    ;- Dash dot dot dot
    ; 7C92


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
