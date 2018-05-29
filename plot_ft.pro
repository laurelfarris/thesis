; Last modified:   09 April 2018


function plot_ft, xdata, power, _EXTRA=e

    common defaults
    w = window( dimensions=[8.5,3]*dpi*1.2 )

    p = plot2(  $
        xdata, $
        power, $
        /current, $
        ;xtitle='frequency (mHz)', $
        xtitle='period (s)', $
        ytitle="Power", $
        ;xtickformat = '(F0.1)', $
        ;symbol='circle', $
        ;sym_filled=1, $
        ;sym_size=0.5, $
        xrange=[50,400], $
        xlog=1, $
        _EXTRA=e )

    ax = p.axes
    ;ax[0].tickvalues = [2:max(xdata):4]
    ;ax[0].tickvalues = [10,100,1000]

    ; Vertical lines at periods of interest
    v = [120, 180, 200]
    for i = 0, n_elements(v)-1 do $
        vert = plot( $
            [v[i],v[i]], $
            p.yrange, $
            /overplot, $
            ystyle=1, $
            linestyle='--')
    return, p

    ax = p[0].axes
    v = 1000./values
    ;ax[2].title = 'period (seconds)'
    ax[2].title = 'frequency (mHz)'
    ax[2].tickvalues = (1000./values)
    ax[2].tickname = strtrim( reverse(values), 1 )
    ax[2].showtext = 1
end


pro calc_ft

    time = strmid(aia1600.time,0,5)
    i1 = (where( time eq '01:30' ))[0]
    i2 = (where( time eq '02:30' ))[0]

    flux = aia1600.flux[i1:i2]

    f_min = 1./400
    f_max = 1./50

    result = fourier2( flux, 24, /norm )
    frequency = reform(result[0,*])
    power = reform(result[1,*])

    ind = where(frequency ge f_min AND frequency le f_max)
    frequency = frequency[ind]
    power = power[ind]
    period = 1./frequency

    ;p = plot_ft( 1000.*frequency, power )
end

resolve_routine, 'plot_ft', /is_function
p = plot_ft( period, power )


end
