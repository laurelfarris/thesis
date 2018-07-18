; Last modified:    06 April 2018
; Programmer:       Laurel Farris
; Description:      subroutines with custom default configurations

function colorbar2, _EXTRA=e

; add bit to pull target position and use it to calculate colorbar position
    common defaults
    c = colorbar( $
        ;target = graphic, $
        orientation = 1, $ ; 0 --> horizontal
        tickformat = '(F0.1)', $
        ;position = [], $
        textpos = 1, $ ; 1 --> right/above colorbar
        font_style = 2, $ ;italic
        font_size = fontsize, $
        border = 1, $
        ;ticklen = 0.3, $
        ;subticklen = 0.5, $
        ;major = 11, $
        ;minor = 5, $
        _EXTRA=e )
    return, c
end
