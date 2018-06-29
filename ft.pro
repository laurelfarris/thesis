

; input: flux, cadence
; output: frequency, power
; kws: fmin and/or fmax if want only a certain range of frequencies returned


; band could be range of frequencies to show on x-axis for power spectrum,
; or narrow bandwidth to average over, centered at freq. of interest.
; --> Different routine for the latter.



pro CALC_FT, flux, cadence, $
    frequency, power, $
    fmin=fmin, fmax=fmax, $
    norm=norm;, $
   ; _EXTRA=e

    result = fourier2( flux, cadence, norm=norm )
    frequency = reform(result[0,*])
    power = reform(result[1,*])

    if not keyword_set(fmin) then fmin = frequency[ 0]
    if not keyword_set(fmax) then fmax = frequency[-1]

    ind = where(frequency ge fmin AND frequency le fmax)

    frequency = frequency[ind]
    power = power[ind]

    return
end
