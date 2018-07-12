; Last modified:   12 July 2018


pro plot_lightcurves

    ; graphics up here (position, layout, etc)

    common defaults

    top = 1.0
    bottom = 1.0
    left = 0.75
    right = 0.75

    w = 6.0
    h = 1.5

    dw
    wx = 8.5
    wy = 9.0

    ; C-class flare ['00:30' --> '01:00']

    ytitle = 'counts (DN s$^{-1}$)'
    x_interval = 30.

    p = objarr(n_elements(A))
    for i = 0, n_elements(p)-1 do begin
        xdata = A[i].jd
        ydata = A[i].flux
        p[i] = PLOTT( $
            xdata, ydata, $
            overplot=i<1, $
            xtickinterval=(x_interval/(60*A[i].cadence)), $
            color=A[i].color, $
            name=A[i].name)
    endfor

    leg = legend2( target=[p], sample_width=0.3, position=[0.8,0.7] )

end

; math/science down here
lc = objarr(n_elements(A))
for i = 0, n_elements(A)-1 do begin

    ; Portion of time series to show
    time = strmid( update_time(A[i].jd), 0, 5 )
    t_start = time[0]
    t_end   = time[-1]

    ; X/Y data to plot
    xdata = A[i].jd
    ydata = A[i].flux

    ; What's my problem with creating graphic separately again?
    ; could easily remove lines themselves after overplotting, then
    ; re-draw them without re-creating the entire figure...
    graphic = plot2(xdata, ydata, /nodata)
    lc[i] = plot2()

endfor


end
