

    fcenter =
    bandpass = 0.001
    fmin = fcenter - bandpass/2.
    fmax = fcenter + bandpass/2.
    result = fourier2( flux, cadence, norm=0 )
    frequency = reform(result[0,*])
    power = reform(result[1,*])
    ind = where(frequency ge fmin and frequency le fmax)
    frequency = frequency[ind]
    power = power[ind]
