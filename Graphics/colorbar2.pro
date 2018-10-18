; Last modified:    06 April 2018
; Programmer:       Laurel Farris
; Description:      subroutines with custom default configurations

function colorbar2, target=target, _EXTRA=e

    ; add bit to pull target position and use it to calculate colorbar position

    common defaults
    
    win = getwindows(/current)
    dim = win.dimensions/dpi ; inches
      ;- This worked!

    wx = dim[0]
    wy = dim[1]

    cbar_width = 0.15

    pos = target.position * [ wx, wy, wx, wy ]
    x1 = pos[2] + 0.1
    y1 = pos[1]
    x2 = x1 + cbar_width
    y2 = pos[3]
    c = colorbar( $
        target = target, $
        orientation = 1, $ ; 0 --> horizontal
        tickformat = '(F0.1)', $
        /device, $
        position = [x1,y1,x2,y2]*dpi, $
        textpos = 1, $ ; 1 --> right/above colorbar
        font_style = 2, $ ;italic
        font_size = fontsize, $
        border = 1, $
        ;ticklen = 0.3, $
        ;subticklen = 0.5, $
        ;major = 11, $
        ;minor = 5, $
        _EXTRA=e )
    return, c
end
