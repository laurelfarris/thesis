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
;-  This is actually kind of useless, since the only keyword I'm setting to
;-    a custom value is font_size... may be a helpful reference, but that's
;-    what Enote is for.


function TEXT2, tx, ty, str, _EXTRA=e

    common defaults

        text_object = TEXT( $
            tx, ty, $
            str, $
            ;target=graphic
            ;/data, $
            ;/normal, $
            ;/relative, $
            ;/device, $
            ;alignment=1.0, $
                ;- Horizontal alignment = 0.0|0.5|1.0 --> left (default)|center|right
            ;vertical_alignment=1.0, $
                ;- Vertical alignment = 0.0|0.5|1.0 --> bottom (default)|center|top
            ;  COLOR
            ;  FONT_COLOR
            ;  FILL_BACKGROUND=0|1,
            ;  FILL_COLOR=
            ;font_style = 'Bold', $  0,1,2,3 = normal,bold,italic,bold italic
            ;font_name = ''
            font_size=fontsize, $
            ;  baseline=,
            ;  updir=
            ;  CLIP=1, ;; ignored unless /data is set
            ;  NAME=graphic_name,
            ;  ONGLASS,
            ;  ORIENTATION=angle, ;; counter-clockwise
            ;  POSITION,  --> ? First arg? or its own keyword?
            ;  STRING,  --> ?
            ;  WINDOW
            ;  TRANSPARENCY=0 ;; % transparency
            ;  hide, $
            _EXTRA=e )

        return, text_object
end
