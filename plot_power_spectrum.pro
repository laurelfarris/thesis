

; if overplotting multiple data sets in the same set of axes,
; don't plot vertical lines until after, otherwise don't get full yrange,
; and dashed lines can plot on top of each other and looks like
; a solid line.

function PLOT_POWER_SPECTRUM, $
    frequency, power, $
    fmin=fmin, $
    fmax=fmax, $
    norm=norm, $
    _EXTRA=e

    common defaults
    ;win = getwindows()
    ;wx = 8.5
    ;wy = 3.0
    ;win = window( dimensions=[wx,wy]*dpi, /buffer )


    ;result = fourier2(flux, cadence, norm=norm)
    ;frequency = reform(result[0,*])
    ;power = reform(result[1,*])

    if not keyword_set(fmin) then fmin = min(frequency)
    if not keyword_set(fmax) then fmax = max(frequency)

    ind = where( frequency ge fmin AND frequency le fmax )
    frequency = frequency[ind]
    power = power[ind]

    p = plot2( $
        frequency, $
        power, $
        xmajor = 7, $
        ;name = 'max power = ' + strtrim(max(power),1), $
        xtitle='frequency (Hz)', $
        ytitle='power', $
        _EXTRA=e )

    ; convert from Hz to mHz
    ax = p.axes

    period_interest = [ 120, 180, 200 ]
    f = 1./period_interest

    v = PLOT_VERTICAL_LINES( f, p.yrange, $
        names = strtrim(period_interest,1) + ' sec' )

    leg = LEGEND2( $
        target=[v], $
        /data, $
        position = 0.95*[ (p.xrange)[1], (p.yrange)[1] ] $
        )

    xtickvalues = ax[0].tickvalues
    n = n_elements(xtickvalues)

    period = 1./ax[0].tickvalues
    ax[2].tickname = strtrim( round(period), 1 )
    ax[2].title = 'period (seconds)'
    ax[2].showtext = 1

    ax[0].coord_transform=[0,1000.]
    ax[0].title='frequency (mHz)'
    ax[0].tickformat='(F0.2)'

    return, p

    ;fmin = 1./400 ; 2.5 mHz
    ;fmax = 1./50 ;  20 mHz
    ;f = [ 1000./180, 1000./(2.*180) ]
end
