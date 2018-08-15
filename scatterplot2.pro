; Last modified:    July 2018
; Programmer:       Laurel Farris
; Description:      subroutines with custom default configurations


function SCATTERPLOT2, xinput, yinput, _EXTRA=e

    common defaults

    ;if yinput eq !NULL then begin
    ;if not arg_present(y) then begin
    if n_elements(yinput) eq 0 then begin
        y = xinput
        x = indgen( n_elements(y) )
    endif else begin
        y = yinput
        x = xinput
    endelse

    p = scatterplot( $
        xinput, yinput, $
        ;symbol =
        ;sym_size
        ;sym_thick
        ;sym_transparency
        sym_filled = 1, $
        ;sym_fll_color
        ;sym_color = all symbols same color
        ;magnitude = array of color table indices that
        ; correspond to the magntidue of each data point.
        ;rgb_table = table from which to get magnitude colors
        axis_style = 2, $
        xstyle = 1, $
        ystyle = 3, $
        xminor = 4, $
        yminor = 4,  $
        xtickdir = 0, $
        ytickdir = 0, $
        xsubticklen = 0.5, $
        ysubticklen = 0.5, $
        font_size = fontsize, $
        ytickfont_size = fontsize, $
        xtickfont_size = fontsize, $
        _EXTRA = e )
    return, p
end
