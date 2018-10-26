


;- 24 October 2018

function plot3_wrapper, $
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
    name = name, $
    _EXTRA=e

    common defaults
    resolve_routine, 'get_position', /either


    dw
    win = window( dimensions=[wx,wy]*dpi, /buffer )
    margin = [left, bottom, right, top] * dpi

    N = (size( y, /dimensions))[1]
    plt = objarr(N)

    for ii = 0, N-1 do begin

        plt[ii] = plot2( $
            x, $
            y[*,ii], $
            /current, /device, $
            layout=[1,1,1], $
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

    color = ['black', 'blue', 'red', 'green']

    N = (size( y, /dimensions))[1]
    name = alph[0:N-1]

    plt = plot3_wrapper( $
        x, y, $
        wx = 8.5, $
        wy = 3.0, $
        width = 2.0, $
        height = 6.0, $
        left = 1.00, $
        right = 1.00, $
        top = 1.00, $
        bottom = 1.00, $
        name = name, $
        color = color, $
        _EXTRA = e)
    return, plt
end
