

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
;im = image2( imdata, rgb_table=AIA_colors(wave=channel) )
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
