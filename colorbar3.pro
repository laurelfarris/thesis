
;- 24 October 2018

function colorbar3, target=target

    c_width = 0.02
    c_gap = 0.01

    pos = target.position

    cx1 = pos[2] + c_gap
    cy1 = pos[1]
    cx2 = cx1 + c_width
    cy2 = pos[3]

    position=[cx1,cy1,cx2,cy2]

    ;print, position * [wx,wy,wx,wy]

    cbar = COLORBAR( $
        target = target[ii], $
        position=position, $
        /normal, $
        ;/device, $
        ;tickformat='(I0)', $
        ;major=11, $
        textpos=1, $
        orientation=1, $
        tickformat='(F0.1)', $
        font_size = fontsize, $
        font_style = 2, $
        border = 1, $
        title='log 3-minute power' )

    endfor
    return, cbar
end
