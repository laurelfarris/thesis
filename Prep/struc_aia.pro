;+
;- MODIFIED:
;-   29 January 2020
;-     Made a copy "struc_aia_old.pro" to preserve old codes & comments.
;-     Cleaned up current code (a lot...).
;-
;- PURPOSE:
;-   Read AIA headers and restore .sav files (data)
;-
;- EXTERNAL SUBROUTINES
;-   read_my_fits.pro
;-   crop_data.pro
;-   missing_obs.pro
;-   linear_interp.pro
;-
;-
;- INPUT:
;-
;- KEYWORDS:
;-
;- OUTPUT:
;-
;- NOTES:
;-   Unprepped filename:
;-    aia.lev1.channelA_yyyy-mm-ddThh_mm_ss.ssZ.image_lev1.fits
;-   Prepped filename:
;-    AIAyyyymmdd_hhmmss_channel.fits
;+


function STRUC_AIA, index, cube, $
    cadence=cadence, $
    instr=instr, $
    channel=channel, $
    ind=ind


    ;- Parameters specific to individual flare
    @parameters

    ;- Read headers only from Prepped fits files,
    ;-   return as variable "index"
    if n_elements(index) eq 0 then begin
        resolve_routine, 'read_my_fits'
        READ_MY_FITS, index, $
            instr=instr, $
            channel=channel, $
            nodata=1, $
            prepped=1  ;, $
            ;year=year, $ month=month, $ day=day
    endif

    print, ''
    print, 'Reading header for level ', $
        strtrim(index[0].lvl_num,1), ' data.'
    print, ''

    ;- Restore data in variable "cube", with pixel dimensions:
    ;- 2011-02-15
    ;-   AIA 1600 [750,500,745]
    ;-   AIA 1700 [750,500,749]
    ;- 2013-12-28
    ;-   AIA 1600 [1000,800,596]
    ;-   AIA 1700 [1000,800,594]


    ;if n_elements(cube) eq 0 then begin
      ;- Originally written to skip restoring cube from .sav file if this
      ;-  routine had already been run, to save time.
      ;-  Unfortunately, can't skip this step because
      ;-  the variables 'time' and 'jd' are generated in the same code
      ;-  that crops and interpolates cube.
      ;-  Maybe those should be two separate routines... not top priority right now.

    path = '/solarstorm/laurel07/' + year + month + day + '/'
    restore, path + instr + channel + 'aligned.sav'
    help, cube ; --> INT [1000, 800, 596]  (AIA 1600, 2013 flare)

    time = strmid(index.date_obs,11,11)
    jd = GET_JD( index.date_obs + 'Z' )

    ;- Restore shifts to be interpolated
    ;restore, path + instr + channel + 'shifts.sav'
    ;- is variable "shifts", or "aia1600shifts" ?
    ;help, shifts
    ;help, aia1600shifts
    ;stop

    ;+
    ;- 23 July 2019:
    ;-  Split linear_interp.pro into two routines:
    ;-   1. calculate interp_coords, then 2. apply interpolation to array(s).
    ;- Removed "cadence" arg from calling sequence of interpolation routine.
    ;-  (NOTE: still haven't written code to apply interpolation to shifts).
    ;-

    ;- Find INDICES of missing data (if any)
    resolve_routine, 'missing_obs'
    MISSING_OBS, cadence, index.date_obs, interp_coords, time, jd, dt

    ;- interpolate to get missing data and corresponding timestamp
    resolve_routine, 'linear_interp'
    ;LINEAR_INTERP, cube, jd, cadence, time;, shifts=shifts
    LINEAR_INTERP, cube, jd, time, interp_coords;, shifts=shifts
    ;- NOTE: cadence is an input argument to this code :)
    ;help, cube ; --> FLOAT [1000, 800, 600]  (AIA 1600, 2013 flare)

    ;- NOTE: original center coords should NOT be used for cropped data.
    ;-  (will be "out of range"). This keyword is more useful when starting with
    ;-  full disk, or zooming in on ROIs within AR.
    ;- If not provided, crop_data.pro computes center using provided dimensions,
    ;-   which is what we want here.
    ;- If dimensions are not provided, default = [500,330,*] (2011 flare dimensions).


    resolve_routine, 'crop_data', /is_function
    cube = CROP_DATA( cube, dimensions=dimensions )
        ;- 09 November 2020
        ;-   NOTE: cube is aligned subset centered on AR. No need to pass kw center=[x,y] because
        ;-     crop_data.pro uses center of input data by default, which is what we want here.
        ;-
    ;print, max(cube)

    ;help, cube ; --> FLOAT [dim[0], dim[1], 600]  (AIA 1600, 2013 flare)
    ;cube = fix( round( cube ) )

    ;- Correct for exposure time (standard data reduction)
    ;-  Does this apply to HMI as well?
    exptime = index[0].exptime
    ;print, 'Exposure time = ', strtrim(exptime,1), ' seconds.'
    ;cube = cube/exptime
    ;- exptime is type DOUBLE, so now cube is too...
    ;help, cube ; --> DOUBLE [dim[0], dim[1], 600]  (AIA 1600, 2013 flare)

    sz = size( cube, /dimensions )

    ; X/Y coordinates of AR, converted from pixels to arcseconds
    X = ( (indgen(sz[0]) + x1) - index[0].crpix1 ) * index[0].cdelt1
    Y = ( (indgen(sz[1]) + y1) - index[0].crpix2 ) * index[0].cdelt2

    ;- Calculate total flux over AR
    ;cube = float(cube)
    ;flux = fltarr( sz[2] )
    flux = total( total( cube, 1), 1 )
    ;flux = mean( mean( cube, dimension=1), dimension=1 )


    ;- Standard AIA colors
    AIA_LCT, r, g, b, wave=fix(channel);, /load
    ct = [ [r], [g], [b] ]

    name = 'AIA ' + channel + '$\AA$'

    ;- 14 Decemer 2018
    ;map = fltarr( sz[0], sz[1], 686 )
    ;map = make_array( sz[0], sz[1], 686, /float, /nozero )
    ;- Not sure if /nozero helps free up memory, but worth a shot.

    ;- MEMORY - Is this making copies of everything?
    struc = { $
        date: date, $  ;- from @parameters (03 Aug 2019)
        channel: channel, $
        cadence: cadence, $
        exptime: exptime, $
        data: float(cube), $
        X: X, $
        Y: Y, $
        flux: flux, $
        time: time, $
        jd: jd, $
        color: '', $
        ct: ct, $
        ;map: map, $
        name: name $
    }
    return, struc
