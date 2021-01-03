;+
;-  MODIFIED:
;-
;-  03 January 2021
;-    ==>> Make this better!!
;-
;-  18 December 2020
;-    Made copy (apply_aia_prep_20201218.pro) and condensed current version,
;-    modified to be more general.
;-
;-    NOTE:  Copy is actually called apply_aia_prep_20200508.pro ...
;-    latest DATE in comments toward bottom of file is 08 May 2020, so
;-    that's probably the "last modified" date, but copy wasn't made until
;-    18 December 2020.  (03 January 2021)
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


buffer = 1

;@parameters

;- HMI ---
;instr = 'hmi'
;channel = 'cont'
;channel = 'mag'

;- AIA ---
instr = 'aia'
channel = '1600'
;channel = '1700'

year = 2013
month = 08
day = 30


;- z-indices for subset of full time series for given flare:
;ind = []


;- Make sure all values are STRINGS in clase entered as integers
;-   (which is exactly what I did just now... )
channel = strtrim( channel, 1 )
instr = strtrim( instr, 1 )
year = strtrim( year, 1 )
month = strtrim( month, 1 )
day = strtrim( day, 1 )


print, ''
print, 'UNprepped AIA data.'
path = '/solarstorm/laurel07/Data/' + strupcase(instr) + '/'


stop

;- single string to use when searching for files : concatenation of
;-   standard syntax, variables defined with specific values for this flare, and
;-   WILDCARDS to include all timestamps (which are different for each file, obv...
;-   each sep. by cadence for that instr/channel).
files = $
    strlowcase(instr) + '.lev1.' + channel + 'A_' + $
    year + '-' + month + '-' + day + $
    'T' + '*Z.image_lev1.fits'
help, files
;-  Single string, I assume?
;-  Is this better than using FILE_SEARCH directly?
;-   Guess it looks a little cleaner, een tho creating extra variables as
;-   intermediate step (as shown in next step).


stop

;- Confirm files with user.
fls = file_search( path + files )
if N_elements(ind) ne 0 then fls = fls[ind]
  ;- Error if "ind" is undefined? Not kw at ML...
  ;- ==>> [] Test using, e.g. IDL> print, n_elements(undefined_variable)
print, n_elements(ind)
print, n_elements(fls), ' file(s) returned, in variable "fls".'
print, 'Type .c to read files, or RETALL to return to main level.'

STOP


;- Read fits files (and show computation time):
start_time = systime()
print, 'start time = ', start_time
READ_SDO, fls, index, data, nodata=nodata
print, 'end time = ', systime()


;- If this isn't working, use @params like before...
;-  really need to get aia_prep started.

;=============================================================


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
