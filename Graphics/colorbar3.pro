
;- 24 October 2018

function colorbar3, $
    target=target, $
    _EXTRA = e

    c_width = 0.015
    c_gap = 0.01

    pos = target.position

    cx1 = pos[2] + c_gap
    cy1 = pos[1]
    cx2 = cx1 + c_width
    cy2 = pos[3]

    position=[cx1,cy1,cx2,cy2]

    ;print, position * [wx,wy,wx,wy]

    cbar = COLORBAR( $
        target = target, $
        position=position, $
        /normal, $
        ;/device, $
        ;tickformat='(I0)', $
        ;major=11, $
        textpos=1, $
        orientation=1, $
        ;tickformat='(F0.1)', $
        ;tickformat='(I0)', $
        ;major = 5, $
        font_size = fontsize, $
        font_style = 2, $
        border = 1, $
        _EXTRA = e )

    return, cbar
end
