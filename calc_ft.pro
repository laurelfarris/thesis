

; TO-DO: issue with freq[1] - freq[0] = resolution if freq only has one value
;  20 July 2018 - moved line to calculate resolution BEFORE cropping frequency,
;    since spacing should be the same over the entire array (if not, something
;    was not calculated correctly).

; input: flux, cadence
; output: frequency, power
; kws: fmin and/or fmax if want only a certain range of frequencies returned

; 29 June 2018
; return structure with output from fourier2.pro, along with every
; quantity of interest I could think of.


function CALC_FT, $
    flux, $
    cadence, $
    fmin=fmin, $
    fmax=fmax, $
    norm=norm, $
    _EXTRA=e

    result = fourier2( flux, cadence, norm=norm )
    frequency = reform(result[0,*])
    power = reform(result[1,*])
    ;print, 'frequency resolution = ', strtrim(1000*resolution,1), ' mHz'
    resolution = frequency[1] - frequency[0]

    if not keyword_set(fmin) then fmin = frequency[ 0]
    if not keyword_set(fmax) then fmax = frequency[-1]

    ind = where(frequency ge fmin AND frequency le fmax)
    frequency = frequency[ind]
    power = power[ind]

    ;print, 'frequencies (mHz):'
    ;print, frequency*1000, format='(F0.2)'


    struc = { $
        frequency : frequency, $
        bandpass : [fmin,fmax], $
        bandwidth : fmax - fmin, $
        resolution : resolution, $
        power : power, $
        mean_power : mean(power) $
        }

    ;help, struc
    return, struc

    response = ''
    READ, response, prompt='Plot power spectrum? [y/n] '
    ;if response eq 'y' then begin
    ;endif

end
