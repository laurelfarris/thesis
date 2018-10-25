


;- 24 October 2018

function plot3_wrapper, $
    x, y, $
    wx = wx, $
    wy = wy, $
    width = width, $
    height = height, $
    left = left, $
    right = right, $
    top = top, $
    bottom = bottom, $
    _EXTRA=e

    common defaults
    resolve_routine, 'get_position', /either

    dw
    win = window( dimensions=[wx,wy]*dpi, /buffer )
    margin = [left, bottom, right, top]

    N = (size( y, /dimensions))[1]
    plt = objarr(N)

    for ii = 0, N-1 do begin

        plt[ii] = plot2( $
            x[*,ii], $
            y[*,ii], $
            /current, /device, $
            layout=[1,1,1], $
            margin=margin, $
            overplot = ii<1, $
            name = name[ii], $
            _EXTRA=e )
    endfor

    return, plt
end


function plot3,  $
    x, y, $
    _EXTRA=e

    N = (size( y, /dimensions))[1]
    name = alph[0:N-1]

    plt = image3_wrapper( $
        x, y, $
        wx = 8.5, $
        wy = 11.0, $
        width = 2.0, $
        height = 6.0, $
        left = 0.75, $
        right = 0.75, $
        top = 0.75, $
        bottom = 0.75, $
        name = name, $
        _EXTRA = e)
    return, plt
end
