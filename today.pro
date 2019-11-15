;+
;- 14 November 2019
;-



cadence = 24
cc = 0

;- Integrated flux over AR11158
;flux = ( A[cc].flux - (moment(A[cc].flux))[0] ) / A[cc].exptime
;flux = flux[100:250]


;- flux from a single pixel:

;- penumbra
flux = A[cc].data[368:372, 226:230, 100:250]

;- umbra
flux = A[cc].data[368:372, 214:218, 100:250]

flux = total( total( flux, 1), 1)


;-- center of AR
flux =  A[cc].data[250, 165, 225:400]



;flux = reform( A[cc].data[370, 216, 100:250] )

;result = fourier2( flux, cadence )
;freq = result[0,*]
;power = result[1,*]
;phase = result[2,*]
;amp = result[3,*]


dw
resolve_routine, 'plot_fourier2', /either
PLOT_FOURIER2, flux, cadence, result, freq, power, phase, amp, $
    make_plot=1, buffer=1

save2, 'fourier2_plots', /overwrite;, /stamp, idl_code='plot_fourier2.pro'

end
