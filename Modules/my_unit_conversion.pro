;+
;-
;- 27 December 2023
;-  • Moved part of Codes/test.pro from 14 October 2022 to bottom of this file
;-     => at a glance, includes variables for Rsun, AU, theta_deg, !RADEG, + others
;-      so seems appropriate for now..
;-  • Consolidating multiple unit converting codes:
;-     - Angstroms_to_keV.pro
;-     - arcsec_pixel_conversion.pro
;-     - period_freq_conversion.pro
;-     -  ...
;-
;- TO DO:
;-  [] check variable types, rounding, possible truncating of dividing
;-       odd numbers by integers or other such bloopers
;-      (esp. arcsec <-> pixel conversions routines..)



pro ARCSEC_PIXEL_CONVERSION

    ; LAST MODIFIED:
    ;   28 December 2023
    ;
    ; PURPOSE:
    ;   Convert pixel coords relative to ORIGIN (0,0) in lower left corner of image
    ;      to arcsecond coords relative to DISK CENTER.
    ;
    ;   Compute X and Y coordinate arrays in arcseconds
    ;
    ;
    ; INPUT:
    ;
    ;   index = header structure w/ key values:
    ;       crpix1, crpix2 = pixel coords of image center, relative to full disk
    ;         (full disk dims = [4096, 4096].. crpix 1 and 2 should each be close to 2048)
    ;       cdelt1, cdelt2 = "pixel size"
    ;         (aka spatial size scale of instr/CCD, in arcseconds per pixel) 
    ;
    ;   center=[x_center, y_center] = 2-element array w/ pixel coords of image center,
    ;     relative to FULL DISK (pixel dims = 4096 x 4096 )
    ;       (used to extract subset of images x/y dims ≈ few hundred pixels, centered on AR)
    ;
    ;   dimensions=[ x_dim, y_dim ] = image dimensions (pixels)
    ;
    ;
    ; OUTPUT:
    ;   X, Y = single coord pair OR array of coords, in arcseconds
    ;


    pro PIXELS_TO_ARCSECONDS, $
        index, $
        center=center, $
        dimensions=dimensions, $
        x_arcsec, y_arcsec


    ;= single pixel location at (x,y)


        x_center = center[0]
        y_center = center[1]
        ;  center coords are defined in a 2-element array in flare structures,
        ;   (I think...); easier to leave that alone and do some unnecessary maths here.


        x_center_arcsec = ( x_center - index.crpix1 ) * index.cdelt1
        y_center_arcsec = ( y_center - index.crpix2 ) * index.cdelt2
        print, 'Center coordinates relative to disk center (arcseconds):  (', $
            strtrim(x_center_arcsec,1), ', ', $
            strtrim(y_center_arcsec,1), ')'


    ;= 2D Arrays of x and y coords

        ; pixel coords of image lower left corner (x0,y0) relative to disk CENTER
        x0 = ( x_center - (dimensions[0])/2 ) - index.crpix1
        y0 = ( y_center - (dimensions[1])/2 ) - index.crpix2

        ; ...
        ; arrays of x & y pixel coords starting at (x0,y0) & spanning image dimensions;
        ;   followed by conversion to arcseconds:
        ; ...
        ; x & y coord arrays in arcsec, computed
        ;   from pixel arrays of image dimensions starting at (x0, y0),
        ;   and multiplied by "pixel size" (arcsec per pixel)
        x_arcsec = ( x0 + indgen(dimensions[0]) ) * index.cdelt1
        y_arcsec = ( y0 + indgen(dimensions[1]) ) * index.cdelt2

    END




    pro arcseconds_to_pixels_OLD

        ; Pretty sure this was a hacky way to figure out which
        ;  pixels to show so I could save hmi image to file and put in paper.

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

    ;- ML code for calling arcsec ⬅︎➡︎  pixel conversion routines:
    
    ; center of AR11158
    ;x0 = 2400
    ;y0 = 1650
    ;
    ;arcsec_pixel_conversion, x0-(500./2), y0-(330./2), index

    c83_arcsec_coords = [ flare.xcen, flare.ycen ]
    c83_pixel_coords = ARCSECONDS_TO_PIXELS( c83_arcsec_coords, index )
    help, c83_pixel_coords

    print, c83_pixel_coords
    print, round(c83_pixel_coords)

