;; Last modified:   13 July 2017 10:19:33

;; Purpose:         Create colorbar, using current graphic to position


;; Inputs:  graphic, or object array whose position coordinates will be used to set
;;              position of the colorbar

;; Write as script instead? May be issue with variables of the same name

function MAKE_COLORBAR, graphic

    pos = graphic.position
    x1 = pos[0]
    y1 = pos[1]
    x2 = pos[2]
    y2 = pos[3]

    d = 0.05
    im.position = im.position - [d, 0.0, d, 0.0]

    cx1 = x2
    cy1 = y1
    cx2 = cx1 + 0.03
    cy2 = y2

    cbar = colorbar( $
        position = [cx1,cy1,cx2,cy2], $
        _EXTRA=cbar_props )


end
