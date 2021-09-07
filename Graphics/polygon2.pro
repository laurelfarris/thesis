; Last modified:    14 December 2018
; Programmer:       Laurel Farris
; Description:      Use polygon to draw box around subregion in image.

;- KWs:     center = 2D array of center coords in pixels (data units).
;           dimensions = 2D array [width,height] in pixels (data units).


;function wrap_polygon2, $
function POLYGON2, $
    target=target, $
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
        target=target, $
        ;fill_transparency = 100, $
        fill_background = 0, $
        linestyle=0, $
        ;linestyle = [1, '1111'X], $
        thick = 0.5, $
        color='red', $
        _EXTRA=e )

    ; Fill is solid color by default,
    ;  setting any of the following will fill polygon with line pattern
        ;pattern_orientation=  ; degrees, counterclockwise from horizontal
        ;pattern_spacing = distance between lines (pts)
        ;pattern_thick= thickness of lines filling polygon,
        ;    set to float between 0.0 and 10.0 (default=1.0)

        ; transparency
    return, pol

end
;
;
;function polygon2, $
;    target=target, $
;    _EXTRA=e
;
;    ;- Not sure how to assign defaults to center and dimensions yet..
;
;    @colors
;
;    pol = wrap_polygon2( $
;        target=target, $
;        center=center, $
;        dimensions=dimensions, $
;    )
;
;    return, pol
;end
