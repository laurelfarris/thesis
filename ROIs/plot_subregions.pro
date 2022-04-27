;- December, 2018


;- LCs and Power spectra of individual subregions.


center=[ [382,192], [382,193], [382,194], [381,193], [383,193] ]
z_ind = [0:259]
;z_ind = [196:196+dz-1]
nn = (size(center,/dimensions))[1]

xdata = []
flux = []
name = []
for ii = 0, nn-1 do begin
    flux = [[flux], [ reform( A[cc].data[center[0,ii],center[1,ii],z_ind] ) ]]
    xdata = [[xdata], [z_ind] ]
    name = [ [name], 'AR_' + [strtrim(ii+1,1)] ]
endfor
;name = [ 'AR_1', 'AR_2', 'AR_3', 'AR_4' ]

;- PLOT_LIGHTCURVES( xdata, ydata, color=color, name=name, buffer=0 )
;-

;win = window(dimensions=[8.0, 8.0]*dpi, location=[500,0], buffer=0)
;resolve_routine, 'get_position', /either
;rows = 1
;cols = 1
;pos = get_position( layout=[cols,rows,1], width=6.5, height=2.5 )

;(flux-min(flux)), $
;((flux-min(flux))/(max(flux)-min(flux))), $ ; + ii*0.5, $

;lc = PLOT_LIGHTCURVES_GENERAL( $
;    xdata, flux, color=color, name=name, $
;    ylog=0, ytitle = 'intensity', $
;    ;ylog=1, ytitle = 'log intensity', $
;    buffer=1 )
;save2, 'lc_bp'
stop


;- Plot power spectra for subregions

fmin = 0.0035
fmax = 0.010
plt = objarr(nn)

;pos = get_position( layout=[cols,rows,2], width=6.5, height=2.5 )
;win = window(dimensions=[8.0, 8.0]*dpi, location=[500,0], buffer=0)

CALC_FOURIER2, flux, 24, frequency, power, fmin=fmin, fmax=fmax
;plt = PLOT_SPECTRA_GENERAL( $
;    frequency, power, color=color, name=name, buffer=1 )

ax[2].showtext = 1
ax[2].title = 'period (seconds)'

;save2, 'lc_bp'

end
