;+
;- 14 November 2019
;-



cadence = 24


flux = A[0].flux - (moment(A[0].flux))[0]
nn = n_elements(flux)

v = FFT( flux )


result = fourier2( flux, cadence )

freq = result[0,*]
power = result[1,*]
phase = result[2,*]
amp = result[3,*]

end
