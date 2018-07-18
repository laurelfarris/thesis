; Last modified:    06 April 2018
; Programmer:       Laurel Farris
; Description:      subroutines with custom default configurations

;function polygon2, x1, y1, x2, y2, _EXTRA=e
function polygon2, coords, $
    side=side, $
    ;height=height, $
    _EXTRA=e

    ;if not keyword_set(height) then height = width
    width = side
    height = side
    
    x1 = coords[0]
    y1 = coords[1]
    x2 = coords[2]
    y2 = coords[3]

    ;x0 = center_coords[0]
    ;y0 = center_coords[1]
    ;x1 = fix(x0 - width/2.)
    ;x2 = x1 + width - 1
    ;y1 = fix(y0 - height/2.)
    ;y2 = y1 + height - 1

    ;x1 = 40
    ;x2 = 139
    ;y1 = 90
    ;y2 = 189

    rec = polygon( $
        [x1, x2, x2, x1 ], $
        [y1, y1, y2, y2 ], $
        data=1, $
        fill_transparency = 100, $
        linestyle = 0, $
        ;linestyle = '--', $
        color='white', $
        _EXTRA=e )
    return, rec
end
