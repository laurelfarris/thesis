;; Last modified:   17 May 2018 19:11:45


; Input:    ONE index (coords for each image will be slightly different)
;           2-element array with center coords center (pixels)
;           2-element array with x and y dimensions (pixels)
; Output:   X, Y = arcsecond locations for x/y axes


pro pixels_to_arcseconds, center_pix, dimensions, index, X, Y
    ; Save coords in arcsec, relative to disk center


    x_center = center_pix[0]
    y_center = center_pix[1]


    ; coords of lower left corner
    ;  (pixels, relative to lower left corner of full disk)
    x1 = x_center - (dimensions[0])/2
    y1 = y_center - (dimensions[1])/2

    ; coords of lower left corner
    ;  (pixels, relative to disk center)
    x1 = x1 - index.crpix1
    y1 = y1 - index.crpix2

    ; Arrays in X and Y with pixel coords relative to disk center.
    xarr = indgen(dimensions[0]) + x1
    yarr = indgen(dimensions[1]) + y1

    ; Finally, convert pixels to arcseconds
    X = xarr * index.cdelt1
    Y = yarr * index.cdelt2

end



pro arcseconds_to_pixels


    ;; Pretty sure this was a hacky way to figure out which
    ;;  pixels to show so I could save hmi image to file
    ;;  and put in paper.

    ; arcseconds --> pixels

    ; from A[0].X[-1] - A[0].X[0] (same for Y)
    arcsec_dimensions = [304.07713, 200.48372]

    cd1 = hmiindex[0].cdelt1
    cd2 = hmiindex[0].cdelt2
    pixel_dimensions = arcsec_dimensions / [cd1, cd2]

    xx = round(pixel_dimensions[0] / 2)
    yy = round(pixel_dimensions[1] / 2)

    x0 = 2440
    y0 = 1600

    hmi_image = hmi.data[*,*,0]
    image_hmi, hmi_image[x0-xx:x0+xx-1, y0-yy:y0+yy-1, 0]

    save2, 'hmi_image_2.pdf'


end
