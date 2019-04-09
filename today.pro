;- 08 April 2019

;- Peak time 12:47
;- Class C3.0
;- 28 December 2013


goto, start



resolve_routine, 'read_my_fits', /either
READ_MY_FITS, old_indices, old_data, $
    nodata=0, $
    instr='aia', $
    channel=1600, $
    prepped=0, $
    ;ind = [10:15], $
    files = '*2013*.fits'
stop


AIA_PREP, old_indices, old_data, $
    index, data, $
    out_dir="/solarstorm/laurel07/Data/AIA_prepped/", $
    /do_write_fits
stop


help, index
help, data
stop

start:;-------------------------------------------------------------------------------
ct = AIA_COLORS( wave=1600 )

xx = 525
yy = 400
dimensions = [xx, yy]
center=[1675,1600]


;- NOTE: 500x330 dimensions are HARD-CODED in crop_data routine!
;-         Possibly set as "defaults" using some hacky if statements...
;-        Look into this later.


resolve_routine, 'crop_data', /either
imdata = AIA_INTSCALE( $
    CROP_DATA( $
        data[*,*,200], $
        ;z_ind=z_ind, $ z_ind vs. 3rd data dimension... ?
        center=center, dimensions=dimensions ), $
    wave=1600, exptime=index[200].exptime )


im = image2( imdata, /buffer, rgb_table=ct )
;@image_quick


save2, 'sol2013_aia1600'



;- NEXT:
;-   Lightcurves!
;-   (NOTE: If alignment hasn't been done yet,
;-         need to use big enough box to contain AR throughout time.)

end
