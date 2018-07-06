;; Last modified:   02 June 2018




function plot_vline, x, yrange, _EXTRA=e

    ;; Could input current plot, and have this routine
    ;; pull yrange from that. Then won't have to input yrange
    ;; at all, just the x-value where vertical line is to go.

    v = plot( [x,x], yrange, /overplot, ystyle=1, _EXTRA=e )

    return, v


end
