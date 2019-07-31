pro plot_all_shifts, shifts


    ;; shifts should be 2xN array.

    cols=1
    rows=1
    @graphics

    ydata = shifts
    xdata = indgen( (size(shifts, /dimensions))[1] )

    graphic = plot( xdata, ydata[0,*], /nodata, $
        position=pos[*,0], $
        ;xrange = [650,720], $
        ;xmajor = 20, $
        xtickinterval = 20, $
        xminor = 4, $
        ;yrange=[-2.00,2.00], $
        _EXTRA=plot_props)

    p = objarr(2)
    p[0] = plot( xdata, ydata[0,*], $
        color='dark cyan', $
        ;symbol = 'circle', $ sym_filled = 1, $ sym_size = 0.5, $
        /overplot)

    p[1] = plot( xdata, ydata[1,*], $
        color='dark orange', $
        ;symbol = 'circle', $ sym_filled = 1, $ sym_size = 0.5, $
        /overplot)

end
