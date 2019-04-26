; Last modified:    06 April 2018
; Programmer:       Laurel Farris
; Description:      subroutines with custom default configurations

function LEGEND2, $
    target=target, $
    upperleft=upperleft, $
    upperright=upperright, $
    lowerright=lowerright, $
    _EXTRA=e

    common defaults

    win = GetWindows(/current)
    ;win.Select, /all
    ;target = win.GetSelect()

    wx = (win.dimensions)[0]
    wy = (win.dimensions)[1]


    ;- position in inches
    pos = (target[0].position)*([wx,wy,wx,wy]/dpi)

    ;sample_width = 0.10*(pos[3]-pos[1])
    ;print, sample_width


    ;- Set legend position

;    xoffset = 0.10
;    yoffset = 0.05
    xoffset = 0.00
    yoffset = 0.00

    ;- upper LEFT corner
    if keyword_set(upperleft) then begin
        lx = pos[0] + xoffset
        ly = pos[3] - yoffset
        horizontal_alignment = 0.0  ; left
        vertical_alignment = 1.0    ; top
    ;endif
    endif else $

    ;- upper RIGHT corner
    if keyword_set(upperright) then begin
        lx = pos[2] - xoffset
        ly = pos[3] - yoffset
        horizontal_alignment = 1.0  ; right
        vertical_alignment = 1.0    ; top
    ;endif
    endif else $

    ;- LOWER RIGHT corner
    if keyword_set(lowerright) then begin
        xoffset = 0.50
        yoffset = 0.05
        lx = pos[2] - xoffset
        ly = pos[1] + yoffset
        horizontal_alignment = 1.0  ; right
        vertical_alignment = 0.0    ; bottom

    ;- LOWER LEFT (default)
    endif else begin
        xoffset = 0.50
        yoffset = 0.05
        lx = pos[0] + xoffset
        ly = pos[1] + yoffset
        horizontal_alignment = 0.0  ; left
        vertical_alignment = 0.0    ; bottom
    endelse

    ;target.GetData, image, X, Y
    ;x = X[-5]
    ;y = Y[-5]
    ;position=[x,y]

    ; Alignment options (first is the default in each case)
    ; horizontal_alignment = 'Right'|'Center'|'Left'
    ; vertical_alignment = 'Top'|'Center'|'Bottom'


    ;- hor. space between line and text
    ;-  (default = 0.04)
    horizontal_spacing = 0.05

    ;- ver. space between items in list
    ;-  (default = 0.03)
    vertical_spacing = 0.02

    ;print, [lx,ly]

    leg = legend( $
        target=target, $
        position = [lx,ly], $;*dpi, $
        /device, $
        font_size = fontsize-1, $
        horizontal_spacing = horizontal_spacing, $
        vertical_spacing = vertical_spacing, $
        horizontal_alignment = horizontal_alignment, $
        vertical_alignment = vertical_alignment, $
        linestyle = 6, $
        shadow = 0, $
        thick = 0.5, $
        transparency = 100, $
        ;sample_width = 50./(win.dimensions)[0], $
        auto_text_color = 1, $
        _EXTRA=e )
    return, leg
end
