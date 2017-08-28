;; Last modified:   16 August 2017 14:01:07


@main
result = fourier2( a6_flux, aia_cad, /norm )
fr = result[0,*]
ps = result[1,*]

;print, n_elements(fr)

diff = fr - shift(fr, 1)
u = uniq(diff)

period = 1./fr
diff = period - shift(period, -1)
print, diff
u = uniq(diff)

end
