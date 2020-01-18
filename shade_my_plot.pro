;+
;- LAST MODIFIED:
;-   dd Month yyyy
;-
;- ROUTINE:
;-   name_of_routine.pro
;-
;- EXTERNAL SUBROUTINES:
;-
;- PURPOSE:
;-
;- USEAGE:
;-   result = routine_name( arg1, arg2, kw=kw )
;-
;- INPUT:
;-   arg1   e.g. input time series
;-   arg2   e.g. time separation (cadence)
;-
;- KEYWORDS (optional):
;-   kw     set <kw> to ...
;-
;- OUTPUT:
;-   result     blah
;-
;- TO DO:
;-   [] item 1
;-   [] item 2
;-   [] ...
;-
;- KNOWN BUGS:
;-   Possible errors, harcoded variables, etc.
;-
;- AUTHOR:
;-   Laurel Farris
;-
;+


function SHADE_MY_PLOT, plt ;-  , ... other kw's

    ;----
    ;- 17 January 2020
    ;-  Copied the following code from oplot_flare_lines.pro, and
    ;-  removed the kw opt to add shading in the same code.
    ;-  ... just in case I want a subroutine to add shading to any
    ;-   plot later, independent of whether already adding vertical
    ;-   lines for flare BDA (or of whether plot is of flare at all...)
    ;----



    ; Shaded region
    ;-  Given the absense of a '-' after the semi in the previous line,
    ;-    I'd say this first chunk is outdated, and can probably be removed.
    if keyword_set(shaded) then begin
        ;for ii = 0, n_elements(graphic)-1 do begin
            ;yrange = (graphic[ii]).yrange
            v_shaded = plot2( $
                [ vx[0]-32, vx[0]-32, vx[-1]+32-1, vx[-1]+32-1 ], $
                [ yrange[0], yrange[1], yrange[1], yrange[0] ], $
                /overplot, ystyle=1, linestyle=6, $
                fill_transparency=50, $
                fill_background=1, $
                fill_color='light gray' )
            v_shaded.Order, /SEND_TO_BACK
        ;endfor

        ;- Another way to shade:
        v_shaded = polygon( $
            [x1, x2, x2, x1], $
            [y1, y1, y2, y2], $
            /data, $
            linestyle = 4, $
            fill_background = 0, $
            fill_color='light gray' )
        v_shaded.Order, /send_to_back

    endif

    plt = [ plt, vert ]
    return, vert

end
