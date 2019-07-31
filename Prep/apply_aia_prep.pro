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


;- Naming convention of fits files for, e.g. AIA 1600\AA{}
;     UNprepped fits:
;        'aia.lev1.1600A_2013-12-28T10:00:00.00Z.image_lev1.fits'
;        'aia.lev1.304A_2013-12-28T10:00:00.00Z.image_lev1.fits'
;     PREPPED fits:
;        'AIA20131228_10:00:00_1600.fits'
;        'AIA20131228_10:00:00_0304.fits'



;-- § Read fits files (downloaded, NOT prepped)

@parameters
instr = 'hmi'
channel = 'cont'
;channel = 'mag'
;instr = 'aia'  
;channel = '304'
;channel = '1600'
;channel = '1700'
resolve_routine, 'read_my_fits', /either
READ_MY_FITS, old_index, old_data, fls, $
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
print, old_index[0].date_obs
print, old_index[-1].date_obs


;- Pull up an image to see how it looks.
sz = size(old_data, /dimensions)
zz = sz[2]/2
print, old_index[zz].date_obs
imdata = old_data[*,*,zz]
if instr eq 'aia' then begin
    ct = AIA_COLORS( wave=fix(channel), /load )
    imdata = AIA_INTSCALE( $
        imdata, wave=fix(channel), exptime=old_index[zz].exptime)
endif else $
if instr eq 'hmi' then begin
    ct = 0
endif else $
    print, "Must set variable instr to 'hmi' or 'aia'."
;aiact = AIA_COLORS( wave=fix(1600) )
;hmict = im.rgb_table
im = image2( $
    imdata, $
    rgb_table=ct, $   ;- Pretty sure 0 is the default
    buffer=0 $
) ;-  ... pretty cool :)



filename = instr + strtrim(channel,1) + '_image_UNprepped'

;save2, 'aia1600image_pre-aia_prep'
save2, filename



;-- § Run aia_prep.pro on old_index and old_data, read using read_my_fits

outdir="/solarstorm/laurel07/Data/" + strupcase(instr) + "_prepped/"


start_time = systime(/seconds)
AIA_PREP, old_index, old_data, $
    index, data, $
    /do_write_fits, $
    outdir=outdir
print, ''
print, 'Time to run aia_prep: ', (systime(/seconds)-start_time)/60, ' minutes.'
print, ''

end
