;-
;
; input:    frequency, power
;              (fourier2.pro needs to be run before this)
; keywords: fmin, fmax - range of frequencies to show on x-axis


; if overplotting multiple data sets in the same set of axes,
; don't plot vertical lines until after, otherwise don't get full yrange,
; and dashed lines can plot on top of each other and looks like
; a solid line.

function PLOT_POWER_SPECTRUM, $
    frequency, power, $
    fmin=fmin, fmax=fmax, $
    label_period=label_period, $
    ;fcenter=fcenter, $
    ;bandwidth=bandwidth, $
    ;norm=norm, $
    ;time=time, $
    _EXTRA=e

    print, "Calling sequence: result = PLOT_POWER_SPECTRUM( $"
    print, "    frequencyfrequency, power, fmin=fmin, fmax=fmax, fcenter=fcenter, $"
    print, "    bandwidth=bandwidth, norm=norm, time=time )"

    common defaults

    if not keyword_set(fmin) then fmin = min(frequency)
    if not keyword_set(fmax) then fmax = max(frequency)

    ind = where( frequency ge fmin AND frequency le fmax )
    frequency = frequency[ind]
    power = power[ind]

    ;t = strtrim(time[*,i])
    p = PLOT2( $
        frequency, power, $
        /current, $
        ;xrange=[fmin,fmax], $
        ;xmajor = 7, $
        ;name = t[0] + '-' + t[-1]
            ; or could be same time range, but two different instruments....??
        xtitle = 'frequency (Hz)', $
        ytitle = 'power', $
        ;ytitle='log power', $
        _EXTRA=e )

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

    ;- convert frequency units: Hz --> mHz
    ;- SYNTAX: axis = a + b*data
    ax[0].coord_transform=[0,1000.]
    ax[0].title='frequency (mHz)'
    ax[0].tickformat='(F0.2)'

    return, p

    ;fmin = 1./400 ; 2.5 mHz
    ;fmax = 1./50 ;  20 mHz
    ;f = [ 1000./180, 1000./(2.*180) ]
end

; 24 September 2018

fmin = 0.0025
fmax = 0.02

;- dz = (30 min * 60 sec/min) / cadence
;dz = (30. * 60.) / 24.
times = ['12:30', '01:30', '02:30', '03:30']
titles = ['Before', 'During', 'After']

wx = 8.5
wy = 3.0
win = window( dimensions=[wx,wy]*dpi, buffer=0 )

cols = 3
rows = 1

for ii = 0, n_elements(times)-2 do begin

    p = objarr(3)
    for cc = 0, n_elements(p)-1 do begin

        t1 = where( A[cc].time eq times[ii] )
        t2 = where( A[cc].time eq times[ii+1] ) - 1
        flux = A[cc].flux[t1:t2]

        result = fourier2( flux, A[cc].cadence, norm=0 )
        frequency = reform( result[0,*] )
        power = reform( result[1,*] )

        p[cc] = PLOT_POWER_SPECTRUM( $
            frequency, power, $
            fmin=fmin, fmax=fmax, $
            overplot = cc<1, $
            layout = [cols, rows, ii+1], $
            color=A[cc].color, $
            name=A[cc].name )
    endfor


endfor

leg = LEGEND2( $
    target = p[0], $
    /data, $
    position = 0.95*[ (p.xrange)[1], (p.yrange)[1] ] )

end
