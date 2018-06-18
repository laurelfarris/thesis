; Last modified:   04 June 2018

function plot_smooth, x,y
    ; Smoothed lightcurves
    y = smooth( y, 8 )
    sm = plot2( x,y, /overplot, linestyle='--', thick=1.0, $
        name='boxcar smoothed')
    return, sm
end

function plot_background, x,y
    ; Pre-flare background
    y = mean( y[0:200] )
    bg = plot2( x,y, /overplot, linestyle=':', thick=1.0, $
        name='pre-flare background')
    return, bg
end


pro overplot_things, _extra=e
    ;; Call with overplot=reference_to_plot
    v = plot_vline( i1, graphic.yrange, _EXTRA=e )
    v = plot_vline( i2, graphic.yrange )
end


function PLOT_WITH_TIME, x, y, _EXTRA=e

    ; should have no problem running this, even if spontaneously reading
    ; random data from a few fits files and want to plot it.
    ; No loops here! Call this routine INSIDE loops!

    ; Also see aia_prep documentation on plotting light curves!

    common defaults
    win = getwindows()
    if n_elements(win) eq 0 then begin
        wx = 8.5
        wy = 3.0; * 2
        win = window( dimensions=[wx,wy]*dpi, location=[600,0] )
    endif

    ; Margin values for axes that are not on top of other axes.
    ; These are all you should have to change to adjust margins.
    left = 1.00
    bottom = 0.75
    right = 1.00
    top = 0.75
    margin = [ left, bottom, right, top ] * dpi

    ; kws = defaults for basic lightcurve
    p = plot2( $
        x, y, /current, /device, $
        layout = [1,1,1], $
        margin = margin, $
        xticklen = 0.05, $
        yticklen = 0.015, $
        ytickformat = '(F0.1)', $
        ystyle = 2, $
        xminor = 4, $
        yminor = 4, $
        xtitle = 'time', $
        ytitle = 'counts', $
        stairstep = 1, $
        _EXTRA=e $
        )

    ; keyword? Set by setting equal to struture with extra stuff?
    ; Can't use variable 'e' twice...
    leg = legend2( target=p )
    return, p
end
