;; Last modified:   31 May 2018 00:55:59



flux = A[0].flux
n = n_elements(flux)
avg = fltarr(n)

for i = 1, n-2 do $
    avg[i] = mean(flux[i-1:i+1])

flux = flux[1:n-2]

modulation_depth = ( flux - avg ) / avg

end
