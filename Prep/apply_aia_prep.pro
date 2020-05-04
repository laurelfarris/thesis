;+
;- DATES MODIFIED:
;-
;-   04 May 2020
;-     • Improved comments at top of file
;-     • Processing 5th and final hour of 2013-12-28 flare (04 May 2020)
;-
;-   22 April 2019
;-     (did something useful I'm sure... perhaps date routine was created?)
;-
;-
;- PURPOSE:
;-   General routine (ideally):
;-     1.  read level 1.0 data from file (/ss/laurel07/Data/[Inst]/whatever.fits)
;-     2.  run aia_prep
;-     3.  save new fits files.
;-  2. and 3. are accomplished simultaneously I think, but whatev.
;-
;- INPUT:
;-   NONE, contains ML code only (no procedures or functions),
;-     where flare-specfic variables are defined with call to "@parameters".
;-
;-  ==>>  NOTE: user must edit parameters.pro to index of desired flare!
;-
;- USEAGE:
;-   uncomment variables INSTR and CHANNEL
;-
;- KEYWORDS:
;-
;- OUTPUT:
;-
;- TO DO:
;-   [] change so that all channels can be processed in one run
;-      (currently have to comment each channel one by one ... )
;-


;+
;- Naming convention of fits files for, e.g. AIA 1600\AA{}
;     UNprepped fits:
;        'aia.lev1.1600A_2013-12-28T10_00_00.00Z.image_lev1.fits'
;        'aia.lev1.304A_2013-12-28T10_00_00.00Z.image_lev1.fits'
;     PREPPED fits:
;        'AIA20131228_100000_1600.fits'
;        'AIA20131228_100000_0304.fits'
;-



;-- § Read fits files (downloaded, NOT prepped)

@parameters

;- HMI ---
;instr = 'hmi'
;channel = 'cont'
;channel = 'mag'

;- AIA ---
instr = 'aia'
;channel = '304'
channel = '1600'
;channel = '1700'

;-
;- only need data with observation times between 14:00:00 and 14:59:59
;-  for the 2013-12-28 C3.0 flare ...  (04 May 2020)
resolve_routine, 'read_my_fits', /either

;- show calling syntax for read_my_fits procedure... author was so smart :)
READ_MY_FITS, /syntax

READ_MY_FITS, old_index, old_data, fls, $
    instr=instr, $
    channel=channel, $
    nodata=0, $
    prepped=0

;- add "ind" kw (z-dimension, effectively) for final 5 hours...
;-  --> Does processing data that has already been processed simply skip those files?
;-        Or would overlap tack on a lot of time? Don't want to leave any files out,
;-        so seems safe to overlap "ind" to times before 14:00 just in case.

help, fls
print, fls[0]
print, fls[-1]
print, fls[596]
print, fls[745]


;-
;- Run READ_MY_FITS on files with z_index kw (ind) set to read final hour only
;-   (150 observations for AIA 24-cadence channels)

;final_hour_2013_flare_ind = [596:745]
ind = [596:745]

print, n_elements(ind)
print, (n_elements(ind)*24)/60.

READ_MY_FITS, old_index, old_data, fls, $
    instr=instr, $
    channel=channel, $
    ind=ind, $
    nodata=0, $
    prepped=0

help, old_index
help, old_data


;- Test to make sure that all downloaded files were read
;-  (and no extra files managed to sneak in)
help, fls

print, old_index[0].date_obs
print, old_index[-1].date_obs


;-
;- image a 2D array of data to see how it looks.
sz = size(old_data, /dimensions)
zz = sz[2]/2
print, old_index[zz].date_obs
imdata = old_data[*,*,zz]
if instr eq 'aia' then begin
    ct = AIA_GCT( wave=fix(channel), /load )
    imdata = AIA_INTSCALE( $
        imdata, wave=fix(channel), exptime=old_index[zz].exptime)
endif else $
if instr eq 'hmi' then begin
    ct = 0
endif else $
    print, "Must set variable instr to 'hmi' or 'aia'."
;aiact = AIA_GCT( wave=fix(1600) )
;hmict = im.rgb_table


im = image2( $
    imdata, $
    rgb_table=ct, $   ;- Pretty sure 0 is the default
    buffer=buffer )
;-  ... pretty cool :)


;filename = 'aia1600image_pre-aia_prep'
filename = instr + strtrim(channel,1) + '_image_UNprepped'
;save2, 'test_final_hour_for_2013_flare'
save2, filename


;-- § Run aia_prep.pro on old_index and old_data, read using read_my_fits

outdir="/solarstorm/laurel07/Data/" + strupcase(instr) + "_prepped/"
;-
start_time = systime(/seconds)
AIA_PREP, old_index, old_data, $
    index, data, $
    /do_write_fits, $
    outdir=outdir
print, ''
print, 'Time to run aia_prep: ', (systime(/seconds)-start_time)/60, ' minutes.'
print, ''

end
