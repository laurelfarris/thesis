
;- Need to define flux (and maybe fmin and fmax)
;-  at level where batch file is called.


;- This is mostly for power maps, not spectra:
;fcenter = 1./180
;bandwidth = 0.001
;fmin = fcenter - (bandwidth/2.)
;fmax = fcenter + (bandwidth/2.)



;fmin = 0.001
;fmax = 0.010

result = fourier2( flux, 24 )
frequency = reform(result[0,*])
power = reform(result[1,*])
ind = where(frequency ge fmin and frequency le fmax)

frequency = frequency[ind]
power = power[ind]
