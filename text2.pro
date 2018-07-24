; Last modified:    06 April 2018
; Programmer:       Laurel Farris
; Description:      subroutines with custom default configurations

;function text2, x, y, i, str=str, _EXTRA=e
;function text2, x, y, str=str, i=i, _EXTRA=e
function text2, str, target=target, _EXTRA=e

    common defaults

    ; string array of letters: (a), (b), ..., (z)
    alph = '(' + string( bindgen(1,26)+(byte('a'))[0] ) + ')'

    ;tx = 0.9 * (target.position)[2]
    ;ty = 0.9 * (target.position)[3]
    
    target.GetData, image, X, Y
    tx = X[-5]
    ty = Y[-5]

    ;if not keyword_set(str) then str = alph[i]

    t = text( $
        tx, ty, $
        str, $
        /data, $
        ;/normal, $  ; x,y relative to entire window (default)
        ;/relative, $ ; x,y relative to target
        ;/device, $  ; x,y in pixels
        alignment=1.0, $
        vertical_alignment=1.0, $
        font_style = 'Bold', $
        font_size=fontsize-1, $
        _EXTRA=e )

    return, t

end
