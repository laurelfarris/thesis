; Last modified:   05 June 2018

; Plot power spectrum
;  power = P(freq), freq in Hz


function PLOT_SPECTRUM, frequency, power, $
    _EXTRA=e

    common defaults

    win = window(dimensions=[8.5,3.0]*dpi)

    p = plot2(  $
        frequency, $
        power, $
        /current, $
        xtitle = 'frequency (Hz)', $
        ytitle='Power', $
        _EXTRA=e )

        ax = p.axes
        ax[2].showtext = 1
        ax[2].title = 'period (s)'

        period = 1./(ax[0].tickvalues)
        ax[2].tickname = strtrim( fix(period), 1 )

        ;period = [180, 300]
        ;ax[2].tickvalues = 1./period

    return, p
end
