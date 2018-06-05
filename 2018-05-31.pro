

;; Played with filtering data (didn't work, I had no idea what
;;   I was doing).
;; Also tried a detrending method of subtracting a running average
;;   over 3 points (one plus the two immediately adjacent), then
;;   over 5 ( i-2, i-1, ..., i+2 ).
;; Meeting on 01 June 2018 - detrending not necessary;
;;   shouldn't change numbers.


; Always give input in frequencies (Hz), e.g. vert = 1./[180,300]



pro calc_ft, flux, period, power

    ;t = strmid(time,0,5)
    ;i1 = (where( t eq '01:30' ))[0]
    ;i2 = (where( t eq '02:30' ))[0]
    ;flux = flux[i1:i2]

    result = fourier2( flux, 24, /norm )
    frequency = reform(result[0,*])
    power = reform(result[1,*])
    stop

    f_min = 1./400
    f_max = 1./50

    ind = where(frequency ge f_min AND frequency le f_max)
    frequency = frequency[ind]
    power = power[ind]
    period = 1./frequency
end


function plot_ft, frequency, power, $
    vert=vert, _EXTRA=e

    common defaults

    w = window(dimensions=[8.5,3.0]*dpi)

    p = plot2(  $
        frequency, $
        power, $
        /current, $
        xtitle = 'frequency (Hz)', $
        ytitle='Power', $
        color='dark cyan', $
        ;xtickformat = '(F0.1)', $
        ;symbol='circle', $
        ;sym_filled=1, $
        ;sym_size=0.5, $
        ;xrange=[50,400], $
        ;xlog=1, $
        _EXTRA=e )

    period = 1./frequency


    ax = p.axes
    ;v = 1000./values
    values = ax[0].tickvalues
    ax[2].tickname = strtrim( fix(1./values), 1 )
    ;ax[2].tickname = strtrim( reverse(values), 1 )
    ax[2].title = 'period (s)'
    ax[2].showtext = 1

    ; Vertical lines at periods of interest
    ;if keyword_set(vert) then begin
    v = objarr(n_elements(vert))
    for i = 0, n_elements(vert)-1 do $
        v[i] = plot( $
            [vert[i],vert[i]], $
            p.yrange, $
            /overplot, $
            ystyle=1, $
            linestyle=i+1, $
            name=strtrim( fix(1./vert[i]),1) + ' sec' $
            )
    leg = legend2(target = v, position = [0.9,0.8])
    return, p

end

goto, start

; Time
t = strmid(A[0].time,0,5)
i1 = (where( t eq '01:30' ))[0]
i2 = (where( t eq '02:30' ))[0]
flux = A[0].flux[i1:i2]

n = n_elements(flux)
avg = fltarr(n)

for i = 3, n-4 do $
    avg[i] = mean([flux[i-2:i+2]])

flux = flux[3:n-4]
avg = avg[3:n-4]
diff = flux - avg

w = window( dimensions=[8.5, 5.0]*dpi )
p = plot2( flux, /current, layout=[1,2,1], stairstep=1, color='red')
p = plot2( avg, /overplot, linestyle='--' )
p = plot2( diff, /current, layout=[1,2,2] )


w = window( dimensions=[8.5, 5.0]*dpi )
calc_ft, flux, period, power
p = plot_ft( period, power, current=1, layout=[1,2,1], $
    title = 'Flux' $
)

calc_ft, diff, period, power
p = plot_ft( period, power, current=1, layout=[1,2,2], $
    title = 'Detrended' $
)

start:;------------------------------------------------------------------------------
result = fourier2( flux, 24 )
frequency = result[0,*]
power = result[1,*]
result2 = fft( power[8:*], /inverse )

stop

flux = reform(flux, 1, n_elements(flux))

filter = bandpass_filter(flux, 1./400, 1./50 )
p = plot2(flux)
p = plot2( filter[0,*], /overplot, color='red' )

filter = bandpass_filter(flux, 1./400, 1./50, /ideal )
p = plot2(flux)
p = plot2( filter[0,*], /overplot, color='red' )

filter = bandpass_filter(flux, 1./400, 1./50, /Gaussian )
p = plot2(flux)
p = plot2( filter[0,*], /overplot, color='red' )

filter = bandpass_filter(flux, 1./400, 1./50, Butterworth=5 )
p = plot2(flux)
p = plot2( filter[0,*], /overplot, color='red' )


end
