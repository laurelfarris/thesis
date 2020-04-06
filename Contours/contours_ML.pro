;====================================================================
;- IMPORTANT!!
;-    ==>> [] Double check that all comments and calls to external routines
;-               are updated to reflect the following changes:
;-      05 APRIL 2020:
;-        Moved function definition to its own file (contours.pro)
;-        so that ML code is separate from the two subroutines it calls
;-        GET_CONTOUR_DATA and CONTOUR.
;-        (get_contour_data.pro)...
;-
;-
;-
;====================================================================
;+
;-
;- LAST MODIFIED:
;-   05 April 2020
;-
;- PURPOSE:
;-   Main Level (ML) code to overlay contours on images and/or powermaps.
;-
;- EXTERNAL SUBROUTINES:
;-   get_contour_data.pro
;-   plot_contours.pro
;-
;- NOTE(S):
;-   •
;-
;- TO DO:
;-   [] Make sure Graphics/contour2.pro works... haven't tested this yet.
;-
;-



;----------------------------------------------------------------------------------
;- ML stuff... ??:

;- hmi line through middle of two sunspots (pos/neg)
;p = plot2( hmi[*,175,0] )

;file = 'HMI_BLOS_contours.pdf'
;save2, file
;c.delete
;----------------------------------------------------------------------------------

;-  READ ME!!!!!!!!!!
;- In current form, image must exist BEFORE running this code.
;-  Also need to define time, zz, and dz
;-  (image_powermaps.pro does all of this).

;- Name of FILE must match name of subroutine called from command line
;-  (otherwise things get messy real quick),
;- so if there are more than one routines above, need to be very explicit
;- about which one is called by usuer.


;- 1. Make image(s)
;- IDL> .run image_powermaps
;-  generate image object 'im'

;- 2. Get contour data by reading header from fits files and restoring .sav
;-     file for data.
if n_elements(c_data) eq 0 then $
    c_data = GET_CONTOUR_DATA( time[zz+(dz/2)], channel='mag' )
;- NOTE: get_hmi.pro uses time to get closest hmi date_obs,
;-        so the correct HMI is being used (at least I hope so...)
;- Also have the option of retrieving c_data a different way, e.g., if
;-   H is array of prepped hmi data, can just use one of those images.
;-
;- Technically should average HMI contour data over dz (whatever that is for HMI).
;- Except obviously not straightup MEAN since B_LOS would result in 0 (or close).
;- Use absolute values, or standard deviation.

;- 3. Overplot contours on image generated in step 1.
c = PLOT_CONTOURS( c_data, target=im, channel='mag' )

end
