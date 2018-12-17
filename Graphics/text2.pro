; Last modified:    06 April 2018
; Programmer:       Laurel Farris
; Description:      subroutines with custom default configurations

; Input:            target (object array)

;function text2, x, y, i, str=str, _EXTRA=e
;function text2, x, y, str=str, i=i, _EXTRA=e


;-
;- 18 October 2018
;- file 'add_letters_to_figure.pro' looks like it does basically the same thing,
;- except no option to use different labels.
;- Looks much cleaner and easier to use.
;-  This looks like it could use some love...
;- 
;- 17 December 2018
;-   Why isn't this set up to take user-specified locations?
;-   This should at least be an option, with defaults when not set by user.

function text2, tx, ty, str, target=target, _EXTRA=e


    common defaults

    ; string array of letters: (a), (b), ..., (z)
    alph = '(' + string( bindgen(1,26)+(byte('a'))[0] ) + ')'

    N = n_elements(target)
        ; (9/18/2018) This only makes sense if first create array of
        ;  graphics, then add text in a separate loop... which may
        ;  have been my intention, but it's been too long since I've
        ;  edited this code.


    ;if not arg_present(str) then str = alph[0:N-1]
    if n_elements(str) eq 0 then str = alph[0:N-1]
    t = objarr(N)

    for ii = 0, N-1 do begin

;        tx = 0.9 * ((target[i]).position)[2]
;        ty = 0.9 * ((target[i]).position)[3]

        ;target.GetData, image, X, Y
        ;tx = X[-5]
        ;ty = Y[-5]

        t[ii] = TEXT( $
            tx, ty, $
            str[ii], $
            ;/data, $
            ;/normal, $
            ;/relative, $
            ;/device, $
            ;alignment=1.0, $  ; 0.0 = left (default); 1.0 --> Right
            vertical_alignment=1.0, $;'Top', $  ; 1.0
            ;font_style = 'Bold', $  0,1,2,3 = normal,bold,italic,bold italic
            font_size=fontsize-1, $
            _EXTRA=e )
    endfor

    return, t
end
