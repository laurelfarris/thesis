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


;-- § Run vsoget to query/download data

;- Peak time 12:47
;- Class C3.0
;- 28 December 2013
;- Prepped file names: /solarstorm/laurel07/Data/AIA_prepped/
;-   "AIAyyyymmdd_hhmmss_channel.fits", where channel = 1600, 1700, 304, ...

;tstart = '2013/12/28 10:00:00'
;tend   = '2013/12/28 13:59:59'


tstart = '28-Dec-2013 10:00:00'
tend   = '28-Dec-2013 13:59:59'

;- Ended IDL session after aia_prep completed.
;- See if GOES works now, at beginning of fresh session.
;- if it doesn't work with defaults, I don't know what to do..

a = OGOES()
a->set, tstart=tstart, tend=tend
d = a->getdata(/struct)

;gdata = GOES( tstart=tstart, tend=tend )
help, d
;- Did not work. I don't know what's happening...


stop


;-- § Read fits files (downloaded, NOT prepped)

;- Naming convention of fits files for, e.g. AIA 1600\AA{}
;
;     UNprepped fits:
;        'aia.lev1.1600A_2013-12-28T10:00:00.00Z.image_lev1.fits'
;
;     PREPPED fits:
;        'AIA20131228_10:00:00_1600.fits'


year = '2013'
month = '12'
day = '28'

instr = 'aia'
;channel = '304'
;channel = '1600'
channel = '1700'
stop


;- Don't think "files" needs to be defined at ML anymore...
;-  this is done in read_my_fits.pro, using user input parameters for
;-  year, month, day, instr, etc
;files = instr + "*" + strtrim(channel, 1) + "*" + year + "*.fits"
;files = 'aia' + '.lev1.' + '1600' + 'A_' + '2013-12-28T10:00:00.00Z.image_lev1.fits'
files = $
    instr + '.lev1.' + channel + 'A_' + $
    year + '-' + month + '-' + day + $
    'T' + '*Z.image_lev1.fits'
;- wildcard for observation times (asterisk) because I want all the data
;-  I have for this day. Otherwise, entire string is hardcoded in, which
;- shouldn't be a problem as long as AIA filenames are consistent.
help, files

stop

start_time = systime()
resolve_routine, 'read_my_fits', /either
READ_MY_FITS, old_indices, old_data, fls, $
    instr=instr, $
    channel=channel, $
    ;ind = [10:15], $ --> should set start/end times, rather than z-values
    ;ind = [0:19], $
    nodata=0, $
    prepped=0, $
    year=year, $
    month=month, $
    day=day

print, ''
print, 'start time = ', start_time
print, 'end time   = ', systime()
print, ''

;- Test to make sure that all downloaded files were read
;-  (and no extra files managed to sneak in)
help, fls

print, old_indices[0].date_obs
print, old_indices[-1].date_obs

stop


;-- § Run aia_prep.pro (after using read_my_fits on lev1.0 data)
;-      One channel at a time!

outdir="/solarstorm/laurel07/Data/AIA_prepped/"
;outdir="/solarstorm/laurel07/Data/HMI_prepped/"

start_time = systime()
AIA_PREP, old_indices, old_data, $
    index, data, $
    /do_write_fits, $
    outdir=outdir
print, ''
print, 'start time = ', start_time
print, 'end time   = ', systime()
print, ''

stop





year = '2013'
month = '12'
day = '28'

instr = 'aia'
;channel = '304'
;channel = '1600'
channel = '1700'

;- § Read PREPPED fits files

start_time = systime()
resolve_routine, 'read_my_fits', /either
READ_MY_FITS, index, data, fls, $
    instr=instr, $
    channel=channel, $
    nodata=0, $
    prepped=1, $
    year=year, $
    month=month, $
    day=day

print, ''
print, 'start time = ', start_time
print, 'end time   = ', systime()
print, ''
stop





;- TEST: check n_elements(fls) and TIME portion of each filename.
;-    596 for AIA 1600
;-    594 for AIA 1700
print, n_elements(fls)
print, index[0].wave_str
print, index[0].lvl_num
print, index[0].date_obs
print, index[-1].date_obs
stop


;- § Crop to subset centered on AR,
;-     padded with extra pixels on all four sides (mostly in x-direction)

ct = AIA_COLORS( wave=channel )

sz = size(data, /dimensions)

;- Index of image in center of time series.
;-  Use this image to determine center coords since it will be the
;-  reference image for alignment.
z_ref = sz[2]/2


center = [1675, 1600]
dimensions = [1000, 800]
  ;- "Pad" dimensions with extra pixels to prepare for alignment

resolve_routine, 'crop_data', /either
imdata = CROP_DATA( $
    data[*,*,z_ref], $
    center=center, $
    dimensions=dimensions )

imdata = AIA_INTSCALE( $
    imdata, $
    wave=fix(channel), $
    exptime=index[z_ref].exptime )

im = image2( imdata, rgb_table=ct )

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

;- Downloaded a few HMI B_LOS images to see what magnetic field looks like
read_my_fits, hmi_index, hmi_data,  $
    instr='hmi', $
    channel='mag', $
    nodata=0, $
    prepped=0, $
    year=year, $
    month=month, $
    day=day
stop

imdata = crop_data( hmi_data[*,*,0], center=center, dimensions=dimensions )


dw
;- 415 = one of three date_obs for AIA equal to 12:47:...
;-  (z_ref is not peak time!)

im = image2( $
    AIA_INTSCALE( $
        ;cube[*,*,z_ref], $
        cube[*,*,415], $
        wave=fix(channel), $
        exptime=index[z_ref].exptime ), $
    rgb_table=ct )


;hmi_imdata = rotate( hmi_data[*,*,2], 180
im = image2( $
    crop_data( $
        rotate(hmi_data[*,*,2], 2), $
        ;center=center+[373*2,448*2], $
        center=center, $
        dimensions=dimensions*(0.6/0.5) ), $
    max_value=300, min_value=-300 )

stop




;- § Align prepped data

;ref = cube[*,*,z_ref]
;ALIGN_CUBE3, cube, ref, $
;    ;quiet=quiet, $
;    shifts=shifts
;shifts1 = shifts
;aia1600_shifts = [ [[shifts1]], [[shifts]] ]



start_time = systime()

ref = cube[*,*,z_ref]
;- Run ALIGN_CUBE3 until shifts stop decreasing from one run to the next.
ALIGN_DATA, cube, ref, shifts
print, ''
print, 'start time = ', start_time
print, 'end time   = ', systime()
print, ''
stop



help, shifts
stop





aia1700_shifts = shifts

;- Save shifts to file.
print, instr + channel + '_shifts.sav'
stop

save, aia1700_shifts, filename=instr + channel + '_shifts.sav'
stop

;print, max( all_shifts[0,*,0] )
;print, max( all_shifts[0,*,5] )

;- Plot shifts.
;plt = plot2( shifts[0,*], color='red' )
;plt = plot2( shifts[1,*], color='blue', overplot=1 )

;- Check that images don't jump around.
xstepper2, cube, channel=channel, scale=0.75

stop

start:;-------------------------------------------------------------------------------


;- Save cube to .sav files, including extra "padding" pixels.

path = '/solarstorm/laurel07/2013-12-28/'
;- Gave each flare its own directory

filename = instr + channel + '_' + 'aligned.sav'
print, path+filename
stop

save, cube, filename=path+filename
;-    May need to add something indicated which FLARE this is...
;-    Or create a different directory for each flare.


end
