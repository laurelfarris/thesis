; Last modified:    July 2018
; Programmer:       Laurel Farris
; Description:      subroutines with custom default configurations


function SCATTERPLOT2, xinput, yinput, _EXTRA=e

    common defaults


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
