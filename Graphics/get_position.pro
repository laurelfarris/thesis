; Last modified:    26 July 2018

; optional keywords:
;   margins (left, bottom, right, top),
;   xgap, ygap


;- TO DO:
;- Could write two separate routines
;-   one where user inputs window size and gaps, and code calculates width/height,
;-   and one where user inputs width/height and gaps, and code calculates window size.
;- Then just see which one you prefer to use.
;-   --> wrote image3 (which calls get_position) to determine width/height.
;-         since for images, aspect ratio is preserved. Plot3 will prob handle this differently.


function WRAP_GET_POSITION, $
    layout=layout, $
    left=left, right=right, top=top, bottom=bottom, $
    width=width, height=height, $
    xgap=xgap, ygap=ygap, $
    wx=wx, wy=wy

    ;- Uses dimensions to calculate array with position in the form
    ;     [x1, y1, x2, y2], in inches

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
    ;- Call this with desired dimensions (if any)

    common defaults

    ;- Get dimensions of current window
    dim = (GetWindows(/current)).dimensions / dpi
    wx = float(dim[0])
    wy = float(dim[1])

    cols = layout[0]
    rows = layout[1]

    n_panels = cols*rows

    ;- determine width using wx, margins, and xgap
    ;width = wx - (right+left) - (float(xgap)*(cols-1))

    
    ;width = (wx - ( left + right + (cols-1)*xgap )) / cols --> image3.pro
    ;height = (wy - ( top + bottom + (cols-1)*xgap )) / cols --> maybe useful for plots

    position = WRAP_GET_POSITION( $
        layout = layout, $
        wx = wx, $
        wy = wy, $
        width = width, $
        height = height, $
        left   = 0.50, $
        right  = 0.50, $
        bottom = 1.00, $
        top    = 1.00, $
        xgap   = 0.25, $
        ygap   = 0.25, $
        _EXTRA = e )
    return, position

end
