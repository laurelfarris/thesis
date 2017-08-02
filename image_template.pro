;; Last modified:   14 July 2017 15:53:27

;+
; ROUTINE:      main.pro
;
; PURPOSE:      Describe steps in project
;               Run as script for common variables
;               Syntax for all user-defined subroutines (and some others)
;               Explanation of variables restored from .sav files
;
; USEAGE:       @main.pro
;
; INPUT:        N/A
;
; KEYWORDs:     N/A
;
; OUTPUT:       N/A
;
; TO DO:        Can't find subroutine that produced coordinates of missing hmi data,
;                   but numbers are saved in linear_interp.pro
;
; AUTHOR:       Laurel Farris
;
;KNOWN BUGS:
;-


pro imaging_template

    ;; Scale window coordinates relative to 500x500
    ;;  default = [640, 510]?
    scale = [1.2,1.2]

    ;; Call script with all configurations (image_props, plot_props, cbar_props)
    ;; Set individual properties as needed (e.g. image_props.xtitle = "bleh")
    @graphic_configs  

    ;; Create graphics
    im = objarr(n) ;; n = number of graphics in window
    for i = 0, n-1 do $
        im[i] = image( my_data[*,*,i], layout=[1,1,i+1], margin=0.1, _EXTRA = image_props )

    ;; Create colorbar, using current graphic to position
    pos = im.position ; [ x1, y1, x2, y2 ]
    cx1 = pos[2]
    cy1 = pos[1]
    cx2 = cx1 + 0.03
    cy2 = pos[3]

    cbar = colorbar( $
        position = [ cx1, cy1, cx2,cy2], _EXTRA=cbar_props )

    ;; Shift graphics by amount d relative to window.
    d = 0.05
    im.position = im.position - [d, 0.0, d, 0.0]

    txt = text(0.01, 0.01, filename, font_size=9, font_name=font_name)
    txt2 = text(0.7, 0.01, systime(), font_size=9, font_name=font_name)

end
