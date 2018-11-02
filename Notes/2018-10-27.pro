


;- 27 October 2018


;map = powermaps( A[0].data[*,*,16:79], 24, fcenter=1./50, bandwidth=1.0 )
dw
win = window(dimensions=[6.0,6.0]*dpi, /buffer)
im = image( aia_intscale(map, exptime=1.0, wave=1600), /current, /device, margin=0.5, layout=[1,1,1] )
save2, 'test.pdf'

stop


flux1 = A[0].flux[110:259]
line = (findgen(150)/150) * (max(flux1) - mean(flux1))

flux2 = flux1 + line

frequency = (fourier2( flux1, 24 ))[0,*]
power1 = (reform(fourier2( flux1, 24 )))[1,*]
power2 = (reform(fourier2( flux2, 24 )))[1,*]

dw
win = window(dimensions=[6.0,6.0]*dpi, /buffer)
ylog=0
plt = plot2( [110:259], flux1, /current, /device, layout=[1,1,1], ytitle='flux', margin=0.5*dpi, ylog=ylog )
plt = plot2( [110:259], flux2, /overplot, color='blue', ylog=ylog)
save2, 'test_lc.pdf'

dw
win = window(dimensions=[6.0,6.0]*dpi, /buffer)
ylog=1

;plt = plot2( flux+line, /current, /device, layout=[1,1,1], margin=0.5*dpi )
plt = plot2( frequency, power1, /current, /device, layout=[1,1,1],  $
    xtitle='frequency', ytitle='power', margin=0.5*dpi, ylog=ylog )
plt = plot2( frequency, power2, /overplot, /device, color='blue', ylog=ylog)
save2, 'test_ft.pdf'

stop


for ii = 100, 1000, 200 do begin


    result = fourier2(A[0].flux/ii, 24)
    print, max( result[1,*] )

endfor
end
