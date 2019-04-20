;+
;- LAST MODIFIED:
;-   12 April 2019
;-
;- PURPOSE:
;-   This will eventually be a general routine for reading in data from
;-     AIA or HMI for any filename/date/time. Probably will all be at ML
;-     like vsoget.pro, with parameters like tstart/end, filenames,
;-     inst/channel, potentially useful headers, etc.
;-     commented with default values so can clearly see what form each
;-     variable needs to be in.
;-
;- INPUT:
;-
;- KEYWORDS:
;-
;- OUTPUT:
;-
;- TO DO:
;- [] Need different routine for querying/downloading
;- [] Rename file from today.pro to something
;-      that communicates that this routine CALLS aia_prep, but
;-      also does other stuff... I dunno.
;- [] Pre-prep.pro? Since prep.pro creates structures using stuff that's
;-      already prepped..


goto, start
start:;-------------------------------------------------------------------------------


;-- § Run vsoget to query/download data

;- Peak time 12:47
;- Class C3.0
;- 28 December 2013
;- Prepped file names: /solarstorm/laurel07/Data/AIA_prepped/
;-   "AIAyyyymmdd_hhmmss_channel.fits", where channel = 1600, 1700, 304, ...

tstart = '2013/12/28 10:00:00'
tend   = '2013/12/28 13:59:59'




;- Naming convention of fits files for, e.g. AIA 1600\AA{}
;
;     UNprepped fits:
;        'aia.lev1.1600A_2013-12-28T10:00:00.00Z.image_lev1.fits'
;
;     PREPPED fits:
;        'AIA20131228_10:00:00_1600.fits'


;-- § Read fits files (downloaded, NOT prepped)

year = '2013'
month = '12'
day = '28'

instr = 'aia'
;channel = '304'
channel = '1600'
;channel = '1700'

;files = 'aia' + '.lev1.' + '1600' + 'A_' + '2013-12-28T10:00:00.00Z.image_lev1.fits'
files = $
    instr + '.lev1.' + channel + 'A_' + $
    year + '-' + month + '-' + day + $
    'T' + '*Z.image_lev1.fits'
;- wildcard for observation times (asterisk) because I want all the data
;-  I have for this day. Otherwise, entire string is hardcoded in, which
;- shouldn't be a problem as long as AIA filenames are consistent.

resolve_routine, 'read_my_fits', /either
READ_MY_FITS, old_indices, old_data, fls, $
    instr=instr, $
    channel=channel, $
    ;ind = [10:15], $ --> should set start/end times, rather than z-values
    nodata=0, $
    prepped=0, $
    year=year, $
    month=month, $
    day=day

;- Test to make sure that all downloaded files were read
;-  (and no extra files managed to sneak in)
help, fls
;-  What else to do here?

stop


;-- § Run aia_prep.pro (after using read_my_fits on lev1.0 data)
;-      One channel at a time!

outdir="/solarstorm/laurel07/Data/AIA_prepped/"
;outdir="/solarstorm/laurel07/Data/HMI_prepped/"

files = instr + "*" + strtrim(channel, 1) + "*" + year + "*.fits"

;print, old_indices[0].date_obs
;print, old_indices[-1].date_obs

AIA_PREP, old_indices, old_data, $
    index, data, $
    /do_write_fits, $
    outdir=outdir

stop

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


;- § Crop to subset centered on AR,
;-     padded with extra pixels on all four sides (mostly in x-direction)

sz = size(data, /dimensions)

;- Index of image in center of time series.
;-  Use this image to determine center coords since it will be the
;-  reference image for alignment.
z_ref = sz[2]/2

center = [1675, 1600]
dimensions = [800, 500]
  ;- "Pad" dimensions with extra pixels to prepare for alignment


resolve_routine, 'crop_data', /either
cube = CROP_DATA( $
    data, $
    center=center, $
    dimensions=dimensions )
;- NOTE: if kw "dimensions" isn't set, defaults to [500,330] in crop_data.pro

AIA_LCT, wave=fix(channel), /load
xstepper, cube

stop


;- § Align prepped data

ref = cube[*,*,z_ref]
ALIGN_CUBE3, cube, ref, $
    ;quiet=quiet, $
    shifts=shifts

;- Save shifts.

;- Plot shifts.

;- Check that images don't jump around.
xstepper, cube

;- Run ALIGN_CUBE3 until shifts stop decreasing from one run to the next.



;- Save cube to .sav files, including extra "padding" pixels.
save, cube, instr + channel + '_' + 'aligned.sav'
;-    May need to add something indicated which FLARE this is...
;-    Or create a different directory for each flare.


end
