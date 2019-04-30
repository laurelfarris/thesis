pro FT, flux, cadence, frequency, power

    ;- Input flux and cadence.
    ;- Get frequency and power

    ;- NOTE: Difference between min/max frequency for displaying spectra P(\nu),
    ;-   vs. extracting just the power over a narrow bandwidth centered around
    ;-   the central frequency, e.g. used for P(t) plots

    ;- This is 'plot_spectra.pro' after all... so maybe stick to P(\nu)
    ;- considerations for now.

    result = fourier2( flux, cadence )
    frequency = reform(result[0,*])
    power = reform(result[1,*])

    return


    ;- bandwidth is more for extracing power centered on a particular frequency
    fcenter = 1./180
    bandwidth = 0.001
    fmin = fcenter - bandwidth/2.
    fmax = fcenter + bandwidth/2.
    ;ind = where( frequency ge fmin AND frequency le fmax )
    ;frequency = frequency[ind]
    ;power = power[ind]


end
