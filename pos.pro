
function GET_POSITION, $
    layout=layout, $
    left=left, right=right, top=top, bottom=bottom, $
    width=width, height=height, $
    xgap=xgap, ygap=ygap, $
    wx=wx, wy=wy, $
    i=i, j=j

    common defaults

    i = layout[0]
    j = layout[1]

    x1 = left + i*(width + xgap)
    x2 = x1 + width

    ;y1 = bottom + j*(height + ygap)
    ;y2 = y1 + height

    y2 = wy - top - j*(height + ygap)
    y1 = y2 - height

    position = [ x1, y1, x2, y2 ]; * dpi

    return, position
end

function POS, layout=layout, _EXTRA = e

    ; layout of CURRENT figure, not total rows/cols
    ; IDEA: send window to buffer, then change dimensions AFTER creating graphics
    ; Defaults for single panel... I guess.

    common defaults
    dim = (GetWindows(/current)).dimensions / dpi

    position = GET_POSITION( $
        layout = layout, $
        wx = dim[0], $
        wy = dim[1], $
        ;wx = 8.5, $
        ;wy = 11.0, $
        width = 6.0, $
        height = 3.0, $
        left = 0.75, $
        bottom = 0.50, $
        right = 1.75, $
        top = 0.5, $
        xgap = 0.25, $
        ygap = 0.25, $
        _EXTRA = e )
    return, position
end
