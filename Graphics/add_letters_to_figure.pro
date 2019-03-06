;-
;- Last modified: Thu Dec 20 07:30:19 MST 2018
;-
;- Would probably call this inside same loop level where get_position is called.

function ADD_LETTERS_TO_FIGURE, target=target

    common defaults

    ; string array of letters: (a), (b), ..., (z)
    alph = '(' + string( bindgen(1,26)+(byte('a'))[0] ) + ')'


    NN = n_elements(target)
    text_object = objarr(NN)

    ;if not arg_present(str) then str = alph[0:N-1]
    ;if n_elements(str) eq 0 then str = alph[0:N-1]

    for ii = 0, NN-1 do begin

        pos = target[ii].position

        ;- text position in /relative coords
        ;tx = 0.9 * ((target[i]).position)[2]
        ;ty = 0.9 * ((target[i]).position)[3]

        ;- Text position in upper right corner, with "margins" = 5 pixel between
        ;-  text and edges of graphic.
        ;target.GetData, image, X, Y
        ;tx = X[-5]
        ;ty = Y[-5]

        ;- Same as above? In device coords apparently, where
        ;- x2 = (target[ii].position)[2] and
        ;- y2 = (target[ii].position)[3]
        ;tx = (x2-10)*dpi
        ;ty = (y2-10)*dpi

        ; Convert retrieved position from normal to device coords
        new_pos = convert_coord( $
            [ pos[0], pos[2] ], [ pos[1], pos[3] ], /normal, /to_device )

        ;- Text position in upper left corner of each panel, in device coordes
        tx = new_pos[0]
        ty = new_pos[3]

        ;- Default alignments are bottom/left, and want top/right for
        ;-  position in upper left corner:
        vertical_alignment = 1.0
        alignment = 1.0

        ;- Text position in random relative coords
;        tx = 0.85
;        ty = 0.85

        text_object[ii] = TEXT2( $
            tx, ty, $
            alph[ii], $
            /device, $
            ;/relative, $
            vertical_alignment = vertical_alignment, $
            alignment = alignment, $
            fill_background=1, $
            fill_color='white', $
            font_color='black', $
            font_style='Bold', $
            target=target[ii] )
    endfor
    return, text_object
end
