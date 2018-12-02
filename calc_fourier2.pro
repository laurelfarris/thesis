
;- Need to define flux (and maybe fmin and fmax)
;-  at level where batch file is called.


;- This is mostly for power maps, not spectra:
;fcenter = 1./180
;bandwidth = 0.001
;fmin = fcenter - (bandwidth/2.)
;fmax = fcenter + (bandwidth/2.)
pro CALC_FOURIER2, $
    flux, cadence, $
    frequency, power, $
    ;fcenter=fcenter, bandwidth=bandwidth, $
    fmax=fmax, fmin=fmin

    ;fmin = fcenter - bandwidth/2. 
    ;fmax = fcenter + bandwidth/2. 

    ;sz = size(flux)
    ;if sz[0] le 1 then flux = reform(flux, sz[1], 1, /overwrite)

    sz = size( flux, /dimensions )
    if n_elements(sz) eq 1 then begin
        flux = reform(flux, sz[0], 1, /overwrite)
        sz = size( flux, /dimensions )
    endif

    result = fourier2( indgen(sz[0]), 24 )
    frequency = reform(result[0,*])

    if not keyword_set(fmin) then fmin = min(frequency)
    if not keyword_set(fmax) then fmax = max(frequency)
    ind = where(frequency ge fmin and frequency le fmax)
    frequency = frequency[ind]

    power = fltarr( n_elements(frequency), sz[1] )

    for ii = 0, sz[1]-1 do begin

        result = fourier2( flux[*,ii], 24 )
        power[*,ii] = (reform(result[1,*]))[ind]

    endfor
end
