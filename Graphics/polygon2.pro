; Last modified:    06 April 2018
; Programmer:       Laurel Farris
; Description:      Use polygon to draw box around subregion in image.

;- KWs:     center = 2D array of center coords in pixels (data units).
;           dimensions = 2D array [width,height] in pixels (data units).


function polygon2, $
    center=center, $
    dimensions=dimensions, $
    _EXTRA=e

    ;if not keyword_set(height) then height = width
    ;width = side
    ;height = side

    x0 = center[0]
    y0 = center[1]

    width = dimensions[0]
    height = dimensions[1]

    x1 = fix(x0 - width/2.)
    x2 = fix(x1 + width) - 1
    y1 = fix(y0 - height/2.)
    y2 = fix(y1 + height) - 1

    ;x1 = 40
    ;x2 = 139
    ;y1 = 90
    ;y2 = 189

    pol = polygon( $
        [x1, x2, x2, x1 ], $
        [y1, y1, y2, y2 ], $
        data = 1, $
        fill_transparency = 100, $
        ;linestyle = 0, $
        ;linestyle = [1, '0000'X], $
        ;linestyle = '--', $
        linestyle = [1, '3333'X], $
        thick = 0.5, $
        color='white', $
        _EXTRA=e )

    return, pol

end
