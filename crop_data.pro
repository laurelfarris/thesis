;; Last modified:   16 May 2018 22:14:06

;+
;
; CREATED       04 April 2018
;
; ROUTINE:      Prep.pro
;
; PURPOSE:
;
; USEAGE:
;
; AUTHOR:       Laurel Farris
;
;-


;pro crop_data, data, X, Y, $
function CROP_DATA, data, $
    dimensions=dimensions, $
    center=center

    sz = size( data, /dimensions )


    ; Crop relative to center of input cube by default
    if not keyword_set(center) then begin
        ; Use these for MISaligned data (aia_####_misaligned.sav)
        ;x_center = 365
        ;y_center = 410
        ; Use these for aligned data (aia_####_aligned.sav)
        x_center = sz[0]/2 + 15
        y_center = sz[1]/2 + 15
    endif else begin
        x_center = center[0]
        y_center = center[1]
    endelse


    if not keyword_set(dimensions) then begin
        x_length = 500
        y_length = 330
    endif else begin
        x_length = dimensions[0]
        y_length = dimensions[1]
    endelse


    x1 = x_center - x_length/2
    y1 = y_center - y_length/2
    x2 = x1 + x_length -1
    y2 = y1 + y_length -1

    cube = data[ x1:x2, y1:y2, * ]
    ;sz = size( cube, /dimensions )
    ;X = indgen(sz[0]) + x1
    ;Y = indgen(sz[1]) + y1

    return, cube

end
