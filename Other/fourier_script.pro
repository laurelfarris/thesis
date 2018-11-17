
;- 02 November 2018

;- @fourier_script inside subroutine, or :r to read in text

cadence = 24

result = fourier2( flux, cadence, NORM=NORM )
frequency = reform(result[0,*])
power = reform(result[1,*])


fcenter = 1./180
bandwidth = 0.001

fmin = fcenter - bandwidth/2.
fmax = fcenter + bandwidth/2.

ind = where( frequency ge fmin AND frequency le fmax )
frequency = frequency[ind]
power = power[ind]
