;- 06 March 2019

;- Peak time 12:47
;- Class C3.0
;- 28 December 2013


goto, start

;tstart = '2013/12/28 12:42:00'
;tend   = '2013/12/28 12:52:00'


resolve_routine, 'read_my_fits', /either
READ_MY_FITS, index, data, nodata=0, $
    instr='aia', channel=1600, prepped=0, $
    ;ind = [10:15], $
    files = '*2013*.fits'

print, index.date_obs
;- 12:47:28.12

start:;-------------------------------------------------------------------------------

ct = AIA_COLORS( wave=1600 )

r = 600
dimensions = [r, r]
center=[1700,1650]

;- NOTE: 500x330 dimensions are HARD-CODED in crop_data routine!
;-         Possibly set as "defaults" using some hacky if statements...
;-        Look into this later.


resolve_routine, 'crop_data', /either
imdata = AIA_INTSCALE( $
    CROP_DATA( $
        data, $
        ;z_ind=z_ind, $
        center=center, dimensions=dimensions ), $
    wave=1600, exptime=index[0].exptime )

@image_quick


save2, 'new_flare'



;- NEXT:
;-   Lightcurves!
;-   (NOTE: If alignment hasn't been done yet,
;-         need to use big enough box to contain AR throughout time.)

end
