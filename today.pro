;+
;- 14 November 2019
;-



cadence = 24


flux = A[0].flux - (moment(A[0].flux))[0]

;result = fourier2( flux, cadence )
;freq = result[0,*]
;power = result[1,*]
;phase = result[2,*]
;amp = result[3,*]


PLOT_FOURIER2, flux, cadence, result, freq, power, phase, amp, $
    buffer=1

save2, 'fourier2_plots', /stamp, idl_code='plot_fourier2.pro'
end
