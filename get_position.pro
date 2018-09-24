; Last modified:    26 July 2018

; optional keywords:
;   margins (left, bottom, right, top),
;   xgap, ygap
;           
;        
; 18 September 2018
; This could probably use some extra subroutines to handle
;   all the little ways this can be done (e.g. by setting margins,
;   or width, height, and gaps. Don't need to set every parameter:
;   page dimensions, margins, gaps, and image dimensions...
;   one of these can be unknown, and solved for using the others.
; Didn't modify anything today... just using the code as is.



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
    image_array = reform( image_array, cols, rows )
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

    ; Get dimensions of current window
    dim = (GetWindows(/current)).dimensions / dpi
    wx = float(dim[0])
    wy = float(dim[1])

    ; Calculate a default width (in case kw isn't specified)
    ;   by dividing width of page by # columns
    cols = layout[0]
    rows = layout[1]
    width = wx / (cols)

    position = WRAP_GET_POSITION( $
        layout = layout, $
        wx = wx, $
        wy = wy, $
        width = width, $
        height = height, $
        left  = 1.00, $
        right = 1.00, $
        bottom = 1.00, $
        top = 1.00, $
        xgap = 0.00, $
        ygap = 0.00, $
        _EXTRA = e )
    return, position

end
