;; Last modified:   13 October 2017 17:52:40
;; Colorbar----------------------------------------------------------------------------------------

cbar_props = { $
    ;name        : "Color Bar", $
    orientation : 1, $
    device      : 0, $
    ;title       : "", $
    ;position    : [0.0, 0.0, 0.0, 0.0], $
    font_name   : fontname, $
    font_size   : fontsize+1, $
    font_style  : "italic", $
    textpos     : 1, $
    border      : 1, $
    ticklen     : 0.3, $
    subticklen  : 0.5, $
    major       : 11, $
    minor       : 5, $
    ;range       : [0.0, 0.0], $
    tickformat  : "" $
    }

; orientation BEFORE position! Otherwise colors will change in the wrong direction
; Set position according to graphics layout somehow?


;; Text
txt = text( x, y, filename, font_size=fontsize-2, font_name=fontname)
