;+
;-
;- 27 Dec 2023
;-  ==>> called by plot_contours.pro
;-
;-
;- Last modified:
;-   20 March 2020
;-     Replaced single-letter variables (x,y,c) with (xx,yy,cc) so they're
;-     easier to search for, and less likely to be duplicated.
;-
;- Written:
;-   03 October 2018 (I think)
;-
;- Programmer:
;-   Laurel Farris
;-   

function contour2, data, xx, yy, _EXTRA=e

    common defaults

    sz = size(data, /dimensions)

    if not arg_present(xx) then xx = indgen(sz[0])
    if not arg_present(yy) then yy = indgen(sz[1])

    cc = CONTOUR( $
        data, $
        xx, yy, $
        overplot=1, $
;        c_value=[c1,c2], $
;        n_levels=2, $        ; ignored by c_values
        c_thick=0.5, $
;        c_color= , $        ; Array of colors so each level has different color
;        color= , $          ; Color for EVERY contour
;        c_fill_pattern=, $
        c_label_show=0, $
;        label_color=,$      ; same as color/c_color by default
        font_size=fontsize, $
;        font_name= , $
;        font_color= , $
;        font_style=, $
        _EXTRA=e )

    return, cc

end
