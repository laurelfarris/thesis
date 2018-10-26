
pro ft, flux, cadence, frequency, power
    fcenter = 1./180
    bandwidth = 0.001
    fmin = fcenter - bandwidth/2.
    fmax = fcenter + bandwidth/2.
    result = fourier2( flux, cadence )
    frequency = reform(result[0,*])
    power = reform(result[1,*])
    ;ind = where( frequency ge fmin AND frequency le fmax )
    ;frequency = frequency[ind]
    ;power = power[ind]
end
