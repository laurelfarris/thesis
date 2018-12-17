;- 16 December 2018
;-  (see comp book, page 12, for some notes on plot3.pro)


;- Purpose:
;-  plot multiple plot graphics in one window.

;-  Dimension of ydata:
;-    1:  data points in one plotline
;-    2:  plotlines overlaid on each panel
;-    3:  panels (ideally = rows x cols)


function PLOT3_WRAPPER, $
    x, y, $
    wx = wx, $
    wy = wy, $
    width = width, $
    height = height, $
    left = left, $
    right = right, $
    color = color, $
    top = top, $
    bottom = bottom, $
    rows = rows, $
    cols = cols, $
    name = name, $
    buffer=buffer, $
    _EXTRA=e


    common defaults
    resolve_routine, 'get_position', /either

    margin = [left, bottom, right, top] * dpi

    ;- NN = number of plotlines (or panels?)
    NN = (size( y, /dimensions))[1]  ;- --> plotlines
    NN = rows*cols ; --> panels
    ;- ran into trouble with this in the past because wanted
    ;- to make arrays of images that didn't necessarily fit evenly
    ;- into grid...

stop

    for ii = 0, NN-1 do begin

        pos = GET_POSITION( $
            layout=[cols,rows,ii+1], $
            wx = wx, $
            wy = wy, $
            width = width, $
            height = height, $
            bottom = bottom, $
            left   = left, $
            right  = right, $
            top    = top $
        )


    plt = objarr(NN)
    dw
    win = window( dimensions=[wx,wy]*dpi, buffer=buffer )
        plt[ii] = plot2( $
            x, $
            y[*,ii], $
            /current, /device, $
            ;layout=[cols,rows,1], $
            margin=margin, $
            color = color[ii], $
            overplot = ii<1, $
            name = name[ii], $
            linestyle = ii, $
            _EXTRA=e )
    endfor
    return, plt
end


function plot3,  $
    x, y, $
    _EXTRA=e

    common defaults
    @color
    ;color = ['black', 'blue', 'red', 'green']

    NN = (size( y, /dimensions))[1]
    name = alph[0:NN-1]

    ;- Defaulting 'buffer' to 1 helps avoid crashing while
    ;- working remotely.

    plt = PLOT3_WRAPPER( $
        x, y, $
        wx = 8.0, $
        wy = 8.0, $
        width = 2.5, $
        height = 2.5, $
        bottom = 0.50, $
        left   = 0.50, $
        right  = 0.50, $
        top    = 0.50, $
        rows = 1, $
        cols = 1, $
        name = name, $
        color = color, $
        buffer = 1, $
        _EXTRA = e)
    return, plt
end



;- simple code to quickly plot data
;- or copy/paste to current code.

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
