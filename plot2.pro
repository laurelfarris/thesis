; Last modified:    May 2018
; Programmer:       Laurel Farris
; Description:      subroutines with custom default configurations


function plot2, xinput, yinput, _EXTRA=e

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

    p = plot( $
        x, y, $
        font_size = fontsize, $
        ytickfont_size = fontsize, $
        xtickfont_size = fontsize, $
        axis_style = 2, $
        xtickdir = 0, $
        ytickdir = 0, $
        xsubticklen = 0.5, $
        ysubticklen = 0.5, $
        xminor = 4, $
        yminor = 4,  $
        ; x|y style = 0 Nice
        ; x|y style = 1 Exact
        ; x|y style = 2 Pad nice
        ; x|y style = 3 Pad exact
        xstyle = 1, $
        ystyle = 3, $
        _EXTRA = e )
    return, p
end
