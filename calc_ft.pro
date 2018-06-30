

; input: flux, cadence
; output: frequency, power
; kws: fmin and/or fmax if want only a certain range of frequencies returned

; 29 June 2018
; return structure with output from fourier2.pro, along with every
; quantity of interest I could think of.


function CALC_FT, flux, cadence, $
    ;frequency, power, $
    fmin=fmin, fmax=fmax, $
    norm=norm;, $
    ;_EXTRA=e

    result = fourier2( flux, cadence, norm=norm )
    frequency = reform(result[0,*])
    power = reform(result[1,*])

    if not keyword_set(fmin) then fmin = frequency[ 0]
    if not keyword_set(fmax) then fmax = frequency[-1]

    ind = where(frequency ge fmin AND frequency le fmax)
    frequency = frequency[ind]
    power = power[ind]

    ;print, 'frequencies (mHz):'
    ;print, frequency*1000, format='(F0.2)'

    ; frequency resolution
    resolution = frequency[1] - frequency[0]
    ;print, 'frequency resolution = ', strtrim(1000*resolution,1), ' mHz'

    struc = { $
        frequency : frequency, $
        bandpass : [fmin,fmax], $
        bandwidth : fmax - fmin, $
        resolution : resolution, $
        power : power, $
        mean_power : mean(power) $
        }

    return, struc
end
