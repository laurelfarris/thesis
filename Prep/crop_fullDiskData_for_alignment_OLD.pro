;+
;- LAST MODIFIED:
;-   04 April 2020 -- read in documentation comments from ../_template.pro
;-
;-
;-   This is clearly old, based on the manual rotation of HMI images
;-    and use of the GOTO statement... probably not something I need.
;-   Based on comment near end of file, this was run prior to alignment procedures,
;-     so was probably examining the level 1.0 images.
;-    Call to crop data probably trims the full 4096x4096 pixel images
;-     down to something bigger than final desired dims of AR so as to
;-     allow for shifting that is applied during alignment.
;-    AFTER alignment, the data is saved to .sav files, and is trimmed
;-    further using CROP_DATA to the desired dimensions.
;-    This is done every time the data is restored from .sav files b/c don't
;-    want to accidentally crop too much and lose all the data that took so
;-   long to align. (Alignment takes several hours, up to 7 I think for
;-   5-hr time series at cadence = 24 seconds).
;-
;-  Whatever, don't need this, so
;-   moving to ../.old/ (hidden directory for old stuff in main "work" dir.)
;-
;- ROUTINE:
;-   prep_data.pro
;-
;- EXTERNAL SUBROUTINES:
;-   crop_data.pro
;-   image2.pro
;-
;- PURPOSE:
;-   Crop full disk (I assume) data cubes to center on AR with extra pixels
;-     to accomodate shifting by alignment procedures.
;-
;- USEAGE:
;-   First read index/data of level 1.0 data using read_my_fits, or whatever
;-   to define variables cube, hmi_data, index, ... also need values for
;-    variables center and dimensions to pass to CROP_DATA...
;-     this routine never calls @parameters tho.
;-   IDL> .run PREP_DATA
;-
;- AUTHOR:
;-   Laurel Farris
;-
;-
;---------------------------------------------------------------------------------
;-
;-
;-   Appears to first crop a 3D data cube (defined in another routine run prior
;-    to this one, apparently) and then creates two images, one of "cube"
;-   which is probably AIA data, and one of "hmi_data", which I surmise is
;-   comprised of one of four possible HMI data products...
;-  Yes, I am an ass.
;-  04 April 2020
;-
;-
;-




;- § Crop to variable "cube", subset centered on AR,
resolve_routine, 'crop_data', /either
cube = [ [[cube]], [[CROP_DATA( $
    data, $
    ;AIA_INTSCALE(data, wave=channel, exptime=index[zz].exptime), $
    ;-    Don't change the data values! just imdata
    center=center, $
    dimensions=align_dimensions ) ]] ]
;- NOTE: if kw "dimensions" isn't set, defaults to [500,330] in crop_data.pro
stop

help, cube
help, index
;xstepper2, cube, channel=channel, scale=0.75
stop

start:;-------------------------------------------------------------------------------


sz = size(cube, /dimensions)

resolve_routine, 'crop_data', /either
;imdata = CROP_DATA( data[*,*,sz[2]/2], center=center, dimensions=dimensions )
;imdata = CROP_DATA( hmi_data[*,*,0], center=center, dimensions=dimensions )
;imdata = AIA_INTSCALE( imdata, wave=fix(channel), exptime=index[sz[2]/2].exptime )
;im = image2( imdata, rgb_table=AIA_GCT(wave=channel) )
stop

;- 415 = one of three date_obs for AIA equal to 12:47:...
;-  ( reference image is not peak time!)

im = image2( $
    AIA_INTSCALE( $
        ;cube[*,*,sz[2]/2], $
        cube[*,*,415], $
        wave=fix(channel), $
        exptime=index[sz[2]/2].exptime ), $
    rgb_table=ct )


;hmi_imdata = rotate( hmi_data[*,*,2], 180
im = image2( $
    crop_data( $
        rotate(hmi_data[*,*,2], 2), $
        ;center=center+[373*2,448*2], $
        center=center, $
        dimensions=dimensions*(0.6/0.5) ), $
    max_value=300, min_value=-300 )


;-
;- NEXT STEP: § Align prepped data
;- "align_data.pro" has lines of code at ML, so run using:
;- IDL> .run align_data

end
