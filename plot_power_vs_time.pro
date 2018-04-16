


; Last modified:   08 April 2018
pro plot_power_vs_time, z, map

    ;; map = 3D array of maps (x,y,t)

    win = window( dimensions=[1200, 800] )

    xdata = z
    ydata = total( total( map, 1), 1 )

    p = plot2( xdata, ydata, /current, $
        xtickvalues=[0:199:25], $
        xtickname=time[0:199:25], $
        xtitle='observation time (15 February 2011)', $
        ytitle='3-minute power' $
    )
end



; Last modified:   14 March 2018
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
