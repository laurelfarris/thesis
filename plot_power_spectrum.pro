

; if overplotting multiple data sets in the same set of axes,
; don't plot vertical lines until after, otherwise don't get full yrange,
; and dashed lines can plot on top of each other and looks like
; a solid line.

function PLOT_POWER_SPECTRUM, $
    frequency, power, $
    fmin=fmin,  fmax=fmax, $  ; min/max freq on x-axis
    fcenter=fcenter, $  ; central frequency (interest)
    bandwidth=bandwidth, $  ; WIDTH centered at fcenter
    norm=norm, $
    time=time, $
    _EXTRA=e

    common defaults

    ;wx = 8.5
    ;wy = 3.0
    ;win = window( dimensions=[wx,wy]*dpi, /buffer )

    ;result = fourier2(flux, cadence, norm=norm)
    ;frequency = reform(result[0,*])
    ;power = reform(result[1,*])

    pz = size(power, /dimensions)
    N = n_elements(pz)
    if N eq 1 then pz = reform(pz, N, 1)

    if not keyword_set(fmin) then fmin = min(frequency)
    if not keyword_set(fmax) then fmax = max(frequency)

    ind = where( frequency ge fmin AND frequency le fmax )
    frequency = frequency[ind]
    power = power[ind]

    p = objarr(N)
    for i = 0, n_elements(p)-1 do begin
        t = strtrim(time[*,i])
        p = plot2( $
            frequency, $
            power, $
            ;xmajor = 7, $
            name = t[0] + '-' + t[-1]
                ; or could be same time range, but two different instruments....??
            xtitle='frequency (Hz)', $
            ytitle='log power', $
            _EXTRA=e )
    endfor

    ; convert from Hz to mHz
    ax = p.axes

    period_interest = [ 120, 180, 200 ]
    f = 1./period_interest

    leg = LEGEND2( $
        target=[p,v], $
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
