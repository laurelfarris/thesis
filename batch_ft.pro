
result = fourier2( flux, 24 )
frequency = reform(result[0,*])
power = reform(result[1,*])
ind = where(frequency ge fmin and frequency le fmax)

frequency = frequency[ind]
power = power[ind]
