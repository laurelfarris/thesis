; Last modified:    26 July 2018



function WRAP_GET_POSITION, $
    layout=layout, $
    left=left, right=right, top=top, bottom=bottom, $
    width=width, height=height, $
    xgap=xgap, ygap=ygap, $
    wx=wx, wy=wy

    common defaults

    cols = layout[0]
    rows = layout[1]
    location = layout[2]

    image_array = indgen(cols,rows) + 1
    coords = array_indices(image_array, where( image_array eq location ))

    i = coords[0]
    j = coords[1]

    if not keyword_set(height) then height = width

    x1 = left + i*(width + xgap)
    x2 = x1 + width

    ;y1 = bottom + j*(height + ygap)
    ;y2 = y1 + height

    y2 = wy - top - j*(height + ygap)
    y1 = y2 - height

    position = [ x1, y1, x2, y2 ]; * dpi

    return, position
end

function GET_POSITION, layout=layout, _EXTRA = e

    common defaults
    dim = (GetWindows(/current)).dimensions / dpi
    
    wx = float(dim[0])
    wy = float(dim[1])

    cols = layout[0]
    rows = layout[1]

    ; Default width - divide width of page by # columns (plus some extra space)
    width = wx / (cols+1)

    position = WRAP_GET_POSITION( $
        layout = layout, $
        wx = wx, $
        wy = wy, $
        width = width, $
        ;height = height, $
        left = 0.75, $
        bottom = 0.50, $
        right = 1.75, $
        top = 0.5, $
        xgap = 0.25, $
        ygap = 0.25, $
        _EXTRA = e )
    return, position
end
