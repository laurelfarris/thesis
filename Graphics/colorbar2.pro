; Last modified:    06 April 2018
; Programmer:       Laurel Farris
; Description:      subroutines with custom default configurations

function colorbar2, target=target, _EXTRA=e


    ;- Test to make sure mandatory kws were set
    if n_elements(target) eq 0 then begin
        print, ''
        print, 'kw "target" is currently mandatory. Set to individual image.'
        print, 'Returning.'
        print, ''
        return, 0
    endif

    ; add bit to pull target position and use it to calculate colorbar position

    common defaults

    win = getwindows(/current)
    dim = win.dimensions/dpi ; inches
      ;- This worked!

    wx = dim[0]
    wy = dim[1]

    cbar_width = 0.15
    cbar_gap = 0.05

    N = n_elements(target)
    cbar = objarr(N)
;
;    ;- Add colorbar to every image
;    for ii = 0, N-1 do begin
;
;        pos = target[ii].position * [ wx, wy, wx, wy ]
;
;        cx1 = pos[2] + cbar_gap
;        cy1 = pos[1]
;        cx2 = cx1 + cbar_width
;        cy2 = pos[3]
;
;        position=[cx1,cy1,cx2,cy2] * dpi
;
;        cbar[ii] = COLORBAR( $
;            target = target[ii], $
;            orientation = 1, $ ; 0 --> horizontal
;            tickformat = '(F0.1)', $
;            ;tickformat='(I0)', $
;            /device, $
;            position = position, $
;            textpos = 1, $ ; 1 --> right/above colorbar
;            font_style = 2, $ ;italic
;            font_size = fontsize, $
;            border = 1, $
;            ;ticklen = 0.3, $
;            ;subticklen = 0.5, $
;            ;major = 11, $
;            ;minor = 5, $
;            _EXTRA=e )
;
;    endfor

    ;- one big colorbar on the right
    pos = fltarr(4, N)
    for ii = 0, N-1 do begin
        pos[*,ii] = target[ii].position * [ wx, wy, wx, wy ]
    endfor

    x2 = max(pos[2,*])
    y1 = min(pos[1,*])
    y2 = max(pos[3,*])

    cx1 = x2 + cbar_gap
    cy1 = y1
    cx2 = cx1 + cbar_width
    cy2 = y2

    position=[cx1,cy1,cx2,cy2] * dpi

    cbar = COLORBAR( $
        target = target[0], $
        orientation = 1, $ ; 0 --> horizontal
        tickformat = '(F0.1)', $
        ;tickformat='(I0)', $
        /device, $
        position = position, $
        textpos = 1, $ ; 1 --> right/above colorbar
        font_style = 2, $ ;italic
        font_size = fontsize, $
        border = 1, $
        thick = 0.5, $ ;- matches images now! (21 June 2019)
        ;ticklen = 0.3, $
        ;subticklen = 0.5, $
        ;major = 11, $
        ;minor = 5, $
        _EXTRA=e )

    return, cbar
end
