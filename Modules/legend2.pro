; Last modified:    06 April 2018
; Programmer:       Laurel Farris
; Description:      subroutines with custom default configurations

function LEGEND2, $
    target=target, $
    ;position=position, $
    _EXTRA=e

    common defaults

    ;win = GetWindows(/current)
    ;win.Select, /all
    ;target = win.GetSelect()

    ;target.GetData, image, X, Y
    ;x = X[-5]
    ;y = Y[-5]
    ;position=[x,y]

    ;- position = coords of upper right corner
    ;frac = 0.95
    ;if keyword_set(position) then begin
    ;    x = position[2] * frac
    ;    y = position[3] * frac
    ;endif

    ; Alignment options (first is the default in each case)
    ; horizontal_alignment = 'Right'|'Center'|'Left'
    ; vertical_alignment = 'Top'|'Center'|'Bottom'

    leg = legend( $
        target=target, $
        ;position = [x,y], $
        ;/relative, $
        font_size = fontsize, $
        linestyle = 6, $
        shadow = 0, $
        transparency = 100, $
        sample_width = 0.20, $
        _EXTRA=e )
    return, leg
end
