;- Last modified:    May 2018
;- Programmer:       Laurel Farris
;- Description:      subroutines with custom default configurations
;- To Do:
;-   Make sure xinput is working correctly as an optional argument.
;-
;-
;-


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
        thick = 0.5, $
        xthick = 0.5, $
        ythick = 0.5, $
        xtickdir = 0, $
        ytickdir = 0, $
        ;xticklen = 0.02, $  --> set up ticklen in routine that calls this
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
