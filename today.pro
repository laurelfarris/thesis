
    ;- 02 November 2018
;
; input:    frequency, power
;              (fourier2.pro needs to be run before this)
; keywords: fmin, fmax - range of frequencies to show on x-axis
function PLOT_SPECTRA, $
    frequency, power, $
    fmin=fmin, fmax=fmax, $
    label_period=label_period, $
    fcenter=fcenter, $
    bandwidth=bandwidth, $
    norm=norm, $
    time=time, $
    syntax_help=syntax_help, $
    _EXTRA=e

    if keyword_set(syntax_help) then begin
        print, ""
        print, "Calling sequence:"
        print, "    result = PLOT_POWER_SPECTRUM( $"
        print, "        frequency, power, fmin=fmin, fmax=fmax, fcenter=fcenter, $"
        print, "        label_period=label_period, $"
        print, "        bandwidth=bandwidth, norm=norm, time=time )"
        return, 0
    endif

    common defaults
    ;- Graphics

    wx = 8.0
    wy = 3.0
    dw

    cols = 1
    rows = 1

    left = 1.0
    right = 1.0
    bottom = 0.5
    top = 0.5

    width = wx - (left+right)
    height = wy - (top+bottom)

    win = window( dimensions=[wx,wy]*dpi, buffer=1 )

    ;- Fourier stuff

    ;fmin = 1./400 ; 2.5 mHz
    ;fmax = 1./50 ;  20 mHz
    ;f = [ 1000./180, 1000./(2.*180) ]

    fmin = 0.0025
    fmax = 0.02

    if not keyword_set(fmin) then fmin = min(frequency)
    if not keyword_set(fmax) then fmax = max(frequency)
    ind = where( frequency ge fmin AND frequency le fmax )
    frequency = frequency[ind]
    power = power[ind]

    for ii = 0, n_elements(p)-1 do begin

        ;t = strtrim(time[*,i])
        p = PLOT2( $
            frequency[*,ii], $
            power[*,ii], $
            /current, $
            /device, $
            overplot = ii<1, $
            position = position*dpi, $
            ;xmajor = 7, $
            name = struc.(jj).names[ii], $
            xtitle = 'frequency (Hz)', $
            ytitle = 'power', $
            _EXTRA=e )
    endfor

    if (p.ylog eq 1) then p.ytitle = 'log power'

    ;- Extra stuff to add to individual panel:

    ax = p.axes

    if keyword_set(label_period) then begin
        ax[2].showtext = 1
        ax[2].title = 'period (seconds)'

        ;- Kind of going in circles, but want to label ticks using actual values,
        ;- not manually setting equal to period array, which could lead to errors,
        ;-  e.g. frequency and period both increasing in the same direction...
        ax[2].tickvalues = 1./[120, 180, 200]
        ax[2].tickname = strtrim( round(1./(ax[2].tickvalues)), 1 )
    endif

    ;- convert frequency units: Hz --> mHz AFTER labeling period.
    ;- SYNTAX: axis = a + b*data
    ax[0].coord_transform=[0,1000.]
    ax[0].title='frequency (mHz)'
    ax[0].tickformat='(F0.2)'

    leg = LEGEND2( $
        target = p[0], $
        /data, $
        position = 0.95*[ (p.xrange)[1], (p.yrange)[1] ] )

    return, p

    for ii = 0, n_elements(times)-2 do begin

        p = objarr(3)
        for cc = 0, n_elements(p)-1 do begin

            t1 = where( A[cc].time eq times[ii] )
            t2 = where( A[cc].time eq times[ii+1] ) - 1

            n_pixels = 330.*500.
            flux = A[cc].flux[t1:t2]
            flux = (A[cc].flux[t1:t2])/n_pixels

            result = fourier2( flux, A[cc].cadence, norm=0 )
            frequency = reform( result[0,*] )

            power = reform( result[1,*] )
            power = (reform( result[1,*] )) / n_pixels
            print, min(power)
            print, max(power)

        endfor
    endfor
end

N = 500.*330.

result = fourier2( A[0].flux/N, 24 )
frequency = reform( result[0,*] )

power1 = reform( result[1,*] )

result = fourier2( A[0].flux, 24 )
power2 = (reform( result[1,*] ))/N

;plt = plot_spectra()

win = window(/buffer)
p = plot2( frequency, power1, /current, layout=[1,1,1], margin=0.1, ylog=1 )
p = plot2( frequency, power2, /overplot, color='blue', ylog=1 )

file = 'test'
save2, file

end
