; Last modified:    06 April 2018
; Programmer:       Laurel Farris
; Description:      subroutines with custom default configurations

;function text2, x, y, i, str=str, _EXTRA=e
function text2, x, y, str, _EXTRA=e

    common defaults

    ; string array of letters: (a), (b), ..., (z)
    alph = '(' + string( bindgen(1,26)+(byte('a'))[0] ) + ')'


    ; 06 July 2018
    ; call needs to be more similar to IDL's text function
    if not keyword_set(str) then str = alph[i]
    t = text( $
        x, y, $
        str, $
        ;/normal, $  ; x,y relative to entire window (default)
        ;/relative, $ ; x,y relative to target
        ;/device, $  ; x,y in pixels
        ;target=p[i], $
        ;alignment=, $
        ;vertical_alignment=, $
        font_size=fontsize, $
        _EXTRA=e )
    return, t

    ; If one graphic is selected,
    ; it's returned in array 'graphics'.
    ; Need a way to select ALL graphics (without clicking)
    ;  in current window.
    ; See 'dw' routine.
    graphics = p.Window.GetSelect()
    for i = 0, n_elements(graphics)-1 do begin
        t = text( $
            x, y, $
            alph[i], $
            /device, /relative, $
            target=p[i], $
            ;alignment=, vertical_alignment=, $
            ;font_name=, $
            font_size=fontsize )
    endfor

    

    ; Text label
    ;w = getwindows(/current)
    ;d = w.dimensions
    ;tpos = p[0].position
    ;offset = 20.
    ;tx = (tpos[2] * d[0]) - offset
    ;ty = (tpos[3] * d[1]) - offset
    ;t = text2( tx, ty, A[0].time[i] + ' - ' + A[0].time[i+dz], /device, $
    ;    alignment=1, vertical_alignment=1 $


end
