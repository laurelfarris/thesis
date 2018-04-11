;; Last modified:   14 March 2018


pro plot_lc

    ; Must these all be done at once?
    ; Esp. since I have to sit and wait for the entire code to
    ; finish even when I can already tell it's wrong.
    p = objarr(2)
    sm = objarr(2)
    background = objarr(2)

    dpi = 96
    win = window( dimensions=[12.0, 4.0]*dpi )

    for i=0,1 do begin

        ; Adjust to be normalized relative to 1.0
        x = indgen( n_elements(s.(i).jd) )
        y = s.(i).flux
        y = y-min(y)
        y = y/max(y)

        if i eq 0 then begin
            graphic = plot2( x, y, /nodata, $
                ;position=pos[*,i], $
                layout=[1,1,1], $
                margin=1.0*96, $
                /current, $
                /device, $
                xtickinterval=75, $
                xrange = xrange, $
                ;yrange = yrange, $
                xtitle = "Start time (15-Feb-11 00:00:00)", $
                ytitle = "Normalized Intensity" $
            )
        endif

        ; Set as relative to graphic dimensions?
        ;graphic.xticklen = 0.04, $
        ;graphic.yticklen = 0.01, $

        p[i] = plot( $
            x, y, $
            /overplot, $
            stairstep=1, $
            color=s.(i).color, $
            name=s.(i).name )
        ;p.select, /add


        stop

        smooth_flux = smooth(y,8)
        sm[i] = plot( $
        ;sm = plot( $
            x, smooth_flux, $
            /overplot, $
            linestyle='--', $
            thick=1.0, $
            name="boxcar smoothed")

        bg = mean(y[0:200])
        background[i] = plot( $
        ;background = plot( $
            p[i].xrange, $
            ;p.xrange, $
            [bg,bg], $
            /overplot, $
            linestyle=':', $
            thick=1.0, $
            name="pre-flare background")

    endfor
    ;sm.select, /add
    ;background.select, /add
    ;graphic.window.select, /all
    ;sm[1].select, /unselect
    ;background[1].select, /unselect

    leg = legend( $
        ;target=[ p.window.select, /all ], $
        target=[ p[0], p[1], sm[0], background[0] ], $
        position=pos[2:3]+[0.0,-15.0], $
        _EXTRA=legend_props )


    ;; Plot vertical lines for flare start/stop
    ;;  Consider shading the region instead of bordering with lines.
    flare_start = '01:30'
    flare_end   = '02:30'
    t1 = ( where( S.(0).time eq flare_start ) )[ 0]
    t2 = ( where( S.(0).time eq flare_end   ) )[-1]
    ;x = [ S.(0).jd[t1], S.(0).jd[t2] ]
    x = [ t1, t2 ]
    for i = 0, 1 do begin
        v = plot( $
            [ x[i], x[i] ], $
            graphic.yrange, $
            /overplot, $
            linestyle='-.', $
            thick=1.5 $
            )
    endfor

    ;; Label axes opposite time with corresponding image number
    ax = graphic.axes
    values = ax[0].tickvalues
    ax[0].tickname = S.(0).time[values]
    ax[2].minor=5
    ax[2].title="Image number"
    ax[2].showtext=1



end






pro testing_power_vs_time

    ;; Trying different ways of plotting power vs. time

    power = []
    for i = 0, 149 do begin
        subarr = fltarr(200)
        subarr[i:i+dz-1] = y2[i]
        power = [ [power], [subarr] ]
    endfor

    w = window( dimensions=[1500,800] )
    plt = plot2( indgen(200), power[*,i], /current, /nodata )
    for i = 0, 149 do begin
        plt = plot2( power[*,i], /overplot, linestyle=6, symbol='_' )
    endfor
    full_power = power[49:149,*]
    avg_pow = mean( full_power, dimension=2 )
    w = window( dimensions=[1500,800] )
    avg_pow = mean( power, dimension=2 )
    plt = plot2( avg_pow, /current )

end



function CREATE_PANELS, y

    pos = get_positions( width=8.0, height=4.0 )
    win = get_window( pos, margin=1.0 )
    graphic = plot2( y, /nodata, /current, /device, $
        xtickvalues=[0:199:25], $
        xtickname=S.(0).time[0:199:25], $
        xtitle='observation start time (2011 February 15)' $
    )
    return, graphic
end

pro plot_lc_or_power
    ; Maybe this is where structures would be handy
    ; (but probably only for me... not super intuitive, but would help
    ;   to separate the few lines that actually need to be tweaked,
    ;  and quickly tweak them).

    ; Plot lightcurve and/or power vs. time
    N = 2
    p = objarr(N)
    for i = 0, N-1 do begin

        y = S.(i).flux_norm
        ;y = total( total( S.(i).map, 1), 1 )

        ; Build window and axes
        if i eq 0 then graphic = CREATE_PANELS( y )
        graphic.ytitle='Normalized intensity'
        ;graphic.ytitle='3-minute power'

        ; Make actual plots
        p[i] = plot2( $
            y, /overplot, $
            stairstep=1, $
            color=S.(i).color, $
            name=S.(i).name )

    endfor

    leg = legend2( $
        target=[p[0],p[1]], $  ;; or don't use target... use something else.
        position=[0.9,0.9], /relative $
    )

end


; X-range for BEFORE only.
xrange = [0, where(S.(0).time eq '01:44')]

; Y-range for entire time series
yrange = [-0.1,1.1]
    

end
