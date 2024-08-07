;+
;- 12/28/2023
;-   Moved from bottom of plot3.pro (didn't really fit with wrapper/plot func pair..)
;-


;- simple code to quickly plot data, or copy/paste to current code.
function plot_test, x, y

    common defaults
    colors = [ 'black', 'blue', 'red' ]
    n = 1

    wx = 5.0
    wy = wx

    ;dw
    win = window( dimensions=[wx,wy]*dpi, /buffer )
    plt = objarr(n)

    for ii = 0, n-1 do begin
        plt[ii] = plot2( $
            x, y, $
            /current, $
            layout=[1,1,1], $
            margin=0.1, $
            stairstep=1, $
            _EXTRA=e )
    endfor

    file = 'test_histogram.pdf'
    save2, file, /add_timestamp

    return, plt
end
