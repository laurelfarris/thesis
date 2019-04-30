;- Last modified:    29 April 2019
;- Programmer:       Laurel Farris
;- Description:      subroutines with custom default configurations
;- Arguments:       direction  ( 'X' or 'Y' )
;- KWs:             location, target
;-                      NOTE: currently, kws are NOT optional.
;- 
;- To Do:
;-


function AXIS2, direction, $
    location=location, $
    target=target, $
    _EXTRA=e

    common defaults


    ;- font_style = 
    ;-   0 ("Normal" or "rm")
    ;-   1 ("Bold" or "bf")
    ;-   2 ("Italic" or "it")
    ;-   3 ("Bold Italic" or "bi")

    ;- x|y style =
    ;-   0  Nice
    ;-   1  Exact
    ;-   2  Pad nice
    ;-   3  Pad exact


    ax = axis( $
        direction, $
        location=location, $
        target=target, $
        ;axis_range=, $
        tickfont_size = fontsize, $
        tickfont_style = 0, $
        ;thick = 0.5, $
        ;tickdir = 0, $
        ;ticklen = 0.02, $
        ;subticklen = 0.5, $
        ;major =, $
        ;minor = 4, $
        _EXTRA = e )
    return, ax
end
