;+
;-  MODIFIED:
;-
;-    18 December 2020
;-      Made copy (apply_aia_prep_20201218.pro) and condensed current version,
;-      modified to be more general.
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


buffer = 1


@parameters
;C8.3 2013-08-30 T~02:04:00


;- HMI ---
;instr = 'hmi'
;channel = 'cont'
;channel = 'mag'

;- AIA ---
instr = 'aia'
channel = '1600'
;channel = '1700'


;-- § Read fits files (downloaded, NOT prepped)
;-
;- only need data with observation times between 14:00:00 and 14:59:59
;-  for the 2013-12-28 C3.0 flare ...  (04 May 2020)
resolve_routine, 'read_my_fits', /either

;- show READ_MY_FITS calling syntax
;READ_MY_FITS, /syntax

READ_MY_FITS, old_index, old_data, fls, $
    instr=instr, $
    channel=channel, $
    nodata=1, $
    prepped=0



;- add "ind" kw (z-dimension, effectively) for final 5 hours...
;-  --> Does processing data that has already been processed simply skip those files?
;-        Or would overlap tack on a lot of time? Don't want to leave any files out,
;-        so seems safe to overlap "ind" to times before 14:00 just in case.



print, old_index[-1].date_obs
print, strmid(old_index[-1].date_obs,11,8)

dz = 64
z1 = (where( strmid(old_index.date_obs, 11, 5) eq '02:00' ))[0]
z2 = z1 + dz -1
print, z1, z2
print, old_index[z1].date_obs
print, old_index[z2].date_obs

stop
;------

ind = [z1:z2]
;
print, n_elements(ind)
print, (n_elements(ind)*24)/60.
;
READ_MY_FITS, old_index, old_data, fls, $
    instr=instr, $
    channel=channel, $
    ind=ind, $
    nodata=0, $
    prepped=0
;
help, old_index
help, old_data


;- Test start/end times and total number of downloaded files
help, fls
print, old_index[0].date_obs
print, old_index[-1].date_obs

stop


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
;
im = image2( $
    imdata, $
    rgb_table=ct, $   ;- Pretty sure 0 is the default
    buffer=buffer )
;-  ... pretty cool :)
;
;filename = 'aia1600image_pre-aia_prep'
filename = instr + strtrim(channel,1) + '_image_UNprepped'
;save2, 'test_final_hour_for_2013_flare'
save2, filename


stop


;-- § Run aia_prep.pro on old_index and old_data, read using read_my_fits

outdir="/solarstorm/laurel07/Data/" + strupcase(instr) + "_prepped/"
print, ""
print, "saving prepped files to ", outdir

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
