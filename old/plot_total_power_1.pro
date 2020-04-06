


; Last modified:   08 April 2018
pro test1, z, map

    ;; map = 3D array of maps (x,y,t)
    ; This plots total power of each map, rather than calculating
    ; FT of total flux... is there a difference?

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
pro test2

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


; Last modified:   09 April 2018
pro test3, struc, z, dz, frequency, power

    ; Which routine should break flux down? Should sub-array be
    ; the input here? Or feed the indices and have this routine
    ; break flux into sub-array?
    ; Also to need to get sub-array of frequency and power.
    
    result = fourier2( indgen(dz), struc.cadence ) 
    frequency = reform( result[0,*] )
    period = 1./frequency

    ; Initialize power array
    x = n_elements( frequency )
    y = n_elements( z )
    power = fltarr(x,y)

    ; Calculate power starting at each frequency

    flux = struc.flux

    foreach i, z do begin

        result = fourier2( flux[i:i+dz-1], 24. ) 
        power[0,i] = reform( result[1,*] )

    endforeach

end
