;+
;- LAST MODIFIED:
;-   05 March 2020
;-
;- ROUTINE:
;-   arrow2.pro
;-
;- EXTERNAL SUBROUTINES:
;-   Calls IDL's ARROW function
;-
;- PURPOSE:
;-   subroutines with custom default configurations,
;-    called with same syntax as IDL's routines.
;-
;- USEAGE:
;-   my_arrow = arrow2( x, y, kw=kw, prop=prop, ... )
;-
;- INPUT:
;-   x = [x1, x2]
;-     or for multiple arrows, x = 2xN array, of the form
;-        [ [x1_a, x2_a], [x1_b, x2_b], ... ]
;-   y .. ditto
;-
;- KEYWORDS (optional):
;-
;- OUTPUT:
;-   arrow overlayed on current graphic
;-
;- TO DO:
;-
;- KNOWN BUGS:
;-
;- AUTHOR:
;-   Laurel Farris
;-
;+


;function plot2, xinput, yinput, $
function arrow2, xx, yy, $
    _EXTRA=e

    common defaults

    myarrow = arrow( $
        xx, yy, $
        /data, $
        ;/device, $
        ;/normal, $
        ;/relative, $
        ;target=, $
        ;arrow_style=1|2|3|4|5, $
            ;- 1  ---->
            ;- 2  <----
            ;- 3  <--->
            ;- 4  >--->
            ;- 5  <---<
        head_angle=45, $
            ;- angle between shaft and side (not base) of arrow (default = 30 degrees)
        head_indent=0, $
            ;- FLT value between -1.0 and +1.0 (default = 0.4).
            ;-  NOTE: not an angle at all, but has similar effect as head_angle
            ;-   by altering the angle between the arrow shaft and base.
            ;-  Angle would stay the same if the arrow base increased instead,
            ;-   but the length of the base appears to remain constant.
            ;-
        ;head_size=, $  ;- I have no idea.
        ;thick = 0.5, $ ;- thickness of arrow shaft
        ;line_thick=, $ ;- thickness of outline surrounding arrow shaft
        fill_background=1, $
        ;fill_color='', $  ;- color of interior
        ;color='',      $  ;- color of outline
        _EXTRA = e )

    return, myarrow
end
