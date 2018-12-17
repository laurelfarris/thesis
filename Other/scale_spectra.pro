


;- 27 October 2018
;-
;- BDA power spectra from integrated emission, showing
;-  absolute values, log, normalized by max power (at whatever frequency),
;-  and also compare power from total emission to power from emission per pixel.

pro scale_spectra, flux, _EXTRA=e

    cadence = 24
    result = fourier2( flux, cadence )
    frequency = reform(result[0,*])
    power = reform(result[1,*])


    plt = plot_spectra( $
        frequency, power, fmin=1./400, fmax=1./50, period=[180], _EXTRA=e )
end

;- Main level: crop and scale flux in different ways

t_start = '01:30'
t_end = '02:30'

time = strmid(A[0].time,0,5)
ind = [ (where(time eq t_start))[0] : (where(time eq t_end))[0] ]

n_pix = 500.*330.

flux = [ [A[0].flux[ind]], [A[1].flux[ind]] ]

scale_spectra, flux, title = 'Integrated flux (DN s$^{-1}$)'

scale_spectra, flux/n_pix, title = 'Spatial mean (DN s$^{-1}$ pixel$^{-1}$)'

