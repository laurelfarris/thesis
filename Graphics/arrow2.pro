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
    ;props=props, $
    _EXTRA=e

    common defaults
    ; REQUIRING xinput for now, because fuck this.

    ;if yinput eq !NULL then begin
    ;if not arg_present(y) then begin
;;    if n_elements(yinput) eq 0 then begin
;;        y = xinput
;;        x = indgen( n_elements(y) )
;;    endif else begin
;;        y = yinput
;;        x = xinput
;;    endelse
;;
;;    ;if keyword_set(props) then plot_props = {e, props} else plot_props = e
;;
;- 05 March 2020 -- previous lines commented with ";;" since copied this
;-   from plot2.pro, may or may not need those lines.


    myarrow = arrow( $
        xx, yy, $
        /data, $
        head_angle=45, $
            ;- angle between shaft and side (not base) of arrow (default = 30 degrees)
        head_indent=0, $
            ;- FLT value between -1.0 and +1.0 (default = 0.4).
            ;-  NOTE: similar to head_angle kw b/c changing this value
            ;-   changes the angle between the shaft and base of the arrow.
            ;-   only way for this angle to stay the same is if the
            ;-   base of the arrow increased in width instead,
            ;-   but it appears to remain constant.
            ;-   
        ;head_size=, $
        ;thick = 0.5, $
        ;line_thick=, $
        fill_background=1, $
        ;fill_color='', $  ;- color of interior
        ;color='',      $  ;- color of outline
        _EXTRA = e )
    return, p
end
