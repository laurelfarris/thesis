;+
;- 19 June 2020
;-


;aia1600flux_X22 = A[0].flux
;aia1600flux_C30 = A[0].flux
;aia1600flux_M73 = A[0].flux


;----

@parameters
;- .RUN struc_aia

;----

cc = 0
dz = 150

;---

time = strmid( A[cc].time, 0, 5 )

;print, gstart
;print, where( time eq strmid(gstart,0,5) )
z2 = (where( time eq strmid(gstart,0,5) ))[0]
z1 = z2 - dz
z3 = z2 + dz
zind = [z1, z2, z3]

stop


;for ii = 0, n_elements(zind)-1 do begin
;    print, min( [ zind[ii] : zind[ii] + dz -1 ] )
;    print, max( [ zind[ii] : zind[ii] + dz -1 ] )
;    print, n_elements( [ zind[ii] : zind[ii] + dz -1 ] )
;endfor


;-----------------

fname = 'spectra_' + ['before', 'during', 'after']   + '_' + class
for ii = 0, 2 do print, fname[ii]

dw
for ii = 0, n_elements(zind)-1 do begin
    flux = (A[cc].flux[ zind[ii] : zind[ii]+dz-1]) / A[cc].exptime
    PLOT_FOURIER2, flux, A[cc].cadence, $
        frequency, power, $
        /seconds, $
        /make_plot, /buffer, norm=0
    save2, fname[ii]
endfor

;-----------------

frequency = fltarr(75, 3)
power = fltarr(75, 3)
for ii = 0, n_elements(zind)-1 do begin
    flux = (A[cc].flux[ zind[ii] : zind[ii]+dz-1]) / A[cc].exptime
    result = fourier2( flux, A[cc].cadence )
    frequency[*,ii] = reform(result[0,*])
    power[*,ii] = reform(result[1,*])
endfor

;- min/max frequency to plot (aka xrange)
;-   trim arrays BEFORE calling plotting subroutines...
;-   could also have subroutine do the trimming, either hardcoded with values
;-    used for my research (e.g. 3-minute period ALWAYS "period of interest")
;-    or set optional kw's in call to plotting routine...
;-  What is the better way??


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
