;; Last modified:   22 February 2018 10:35:36


function crop_data, cube

    ;; Crop data array in x & y
    ;arcsec = 200. ; length of side in arcseconds
    ;resolution = index[0].cdelt1  ; arcseconds per pixel
    ;; Center coordinates
    ;x = 365
    ;y = 410
    ;r = (arcsec/resolution)/2
    ;return, cube[ x-r:x+r-1, y-r:y+r-1, * ]

    ;; Center coords relative to full disk
    ;x_center = 2400
    ;y_center = 1650

    sz = size( cube, /dimensions )

    ; Use these for MISaligned data (aia_####_misaligned.sav)
    ;x_center = 365
    ;y_center = 410

    ; Use these for aligned data (aia_####_aligned.sav)
    x_center = sz[0]/2 + 15
    y_center = sz[1]/2 + 15

    x_length = 500
    y_length = 330

    x1 = x_center - x_length/2
    y1 = y_center - y_length/2
    x2 = x1 + x_length -1
    y2 = y1 + y_length -1

    cube = cube[ x1:x2, y1:y2, * ]

    return, cube

end
