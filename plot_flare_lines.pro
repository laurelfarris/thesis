

function PLOT_FLARE_LINES, time, yrange


    ;; Add way to get X data from current graphic;
    ;; may not necessarily be in indgen(N) coordinates...

    flare_times = [ '01:44', '01:56', '02:06' ]
    names = flare_times + [ ' (start)', ' (peak)', ' (end)' ]
    N = n_elements(flare_times)
    vx = intarr(N)

    ; Need to make sure time is in form 'hh:mm', not 'hh:mm:ss.dd'...
    for i = 0, N-1 do $
        vx[i] = (where( time eq flare_times[i] ))[0]

    ;win = getwindows()
    ;win.Select, /ALL
    v = PLOT_VERTICAL_LINES( $
        vx, $
        yrange, $
        names=names, $
        linestyle=[4,5,4] )

    return, v


end
