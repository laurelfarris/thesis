;+
;- 27 August 2019
;-
;- Test:
;-   Fourier power P(\nu) where dt(enhancement) << dt(input signal)
;-
;-
;-






    norm = 0
    buffer = 1

    ;- inst. cadence
    cadence = 24.

    ;- Total duration of signal
    obs_minutes = 30
    time = findgen(obs_minutes)
    nn = n_elements(time)

    dt = obs_minutes * 60.  ; min --> sec


    ;- number of samples (data points, or observations)
    n_obs = dt/cadence

    ;-

    ;- number of 3-minute cycles in t-segment
    ;n_cycles = dt/180.
    n_cycles = 3

    ;xx = findgen(n_obs)
    ;xx = (xx/max(xx)) * (2*!PI)
    xx = (findgen(n_obs) / (n_obs-1) ) * (2*!PI)
        ;- n_obs-1 gives xx[-1] = 1.00000 instead of, e.g. 0.98667

    y = fltarr(n_elements(xx))

    ;- amplitude
    amp = 1.0

    ;- phase shift
    ;phi = !PI/4
    phi = 0.0


    ;- oscillatory signal

    y = amp * sin( ( xx*n_cycles ) + phi )
    ;plt = plot2(y)


    nn2 = nn*100
    flux = fltarr(nn2)
    flux[0] = sin( xx * n_cycles )
    flux[nn2/2] = 0.5 * sin( xx * n_cycles*4 )
    ;flux[nn/2] = y/2

;    plt = plot2( flux, buffer=0, $
;        xtitle = 'time', ytitle = 'flux' )

    win = getwindows(/current)
    wdim = win.dimensions


    ;- Fourier transform --> power spectra

    result = fourier2( flux, cadence )
    frequency = result[0,*]
    power = result[1,*]
    power2 = max(power)
;    plt = plot2( frequency, power, buffer=0, location=[wdim[0],0], $
;        xtitle = 'frequency', ytitle = 'power' )



end
