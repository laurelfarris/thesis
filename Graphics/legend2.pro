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

    ;pos = (target[0].position)/dpi
    ;lx = pos[2] - 0.10
    ;ly = pos[3] - 0.10
    ;position=[lx,ly]*dpi

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

    lx = 0.95
    ly = 0.95

    leg = legend( $
        target=target, $
        position = [lx,ly], $
        /relative, $
        font_size = fontsize, $
        horizontal_spacing = 0.05, $
        linestyle = 6, $
        shadow = 0, $
        thick = 0.5, $
        transparency = 100, $
        ;sample_width = 0.40, $
        auto_text_color = 1, $
        _EXTRA=e )
    return, leg
end
