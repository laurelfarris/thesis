;Copied from clipboard


;-
;- divide by 1000 to convert to Hz
;fmin = 1.0 / 1000.
;fmax = 10. / 1000.
;-
;- select min/max PERIOD (seconds), convert to freqeuncy (Hz)
fmin = 1./400.
fmax = 1./100.
;-
ind = where( frequency[*,0] ge fmin AND frequency le fmax )
;-
;-
dw
resolve_routine, 'plot_spectra', /either
plt = PLOT_SPECTRA( $
    frequency[ind,*], power[ind,*], $
    name = ['before', 'during', 'after'], $
    ;xrange = [1.5, 10.0]/1000., $
    leg=leg, /buffer )
;-
;-
tx = 0.8
ty = 0.8
resolve_routine, 'text2', /either
flare = TEXT2( tx, ty, class + ' ' + date )
;-
;-
save2, 'spectra_BDA_' + class

end

