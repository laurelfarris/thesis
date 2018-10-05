;-
;- Last modified:       05 October 2018
;-
;-
;-


pro add_letters_to_image, graphic

    ; string array of letters: (a), (b), ..., (z)
    alph = '(' + string( bindgen(1,26)+(byte('a'))[0] ) + ')'

    for ii = 0, n_elements(graphic) do $

        pos = graphic[ii].position
        new_pos = convert_coord( [ pos[0], pos[2] ], [ pos[1], pos[3] ], /normal, /to_device )

        ;- Put text in upper left corner of each panel
        tx = new_pos[0]
        ty = new_pos[3]

        result = TEXT2( alph[ii], target=graphic[ii], position=[tx,ty], /device )

            ;tx = (x2-10)*dpi
            ;ty = (y2-10)*dpi
            tx = 0.85
            ty = 0.85
            t = TEXT( $
                tx, ty, $
                alph[ii], $
                ;/device, $
                /relative, $
                target=im[x,y], $
                fill_background=1, $
                fill_color='white', $
                font_color='black', $
                font_style='Bold', $
                font_size=9 )

end
