;; Last modified:   17 May 2018 19:11:45




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

    ; Finally, convert to arcseconds
    X = xarr * index.cdelt1
    Y = yarr * index.cdelt2

end
