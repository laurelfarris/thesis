
;- Need to define flux (and maybe fmin and fmax)
;-  at level where batch file is called.


;- This is mostly for power maps, not spectra:
;fcenter = 1./180
;bandwidth = 0.001
;fmin = fcenter - (bandwidth/2.)
;fmax = fcenter + (bandwidth/2.)


pro CALC_FOURIER2, flux, cadence, frequency, power, fmax=fmax, fmin=fmin

    ;fmin = 0.001
    ;fmax = 0.010

    sz = size( flux, /dimensions )
    if n_elements(sz) eq 1 then sz = reform(sz, sz[0], 1, /overwrite)

    result = fourier2( indgen(sz[0]), 24 )

    frequency = reform(result[0,*])
    ind = where(frequency ge fmin and frequency le fmax)
    frequency = frequency[ind]

    power = fltarr( n_elements(frequency), sz[1] )
    for ii = 0, sz[1]-1 do begin
        result = fourier2( flux[*,ii], 24 )
        power[*,ii] = (reform(result[1,*]))[ind]

        ;frequency = frequency[ind]
        ;power = power[ind]

    endfor


end
