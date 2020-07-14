;+
;- LAST MODIFIED:
;-   16 August 2019 -- made a copy b/c orig. plot2.pro gave "readonly"
;-       warning when attempted to edit (on mac, right after git pull).
;-       No changes made to code itself.
;-
;- ROUTINE:
;-   plot2.pro
;-
;- EXTERNAL SUBROUTINES:
;-   Calls IDL's PLOT function
;-
;- PURPOSE:
;- DESCRIPTION:      subroutines with custom default configurations
;-
;- USEAGE:
;-   plt = plot2( arg1, arg2, kw=kw )
;-     --> use just like IDL's PLOT function.
;-
;- INPUT:
;-   Same as IDL PLOT function
;-
;- KEYWORDS (optional):
;-   Same as IDL PLOT function
;-
;- OUTPUT:
;-   plot
;-
;- TO DO:
;-   [] Make sure xinput is working correctly as an optional argument.
;-
;- KNOWN BUGS:
;-
;- AUTHOR:
;-   Laurel Farris
;-
;+


function plot2, xinput, yinput, $
    ;props=props, $
    _EXTRA=e

    common defaults
    ; REQUIRING xinput for now, because fuck this.

    ;if yinput eq !NULL then begin
    ;if not arg_present(y) then begin
    if n_elements(yinput) eq 0 then begin
        y = xinput
        x = indgen( n_elements(y) )
    endif else begin
        y = yinput
        x = xinput
    endelse


    ;if keyword_set(props) then plot_props = {e, props} else plot_props = e

    ;- font_style =
    ;-   0 ("Normal" or "rm")
    ;-   1 ("Bold" or "bf")
    ;-   2 ("Italic" or "it")
    ;-   3 ("Bold Italic" or "bi")

    p = plot( $
        x, y, $
        font_size = fontsize, $
        ytickfont_size = fontsize, $
        xtickfont_size = fontsize, $
        font_style = 0, $
        ytickfont_style = 0, $
        xtickfont_style = 0, $
        axis_style = 2, $
        ; axis_style = 0  No axes, decrease margins
        ; axis_style = 1  left/bottom axes
        ; axis_style = 2  Box axes (left/bottom/right/top)
        ; axis_style = 3  Cross-style axes
        ; axis_style = 4  No axes, preserve margins as if axes were there
        ;      --> useful for overlaying curves with different y-values
        thick = 0.5, $
        xthick = 0.5, $
        ythick = 0.5, $
        xtickdir = 0, $
        ytickdir = 0, $
        ;xticklen = 0.02, $   ; --> caller assigns value using window dimensions.
        ;yticklen = 0.02, $
        xsubticklen = 0.5, $
        ysubticklen = 0.5, $
        ;xminor = 4, $
        ;yminor = 4,  $
        xstyle = 1, $
        ystyle = 3, $
        ; x|y style = 0 Nice
        ; x|y style = 1 Exact
        ; x|y style = 2 Pad nice
        ; x|y style = 3 Pad exact
        ;symbol = 'Circle', $
        ;sym_size = 0.5, $
        sym_filled = 1, $
        ;_EXTRA = plot_props )
        _EXTRA = e )
    return, p
end
