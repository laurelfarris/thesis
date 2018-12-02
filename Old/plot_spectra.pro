;- 21 November 2018
;
; input:    frequency, power
;              (fourier2.pro needs to be run before this)
; keywords: fmin, fmax - range of frequencies to show on x-axis


; if overplotting multiple data sets in the same set of axes,
; don't plot vertical lines until after, otherwise don't get full yrange,
; and dashed lines can plot on top of each other and looks like
; a solid line.

;- Eventually: Call BDA_structures.pro first, then input structure into plotting routine.

;- Better to trim frequency and power to desired range before inputting into
;- plotting routine? In that case, entire range would be plotted, and if only
;- want to show a portion of the frequency range, crop the arrays before
;- calling this routine... dunno.

function PLOT_SPECTRA, $
    frequency, power, $
    fmin=fmin, fmax=fmax, $
    fcenter=fcenter, $
    bandwidth=bandwidth, $
    period=period, $
    norm=norm, $
    time=time, $
    quiet=quiet, $
    _EXTRA=e

    if not keyword_set(quiet) then begin
        print, ""
        print, "Calling sequence:"
        print, "    result = PLOT_POWER_SPECTRUM( $"
        print, "        frequency, power, fmin=fmin, fmax=fmax, fcenter=fcenter, $"
        print, "        label_period=label_period, $"
        print, "        bandwidth=bandwidth, norm=norm, time=time )"
        print, "Set kw 'quiet' to suppress syntax help."
    endif

    ;- Graphics
    common defaults

    cols = 1
    rows = 1

    left = 1.0
    right = 1.0
    bottom = 0.5
    top = 0.5

    wx = 8.0
    wy = 3.0
    width = wx - (left+right)
    height = wy - (top+bottom)
    win = window( dimensions=[wx,wy]*dpi, buffer=1 )

    if not keyword_set(fmin) then fmin = min(frequency)
    if not keyword_set(fmax) then fmax = max(frequency)
    ind = where( frequency ge fmin AND frequency le fmax )
    frequency = frequency[ind]
    power = power[ind]

    ;for jj = 0, n_tags(struc)-1 do begin
        jj = 0

        position = GET_POSITION( layout=[cols,rows,jj+1] )

        ;frequency = struc.(jj).frequency
        sz = (size(frequency,/dimensions))
        plt = objarr(sz[1])

        for ii = 0, n_elements(p)-1 do begin

            ;t = strtrim(time[*,i])
            plt = PLOT2( $
                frequency[*,ii], $
                power[*,ii], $
                /current, $
                overplot = ii<1, $
                /device, $
                position = position*dpi, $
                ;xmajor = 7, $
                ;name = struc.(jj).names[ii], $
                xtitle = 'frequency (Hz)', $
                ytitle = 'power', $
                _EXTRA=e )
        endfor

        if (p.ylog eq 1) then p.ytitle = 'log power'

        ;- Extra stuff to add to individual panel:

        ax = plt.axes

        if keyword_set(period) then begin
            ax[2].showtext = 1
            ax[2].title = 'period (seconds)'

            ;- Kind of going in circles, but want to label ticks using actual values,
            ;- not manually setting equal to period array, which could lead to errors,
            ;-  e.g. frequency and period both increasing in the same direction...
            ;ax[2].tickvalues = 1./[120, 180, 200]
            ax[2].tickvalues = 1./period
            ax[2].tickname = strtrim( round(1./(ax[2].tickvalues)), 1 )
        endif

        ;- convert frequency units: Hz --> mHz AFTER placing period markers
        ;- in the correct position, based on original frequency values.
        ;- SYNTAX: axis = a + b*data
        ax[0].coord_transform=[0,1000.]
        ax[0].title='frequency (mHz)'
        ax[0].tickformat='(F0.2)'

    ;endfor

    leg = LEGEND2( $
        target = plt, $
        /data, $
        position = 0.95*[ (plt.xrange)[1], (plt.yrange)[1] ] )
end
