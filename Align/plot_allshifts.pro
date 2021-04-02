;+
;- LAST MODIFIED:
;-   02 April 2021
;-
;- ROUTINE:
;-    plot_allshifts.pro
;-
;- USEAGE:
;-   PLOT_ALLSHIFTS, allshifts[*,*,0]
;-    --> assuming "allshifts" is 2x750xN, or x|y shifts x 750 images in 5-hr ts x N alignment loops,
;-      and only interesting in plotting the first set of shifts, cuz after all, if they're fucked
;-      up, the rest don't matter. Could also use w/ 2D "shifts" after each alignment loop, not
;-      the set of all shifts).
;-
;-
;- INPUT:
;-
;- OUTPUT:
;-
;- TO DO:
;-   []
;-



pro PLOT_ALLSHIFTS, shifts


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
