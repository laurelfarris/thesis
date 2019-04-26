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
;        'aia.lev1.304A_2013-12-28T10:00:00.00Z.image_lev1.fits'
;     PREPPED fits:
;        'AIA20131228_10:00:00_1600.fits'
;        'AIA20131228_10:00:00_0304.fits'

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
    rgb_table=ct ) ;-  ... pretty cool :)
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
print, ''

end
