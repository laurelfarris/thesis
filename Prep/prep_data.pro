;+
;- LAST MODIFIED:
;-   22 April 2019
;-
;- PURPOSE:
;-   General routine (hopefully), to
;-   read original downloaded fits files, run aia_prep, and save new fits files.
;-
;-    Currently all at ML like vsoget.pro,
;-      Using @parameters to read in the desired values.
;-
;- INPUT:
;-
;- KEYWORDS:
;-
;- OUTPUT:
;-
;- TO DO:


goto, start

;-- § Read fits files (downloaded, NOT prepped)

;- Naming convention of fits files for, e.g. AIA 1600\AA{}
;     UNprepped fits:
;        'aia.lev1.1600A_2013-12-28T10:00:00.00Z.image_lev1.fits'
;     PREPPED fits:
;        'AIA20131228_10:00:00_1600.fits'

@parameters

instr = 'aia'
channel = '304'
;channel = '1600'
;channel = '1700'


resolve_routine, 'read_my_fits', /either
READ_MY_FITS, old_indices, old_data, fls, $
    instr=instr, $
    channel=channel, $
    nodata=0, $
    prepped=0, $
    year=year, $
    month=month, $
    day=day


;- Test to make sure that all downloaded files were read
;-  (and no extra files managed to sneak in)
help, fls
print, old_indices[0].date_obs
print, old_indices[-1].date_obs
stop


;- Pull up an image to see how it looks.
zz = 830
ct = AIA_colors( wave=fix(channel), /load )
imdata = old_data[*,*,zz]
im = image2( $
    aia_intscale(imdata, wave=fix(channel), exptime=old_indices[zz].exptime), $
    rgb_table=ct )
;-  ... pretty cool :)
stop


;-- § Run aia_prep.pro on old_indices and old_data, read using read_my_fits

outdir="/solarstorm/laurel07/Data/AIA_prepped/"
;outdir="/solarstorm/laurel07/Data/HMI_prepped/"

start_time = systime(/seconds)
print, systime()
AIA_PREP, old_indices, old_data, $
    index, data, $
    /do_write_fits, $
    outdir=outdir
print, ''
print, 'start time = ', start_time
print, 'end time   = ', systime()
print, ''
print, 'Time to run aia_prep: ', (systime(/seconds)-start_time)/60, ' minutes.'
stop


start:;-------------------------------------------------------------------------------

;- New routine: Switch to different file.


@parameters

;- § Read PREPPED fits files

resolve_routine, 'read_my_fits', /either
READ_MY_FITS, index, data, fls, $
    instr=instr, $
    channel=channel, $
    nodata=0, $
    prepped=1, $
    year=year, $
    month=month, $
    day=day


;- TEST: check n_elements(fls) and TIME portion of each filename.
;-    596 for AIA 1600
;-    594 for AIA 1700
;-    1195 for AIA 1700
print, n_elements(fls)
print, index[0].wave_str
print, index[0].lvl_num
print, index[0].date_obs
print, index[-1].date_obs
stop


;- § Crop to subset centered on AR,
;- Be sure to set dimensions AFTER calling @parameters
;-  Or edit parms directly

sz = size(data, /dimensions)

;- Index of image in center of time series.
;-  Use this image to determine center coords since it will be the
;-  reference image for alignment.
zz = sz[2]/2


dimensions = [1000, 800]
  ;- "Pad" dimensions with extra pixels to prepare for alignment

resolve_routine, 'crop_data', /either
imdata = CROP_DATA( $
    data[*,*,zz], $
    center=center, $
    dimensions=dimensions )

imdata = AIA_INTSCALE( $
    imdata, $
    wave=fix(channel), $
    exptime=index[zz].exptime )

im = image2( imdata, rgb_table=AIA_colors( wave=channel )

stop



;- Crop all data in variable "cube" once decided on center coords and dims.
resolve_routine, 'crop_data', /either
cube = CROP_DATA( $
    data, $
    center=center, $
    dimensions=dimensions )
;- NOTE: if kw "dimensions" isn't set, defaults to [500,330] in crop_data.pro

help, cube
stop


;AIA_LCT, wave=fix(channel), /load
xstepper2, cube, channel=channel, scale=0.75

stop

imdata = crop_data( hmi_data[*,*,0], center=center, dimensions=dimensions )


dw
;- 415 = one of three date_obs for AIA equal to 12:47:...
;-  (zz is not peak time!)

im = image2( $
    AIA_INTSCALE( $
        ;cube[*,*,zz], $
        cube[*,*,415], $
        wave=fix(channel), $
        exptime=index[zz].exptime ), $
    rgb_table=ct )


;hmi_imdata = rotate( hmi_data[*,*,2], 180
im = image2( $
    crop_data( $
        rotate(hmi_data[*,*,2], 2), $
        ;center=center+[373*2,448*2], $
        center=center, $
        dimensions=dimensions*(0.6/0.5) ), $
    max_value=300, min_value=-300 )



;- § Align prepped data
;- "align_data.pro" has lines of code at ML, so run using:
;- IDL> .run align_data

end
