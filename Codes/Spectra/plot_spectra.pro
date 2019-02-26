;- 28 November 2018
;


function PLOT_SPECTRA, frequency, power, label=label, _EXTRA=e

    ;win = GetWindows(/current)
    ;if win eq !NULL then $
        ;win = window( dimensions=[8.0,4.0]*dpi, location=[500,0] )

    ;- Frequency and power should already be trimmed
    ;- to desired axis ranges...

    ;flux = A.flux

    ;fmin = 0.002
    ;fmax = 0.02
    ;CALC_FOURIER2, flux, 24, frequency, power, fmax=fmax, fmin=fmin


    ;- Call general, single-panel plotting routine
    resolve_routine, 'batch_plot', /either
    plt = BATCH_PLOT( $
        frequency, power, $
        xtitle = 'frequency (Hz)', $
        ytitle = 'power', $
        _EXTRA=e )
    ;help, plt --> 1 element so far...


    ;-----------------------------------------------
    ax = plt[0].axes

    ;- oplot vertical lines at periods of interest.
    period = [120, 180, 200]

    vert = objarr(n_elements(period))
    foreach xx, period, ii do begin
        vert[ii] = plot2( $
            1./[xx,xx], plt[0].yrange, /overplot, $
            ystyle=1, linestyle=ii+1, thick=0.5, $
            name=strtrim(period[ii],1) + ' seconds')
        vert[ii].Order, /send_to_back
    endforeach
    plt = [ plt, vert ]

    if keyword_set(label) then begin
        ax[2].tickvalues = 1./period
        ax[2].tickname = strtrim( round(1./(ax[2].tickvalues)), 1 )
        ax[2].title = 'period (seconds)'
        ax[2].showtext = 1
    endif


    ;- convert frequency units: Hz --> mHz AFTER placing period markers
    ;- in the correct position, based on original frequency values.
    ;- SYNTAX: axis = a + b*data
    ax[0].coord_transform=[0,1000.]
    ax[0].title='frequency (mHz)'
    ax[0].major=7
    ax[0].tickformat='(F0.2)'


    resolve_routine, 'legend2', /either
    leg = LEGEND2( $
        sample_width=0.30, $
        /lowerright, $
        target=plt )

    return, plt
end