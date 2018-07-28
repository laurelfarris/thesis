; Last modified:   12 July 2018

; Call one for a SINGLE PANEL, with each extra y-dimension an OVERPLOTTED curve
; Layout wouldn't change...
; Loop outside of this for multipanel (e.g. one for LC, one for power, etc.)
; Keywords for ARRAYS of keywords, otherwise color and name would just be in _EXTRA.


function PLOT_LIGHTCURVES, X_in, Y_in, $
    time=time, ind=ind, layout=layout, color=color, $
    _EXTRA=e

    ; Changing variable names to prevent modified values being returned to ML
    if n_elements(Y_in) eq 0 then begin
        Y = X_in
        yz = size(Y, /dimensions)
        X = indgen(yz[0])
    endif else begin
        X = X_in
        Y = Y_in
    endelse

    yz = size(Y, /dimensions)

    if not keyword_set(ind) then ind = [0:yz[0]]
    X = X[ind]
    Y = Y[ind,*]

    pad = 0.05*( max(Y) - min(Y) )
    yrange = [ min(Y)-pad, max(Y)+pad ]

    ; color = [ 'dark cyan', 'dark orange', 'purple', ... ]

    p = objarr(yz[1])
    ; Call a different subroutine here, with default color and name arrays?
    ; Maybe "graphic" is created here, then call subroutine to overplot individuals.
    for i = 0, n_elements(p)-1 do begin
        p[i] = plot2( $
            X, Y[*,i], $
            /current, /device, $
            overplot=i<1, $
            position=GET_POSITION( layout=layout ), $
            yrange=yrange, $
            xticklen=0.05, $
            yticklen=0.015, $
            xminor=5, $
            yminor=4, $
            xshowtext = 1, $
            xtitle = 'index', $
            stairstep=1 $
            color=color[i], $
            name=name[i], $
            _EXTRA=e )
    endfor

    ax = p[0].axes
    xtickvalues = ax[0].tickvalues
    ax[2].tickname = time[xtickvalues]
    ax[2].title = 'Start time (UT) on 2011-February-15'

    return, p
end

;dw
wx = 8.5
wy = 7.0
win = WINDOW(dimensions=[wx,wy]*dpi, buffer=1)
rows = 3
cols = 1
N_pixels = 500.*330.
time = strmid( A[0].time, 0, 5 )

;; Lightcurves

ydata = A.flux/N_pixels

lc = PLOT_LIGHTCURVES( $
    ydata, time=time, layout=[cols,rows,1], color=A.color, name=A.name, $
    ytitle = 'counts per pixel (DN s$^{-1}$)')
lc.Select

;; Power

dz = 64
ydata1 = A.power_flux
ydata2 = A.power_maps
xdata = [ (dz/2) : 749-(dz/2)-1 ]
xrange = lc[0].xrange

pow1 = PLOT_LIGHTCURVES( $
    ydata1, time=time, layout=[cols,rows,2], color=A.color, name=A.name, $
    xshowtext=0, $
    xtickinterval = 75, $
    ytitle = '3-minute power (per pixel)' )
pow1.Select, /ADD

pow2 = PLOT_LIGHTCURVES( $
    ydata2, time=time, layout=[cols,rows,3], color=A.color, name=A.name, $
    xshowtext=0, $
    xtickinterval = 75, $
    ytitle = '3-minute power (per pixel)' )
pow2.Select, /ADD


graphic = win.GetSelect()
txt = TEXT2( target=graphic )


for i = 0, n_elements(graphic)-1 do begin
    yrange=graphic[0].yrange

    ;; This only works for full time series. Can't use to plot subsets of LCs...
    resolve_routine, 'plot_flare_lines', /either
    ; p.yrange? multi-d array? Is yrange the same for p[0] and p[1]?
    v = OPLOT_FLARE_LINES( time, yrange=graphic[0].yrange, /shaded, /SEND_TO_BACK )

    z_start = [0,50,150,200,280,370,430,525,645]
    foreach z, z_start, i do begin
       v = plot( $
           [ z, z, z+80, z+80 ], $
           [ yrange[0], yrange[1], yrange[1], yrange[0] ], $
           /overplot, $
           fill_background=1, $
           fill_transparency=50, $
           fill_color='light blue' )
    endforeach
endfor


;leg = legend2( target=p, position=[0.85,0.7], /relative )


file = 'lc_power_2.pdf'
resolve_routine, 'save2'
save2, file, /add_timestamp

; See coments in plot_lightcurves.pro

end
