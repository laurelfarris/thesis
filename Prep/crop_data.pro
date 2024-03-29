;; Last modified:   19 November 2018
;-   Added description of purpose and useage at the top.

;+
;
; CREATED       04 April 2018
;
; ROUTINE:      Prep.pro
;
; PURPOSE:      Crop data cube to desired subset
;
; USEAGE:       center = 2D array of center coordinates [x0, y0]
;               dimensions = 2D array of desired dimensions [width, height]
;               z_ind = index array of desired z-indices (e.g. [100:250])
;                   If not set, entire range of input cube will be preserved.
;
; AUTHOR:       Laurel Farris
;
; 03 October 2018 - added optional 'offset' keyword
;-


;pro crop_data, data, X, Y, $
function CROP_DATA, data, $
    dimensions=dimensions, $
    center=center, $
    z_ind=z_ind, $
    offset=offset, $
    syntax=syntax



    if keyword_set(syntax) then begin
        print, ''
        print, 'result = CROP_DATA( data, $'
        print, '    dimensions=dimensions, $'
        print, '    center=center'
        print, '    z_ind=z_ind'
        print, '    offset=offset'
        print, ''
        return, 0
    endif

    sz = size( data, /dimensions )

    ; Crop relative to center of input cube by default
    if not keyword_set(center) then begin

;        print, 'NOTE: kw "center" not set (just fwi);'
;        print, '  default = center coords of input data (x0,y0).'

        ;- Added 15 to coords in each dimension for 2011 flare,
        ;-   don't remember why. Should have added a comment explaining this...
;        x_center = sz[0]/2 + 15
;        y_center = sz[1]/2 + 15

        x_center = sz[0]/2
        y_center = sz[1]/2

        ; Use these for MISaligned data, aia_####_misaligned.sav
        ; (the above values are for properly aligned data,
        ;      aia_####_aligned.sav)
        ;x_center = 365
        ;y_center = 410

    endif else begin
        x_center = center[0]
        y_center = center[1]
    endelse

    ;- offset center (03 October 2018)
    if not keyword_set(offset) then offset = [0,0]
    x_center = x_center + offset[0]
    y_center = y_center + offset[1]


    if not keyword_set(dimensions) then begin
        print, 'NOTE: kw "dimensions" not set!'
        print, '  = [500, 300] by default.'
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

    if n_elements(sz) eq 2 then $
        cube = data[ x1:x2, y1:y2 ]


    if n_elements(sz) gt 2 then begin

        ;if not keyword_set(z_ind) then z_ind = [0:sz[2]-1]
        ;if z_ind eq !NULL then z_ind = [0:sz[2]-1]
        if z_ind eq !NULL then begin
            z_ind = indgen(sz[2])
            ;print, z_ind  ; ... why? (12 April 2019)
        endif


        if n_elements(sz) eq 3 then $
            cube = data[ x1:x2, y1:y2, z_ind ]
        if n_elements(sz) eq 4 then $
            cube = data[ x1:x2, y1:y2, z_ind, * ]
    endif

    ;- 06 March 2019  (Test code!)
    if n_elements(sz) lt 2 then begin
        print, ''
        print, '--> data is not a 2D array.'
        print, ''
        return, 0
    endif

    ;sz = size( cube, /dimensions )
    ;X = indgen(sz[0]) + x1
    ;Y = indgen(sz[1]) + y1

    return, cube

end
