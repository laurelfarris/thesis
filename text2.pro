; Last modified:    06 April 2018
; Programmer:       Laurel Farris
; Description:      subroutines with custom default configurations

; Input:            target (object array)

;function text2, x, y, i, str=str, _EXTRA=e
;function text2, x, y, str=str, i=i, _EXTRA=e

function text2, str, target=target, _EXTRA=e

    common defaults

    ; string array of letters: (a), (b), ..., (z)
    alph = '(' + string( bindgen(1,26)+(byte('a'))[0] ) + ')'

    N = n_elements(target)
    if not arg_present(str) then str = alph[0:N-1]
    t = objarr(N)

    for i = 0, N-1 do begin

        tx = 0.9 * ((target[i]).position)[2]
        ty = 0.9 * ((target[i]).position)[3]

        ;target.GetData, image, X, Y
        ;tx = X[-5]
        ;ty = Y[-5]

        t[i] = TEXT( $
            tx, ty, $
            str[i], $
            ;/data, $
            ;/normal, $
            /relative, $
            ;/device, $
            alignment='Right', $
            vertical_alignment='Top', $
            font_style = 'Bold', $
            font_size=fontsize-1, $
            _EXTRA=e )
    endfor

    return, t
end
