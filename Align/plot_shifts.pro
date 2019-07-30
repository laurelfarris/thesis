;+
;- LAST MODIFIED:
;-
;- ROUTINE:
;-   plot_shifts.pro
;-
;- PURPOSE:
;- Plot x and y shifts (# pixels) as function of z-index
;-   during alignment to make sure they look reasonable.
;-   (both should = 0 for ref).
;-
;- USEAGE (aka calling syntax):
;-   result = routine_name( arg1, arg2, kw=kw )
;-
;- INPUT:
;-   arg1   e.g. input time series
;-   arg2   e.g. time separation (cadence)
;-
;- KEYWORDS (optional):
;-   kw     set <kw> to ...
;-
;- OUTPUT:
;-   result     blah
;-
;- TO DO:
;-   [] Color axes on each side, and shift/scale differently?
;-
;- AUTHOR:
;-   Laurel Farris
;-
;- KNOWN BUGS:
;-
;+


function PLOT_SHIFTS, shifts, xdata=xdata, _EXTRA=e


    ;- Example dimensions for 750 images that looped thru alignment 7 times:
    ;- shifts = FLOAT Array [2, 750, 7]

    common defaults
    sz = size( shifts, /dimensions)
    cols = 1
    if n_elements(sz) eq 3 then rows = sz[2] else rows = 1
    if n_elements(xdata) eq 0 then xdata = indgen(sz[1])
    names = ['horizontal (X) shifts', 'vertical (Y) shifts' ]
    @colors

    plt = objarr(2)

;    plt[0] = plot2( shifts[0,*], color= 'red', name="X shifts", buffer=1 )
;    plt[1] = plot2( shifts[1,*], color='blue', name="Y shifts", overplot=1, buffer=1 )

    margin=[1.0, 0.5, 2.0, 0.5]*dpi
    wx = 11.0
    wy = 5.0
    win = window( dimensions=[wx,wy]*dpi, location=[500,0] )
    xticklen = 0.02
    yticklen = xticklen * (wy-margin[1]-margin[3])/(wx-margin[0]-margin[2])

    for ii = 0, sz[0]-1 do begin
        plt[ii] = plot2( $
            xdata, shifts[ii,*], $
            /current, $
            overplot=ii<1, $
            /device, $
            layout=[cols,rows,ii+1], $
            margin=margin, $
            xticklen=xticklen, $
            yticklen=yticklen, $
            xtitle='image #', $
            ytitle='shifts', $
            symbol='circle', $
            sym_filled=1, $
            sym_size=0.5, $
            color=colors[ii], $
            name=names[ii], $
            _EXTRA=e $
            )
    endfor
    leg=legend2( $
        target=[plt], $
        /device, $
        ;position=([wx,wy-0.5])*dpi, $
        /upperright, $
        auto_text_color=1 $
        )
    return, plt
end




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
