; Last modified:    06 April 2018
; Programmer:       Laurel Farris
; Description:      subroutines with custom default configurations

function legend2, target=target, _EXTRA=e

    common defaults

    ;win = GetWindows(/current)
    ;win.Select, /all
    ;target = win.GetSelect()

    ;target.GetData, image, X, Y
    ;x = X[-5]
    ;y = Y[-5]
    ;position=[x,y]

    leg = legend( $
        target=target, $
        font_size = fontsize, $
        linestyle = 6, $
        shadow = 0, $
        sample_width = 0.20, $
        _EXTRA=e )
    return, leg
end