end ;================================================================================================

pro MY_UNIT_CONVERSION

    ;- 04 November 2021
    ;-   Manual unit conversion routines
    ;-     (canned routines probably available from IDL..)

    ; Channels in wavelength range 1-8 and 0.5-4 Angstroms (=10^-10 meters = 10^-8 cm)

    ;lambda = 0.5e-8 ; cm
    lambda = 1.0e-8
    ;lambda = 4.0e-8
    ;lambda = 8.0e-8


    ; physical constants ARE available as IDL system constants,
    ; but I don't feel like looking them up at the moment...

    ; constants (cgs)
    h = 6.262e-27 ; cm^2 g s^-1
    c = 3.0e10 ; cm s^-1


    E_erg = ( h*c ) / lambda

    ;print, E_erg, ' (erg)'


    ; 1 erg = 6.242e11 eV

    E_keV = ( E_erg * 6.242e11 ) / 1000.

    print, '       ', lambda, ' cm'
    print, '  ==>> ', E_keV,  ' (keV)'

    ;format = '()'
    ;print, E, format=format



    ; 14 October 2022

    Rsun = 6.96e10
    AU = 1.5e13

    theta_rad = atan(Rsun/AU)
    print, theta_rad

    ;theta_deg = theta_rad * (360. / (2*!PI))
    theta_deg = theta_rad * !RADEG
    print, theta_deg

    theta_arcsec = theta_deg * 3600.
    print, theta_arcsec

    ; double theta to get angle of full diameter
    print, theta_arcsec*2.0

    ; arcsec / hour
    print, ((theta_arcsec*2.0)/(15.*24))

    ; pixels / hour
    print, ((theta_arcsec*2.0)/(15.*24)) / 0.6

    ; pixel shift over 5-hour time series
    print, (((theta_arcsec*2.0)/(15.*24)) / 0.6) * 5.0

    ; Re-did computations, just to make sure
    theta_arcsec = ((atan(Rsun/AU))*!RADEG)*3600*2
    print, theta_arcsec

    ; Rotational period range (days -> hours)
    period = ([26.0, 32.0]/2) * 24

    ; arcsec per hour
    print, theta_arcsec / period

    ; pixels per hour
    print, (theta_arcsec/0.6) / period

    ; pixels between images separated by 24 seconds
    print, (((theta_arcsec/0.6)/period) / 3600.) * 24.

    ; pixels over 5-hour time series
    print, ((theta_arcsec/0.6) / period) * 5.0

end ;===============================================================================================


pro ANGSTROMS_TO_KEV

    ;- 18 October 2018

    ;- convert Angstroms to keV for the GOES 0.5-4.0\AA{} band:

    ;- wavelengths in Angstroms
    lambda = [1.0, 8.0]
    lambda = [0.5, 4.0]

    ;- Energy of a photon: E = hc/lambda
    ;- hc = ~1240 eV. Conversion to cgs: 1 erg = 6.2415 x 10^{11} eV
    ;- eV * (1 erg / 6.2415e11 eV erg^{-1})
    hc = 1240.0 / 6.2415e11

    ;- Convert wavelength to cgs: 1\AA{} = 10^{-10} m = 10^{-8} cm
    lambda = lambda * 1.e-8

    ;- Get energy in keV by converting wavelengths to cm
    E = hc/lambda

    print, E, ' eV = ', E/1000., ' keV'

    ;- Should be 1.5 and 10 keV
    ;- Not getting the correct numbers, but I've spent way too much time on this...

    ;- 19 April 2019
    ;- hc = 1240 eV•nm, not just eV.

end ;===============================================================================================


pro PERIOD_FREQ_CONVERSION

    ;+
    ; DATE:         22 April 2022
    ;
    ; ROUTINE:      period_freq_conversion.pro
    ;
    ; PURPOSE:      Convert freq (mHz, Hz) to period (min, sec)
    ;               (Canned routine probably exists... don't know what it is tho).
    ;
    ; USEAGE:       define freq_mHz, then
    ;               IDL> .RUN period_freq_conversion
    ;
    ; TO DO:        Add nicely formatted output to display each value + units

    freq_mHz = 5.5

    freq_Hz = freq_mHz / 1000.
    period_seconds = 1. / freq_Hz
    period_minutes = period_seconds / 60.

end ;===============================================================================================
