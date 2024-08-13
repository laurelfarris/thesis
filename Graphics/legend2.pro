;+
; LAST MODIFIED:
;   12 August 2024 --   
;     replaced the following kws:
;        upperleft=upperleft, $
;        upperright=upperright, $
;        lowerright=lowerright, $
;     with ONE kw "legend_position" (see below)
;
;   06 April 2018 --
;
; PURPOSE:
;   custom default configurations for IDL's LEGEND function
;
; KEYWORDS:
;   legend_position =  [ UL | UR | LL | LR ] (upper left, upper right, lower left, lower right)
;
; PROGRAMMER:
;   Laurel Farris
;-


function LEGEND2, $
    target=target, $
    legend_position=legend_position, $
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

    ;xoffset = 0.10
    ;yoffset = 0.05
    xoffset = 0.10
    yoffset = xoffset * (wy/wx)
;    print, yoffset
;    stop

    ; New kw for legend position (8/12/2024):

    if not keyword_set(legend_position) then begin
        legend_position = 'UL' ;; DEFAULT
    endif else begin

        legend_position = STRING(legend_position)

        ;- upper LEFT corner
        if (legend_position eq 'UL') then begin
        ;if keyword_set(upperleft) then begin
            lx = pos[0] + xoffset
            ly = pos[3] - yoffset
            horizontal_alignment = 0.0  ; left
            vertical_alignment = 1.0    ; top
        ;endif
        endif else $

        ;- upper RIGHT corner
        if (legend_position eq 'UR') then begin
        ;if keyword_set(upperright) then begin
            lx = pos[2] - xoffset
            ly = pos[3] - yoffset
            horizontal_alignment = 1.0  ; right
            vertical_alignment = 1.0    ; top
        ;endif
        endif else $

        ;- LOWER RIGHT corner
        if (legend_position eq 'LR') then begin
        ;if keyword_set(lowerright) then begin
            xoffset = 0.50
            yoffset = 0.05
            lx = pos[2] - xoffset
            ly = pos[1] + yoffset
            horizontal_alignment = 1.0  ; right
            vertical_alignment = 0.0    ; bottom
        ;endif
        endif else $

        ;- LOWER LEFT (default)
        if (legend_position eq 'LL') then begin
            xoffset = 0.50
            yoffset = 0.05
            lx = pos[0] + xoffset
            ly = pos[1] + yoffset
            horizontal_alignment = 0.0  ; left
            vertical_alignment = 0.0    ; bottom
        endif else begin
            print, '======================================================'
            print, 'Invalid kw value for legend_position!'
            print, '======================================================'
            stop
        endelse

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
        position = [lx,ly]*dpi, $
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
        ;-    = 0.15 (default)
        auto_text_color = 1, $
        _EXTRA=e )
    return, leg
end
