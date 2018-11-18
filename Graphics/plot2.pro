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

    ;- font_style = 
    ;-   0 (normal)
    ;-   1 (bold)
    ;-   2 (italic)
    ;-   3 (bold italic)

    p = plot( $
        x, y, $
        font_size = fontsize, $
        ytickfont_size = fontsize, $
        xtickfont_size = fontsize, $
        ;font_style = fontstyle, $
        ;ytickfont_style = fontstyle, $
        ;xtickfont_style = fontstyle, $
        axis_style = 2, $
        thick = 0.5, $
        xthick = 0.5, $
        ythick = 0.5, $
        xtickdir = 0, $
        ytickdir = 0, $
        xticklen = 0.02, $
        yticklen = 0.02, $
        xsubticklen = 0.5, $
        ysubticklen = 0.5, $
        xminor = 4, $
        yminor = 4,  $
        xstyle = 1, $
        ystyle = 3, $
        ; x|y style = 0 Nice
        ; x|y style = 1 Exact
        ; x|y style = 2 Pad nice
        ; x|y style = 3 Pad exact
        ;symbol = 'Circle', $
        sym_size = 0.5, $
        sym_filled = 1, $
        _EXTRA = e )
    return, p
end


pro test_plot
    ;; What is sym_size relative to?? Still can't figure it out.

    x = indgen(10)
    y = x^2

    wx = 4.0
    wy = 4.0 * 2

    win = window( dimensions=[wx,wy*2]*dpi )
    test = plot2( x, y, /current, symbol='.', sym_size=8.0, sym_filled=1 )


    win = window( dimensions=[wx*2,wy]*dpi )
    test = plot2( x, y, /current, symbol='.', sym_size=8.0, sym_filled=1 )



end