end


;+
;- 21 July 2020
;-   [] omit large arrays from structures (data, map),
;-        ... simply commented the line assigned tag/value in final structure
;-          definition before returning it to ML... should do something better
;------    eventually.
;-   [] ADD variables defined in parameters.pro
;-   [] define all three flare structures at the same time,
;-   [] create one big multi-flare structure with 3 tags (one for each flare),
;-       whose values are the structure(s), for that flare
;-       (2 structures per falre at the moment: one for 1600, one for 1700)...
;-     ==>> [] what about when I start including HMI data???
;-   [] SAVE final structure(s) to .sav file(s)
;-       --> no longer necessary to run STRUC_AIA unless to change someting
;-           in the structure (hasn't been done in quite a while....)
;-


;- IDL> @parameters

aia1600 = STRUC_AIA( aia1600index, aia1600data, cadence=24., instr='aia', channel='1600' )
aia1700 = STRUC_AIA( aia1700index, aia1700data, cadence=24., instr='aia', channel='1700' )


A = [ aia1600, aia1700 ]
undefine, aia1600
undefine, aia1600index
undefine, aia1600data
undefine, aia1700
undefine, aia1700index
undefine, aia1700data
A[0].color = 'blue'
A[1].color = 'red'

stop ;---------------------------------------------------------


;help, /memory
    ;-  No idea how to interpret the output from this...

print, A.date

stop

;s1 = A
;s2 = A
s3 = A

stop

multiflare_struc = { s1:s1, s2:s2, s3:s3 }

help, multiflare_struc

save, multiflare_struc, filename='multiflare_struc.sav'

end
