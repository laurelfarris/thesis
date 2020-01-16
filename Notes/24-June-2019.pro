;+
;- 24 June 2019
;-


goto, start

n_pix = 500.*300.

;- P(t) plots for new flare
pow1 = total(total(A[0].map,1),1) / n_pix
pow2 = total(total(A[1].map,1),1) / n_pix
;- ... actually didn't intend to do this yet. Wanted power spectra, not P(t).


;- sloppy way of doing things:
;flux1 = total(total(A[0].data,1),1) / n_pix
;flux2 = total(total(A[1].data,1),1) / n_pix
;flux = [ [flux1], [flux2] ]


start:;-------------------------------------------------------------------------------
cadence = 24
sz = size(A.data, /dimensions)

;- TO DO:
;-   Compute FFTs for BDA times separately, not entire data series.
;-   Show all three time segments at once, for ONE channel!
;-   Display time ranges on plot somewhere: legend, title, axis titles, ...
;-   Specify min/max values on x-axis

zind = [0:260]

;- Initialize freq/power array variables
;frequency = fltarr( sz[2]/2, n_elements(A) )
frequency = fltarr( n_elements(zind)/2, n_elements(A) )
power = frequency

for cc = 0, n_elements(A)-1 do begin
    flux =  total(total(A[cc].data[*,*,zind],1),1) / n_pix
    result = fourier2(  flux , cadence, norm=0 )
    frequency[*,cc] = reform( result[0,*] )
    power[*,cc] = reform( result[1,*] )
endfor

stop

plt = plot_spectra( frequency, power, buffer=1 )

filename = 'newflare_bda_ffts'

save2, filename

end
