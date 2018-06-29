
; 29 June 2018
; extra plotting things that I may use eventually, but causing too much
; clutter at the moment

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
