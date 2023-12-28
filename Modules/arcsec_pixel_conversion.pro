;; Last modified:   27 June 2018


; Get X and Y coordinate arrays for a single image

; Input:    index (header struc containing crpix1|2 and cdelt1|2)
;           center_pix (2-element array with center coords in pixels)
;           2-element array with x and y dimensions (pixels)
; Output:   X, Y = arcsecond locations for x/y axes

pro PIXELS_TO_ARCSECONDS, $
    center_pix, $
    dimensions, $
    index, $
    X, Y

    ; returns ARRAYS of coords relative to disk center (not single x,y pair).

    ; individual variable names for x and y center coords
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



pro pixels_to_arcsecs, x, y

    ; Give x and y in pixels relative to lower left corner at 0,0.
    ; Get back x and y in arcseconds relative to disk center.
    ; Mess with output format LATER! This is NOT high priority!
    ; Also improve or get rid of other two subroutines in this file.

    print, 'coordinates relative to lower left corner (pixels):  (', $
        strtrim(x,1), ', ', $
        strtrim(y,1), ')'


    x = x - index.crpix1
    y = y - index.crpix2
    print, 'coordinates relative to disk center (pixels):        (', $
        strtrim(x,1), ', ', $
        strtrim(y,1), ')'


    x = x * index.cdelt1
    y = y * index.cdelt2
    print, 'coordinates relative to disk center (arcseconds):    (', $
        strtrim(x,1), ', ', $
        strtrim(y,1), ')'

end

pro arcseconds_to_pixels_OLD

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


function ARCSECONDS_TO_PIXELS, arcsec_coords, index
    pixel_coords = $
        ( arcsec_coords / [ index[0].cdelt1, index[0].cdelt2 ] ) $
        + [2048.0, 2048.0]



    ;    ;-------------------------------------------------------------------------------------------
    ;    ; From Prep/extract_subset.pro (replaced with call to this function)
    ;    ; -- 18 July 2022
    ;    ;
    ;    ;
    ;    ;half_dimensions = [ index[0].crpix1, index[0].crpix2 ]
    ;    ;-   index.crpix[1|2] --> n_pix to center? = half naxis (2048)
    ;    ;center =  half_dimensions + ([flare.xcen, flare.ycen]/spatial_scale)
    ;    ;
    ;    ;- index.naxis[1|2] --> length of ccd (4096)
    ;    full_dimensions = [ index[0].naxis1, index[0].naxis2 ]
    ;    center = FIX( (full_dimensions/2) + ([flare.xcen, flare.ycen]/spatial_scale) )
    ;    print, center
    ;    ;
    ;    ; Chose to convert (xcen,ycen) from arcsec to pixels using naxis instead of crpix
    ;    ;  only because center doesn't compute as a fraction.. may be off by one pixel, if it matters..
    ;    ;  "full_dimensions" avoids fractional pixel coords, if it matters...
    ;    ;-------------------------------------------------------------------------------------------
    ;

    return, round(pixel_coords)
end


; center of AR11158
;x0 = 2400
;y0 = 1650
;;
;arcsec_pixel_conversion, x0-(500./2), y0-(330./2), index


c83_arcsec_coords = [ flare.xcen, flare.ycen ]
c83_pixel_coords = ARCSECONDS_TO_PIXELS( c83_arcsec_coords, index )
help, c83_pixel_coords

print, c83_pixel_coords
print, round(c83_pixel_coords)

end
