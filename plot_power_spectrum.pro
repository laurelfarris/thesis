

; May need to split this into one function that calculates
; frequency and power, and another that does the actual plotting.
; Also, if overplotting, wait to overplot vertical lines until
; very end, otherwise don't get full yrange.

function PLOT_POWER_SPECTRUM, $
    flux, cadence, $
    fmin=fmin, $
    fmax=fmax, $
    norm=norm, $
    _EXTRA=e

    common defaults
    ;win = getwindows()
    ;wx = 8.5
    ;wy = 3.0
    ;win = window( dimensions=[wx,wy]*dpi, /buffer )


    result = fourier2(flux, cadence, norm=norm)
    frequency = reform(result[0,*])
    power = reform(result[1,*])

    if not keyword_set(fmin) then fmin = min(frequency)
    if not keyword_set(fmax) then fmax = max(frequency)

    ind = where( frequency ge fmin AND frequency le fmax )
    frequency = frequency[ind]
    power = power[ind]

    xdata = 1000.*frequency
    ydata = power

    p = plot2( $
        xdata, $
        ydata, $
        xmajor = 7, $
        xtickformat = '(F0.2)', $
        name = 'max power = ' + strtrim(max(power),1), $
        xtitle='frequency (mHz)', $
        ytitle='power', $
        _EXTRA=e )

    ax = p.axes

    ;ax[0].tickname = strtrim( 1000.*ax[0].tickvalues )

    period = 1000./ax[0].tickvalues
    ax[2].tickname = strtrim( round(period), 1 )
    ax[2].title = 'period (seconds)'
    ax[2].showtext = 1


    fmin = 1./400 ; 2.5 mHz
    fmax = 1./50 ;  20 mHz

    f3 = 1000./180
    f6 = 1000./(2.*180)

    v = plot( [f3,f3], p.yrange, /overplot, linestyle=2 )
    v = plot( [f6,f6], p.yrange, /overplot, linestyle=2 )

    return, p

end
