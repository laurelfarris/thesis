;+
;- 03 May 2019
;- First block of comments below is from prep.pro
;-      (attempts to make one routine for both AIA and HMI)
;-
;-
;-
;- LAST MODIFIED: Thu Dec 20 06:33:23 MST 2018
;-   Added keyword "ind" to only return a subset of time series.
;-   However, code still reads in full data set and does all the calculations,
;-     so not sure if this actually frees any memory.
;-
;- PURPOSE:
;-   Combined prep routines for HMI and AIA.
;- CALLING SEQUENCE:
;-   struc = PREP( index, cube, cadence=cadence, instr=instr, channel=channel )
;- KEYWORDS:
;-   cadence - Enter manually because doesn't appear to be in headers.
;-   instr = 'aia' or 'hmi'
;-   channel
;-     1600 or 1700 for aia
;-     mag or cont for hmi
;- OUTPUT:
;-   Structure with tags:
;-   data = cropped data cube,
;-   X, Y = 2D coords in arcseconds (beginning of ts?),
;-   flux array (summed over AR and exposure-time corrected; NOT per pixel),
;-   time = observation time,
;-   jd = julian date of observation time,
;-   cadence = entered by user,
;-   channel = entered by user,
;-   ct = rgb_table,
;-   color = whatever color you want to plot that data in,
;-   name = combination of instrument and channel,
;-   map = initialzed array in which to restore powermaps from .sav files (later).
;-
;- TO DO:
;-   Initialize ct tag and any others that only apply to one instrument.
;-   Make a separate routine for reading in maps and power vs. time.
;-     Also need a different name for power vs. time.
;-      --> Google this, may be an actual analysis method with a real name.
;-   May need to rewrite this to separate everything that can be done
;-     without header information (like when I have access to .sav files,
;-     but not the fits files, where index is always extracted.
;-
;_____________________________________________________________________________________________
;-
;- LAST MODIFIED:
;-   03 May 2019
;-     Now that the "multi-flare" phase of my research has begun,
;-     added (string) arguments 'year', 'month', and 'day'
;-
;- PURPOSE:
;-   Read headers, restore .sav files (data), write important info/data into
;-     new structure to use in analysis routines.
;-
;- INPUT:
;-
;- KEYWORDS:
;-   instr - even though this routine is for aia only, may figure out how
;-          to combine multiple instruments in one routine, so leaving as
;-          general as possible
;-
;- OUTPUT:
;-
;- TO DO:
;-   [] Make a separate routine for reading in maps and power vs. time.
;       Also need a different name for power vs. time.
;      --> Google this, may be an actual analysis method with a real name.
;    [] May need to rewrite this to separate everything that can be done
;        without header information (like when I have access to .sav files,
;        but not the fits files, where index is always extracted.




function data_struc, index, cube, $
    ;year, month, day, $
    cadence=cadence, $
    instr=instr, $
    channel=channel, $
    ind=ind


    ;- Unprepped filenames:
    ;-   aia.lev1.channelA_yyyy-mm-ddThh_mm_ss.ssZ.image_lev1.fits
    ;-   hmi.ic_45s.yyyy.mm.dd_hh_mm_ss_TAI.continuum.fits
    ;-   hmi.v_45s.yyyy.mm.dd_hh_mm_ss_TAI.Dopplergram.fits
    ;-   hmi.m_45s.yyyy.mm.dd_hh_mm_ss_TAI.magnetogram.fits

    ;- Prepped filenames:
    ;-   AIAyyyymmdd_hhmmss_channel.fits
    ;-   HMIyyyymmdd_hhmmss_mag.fits
    ;-   HMIyyyymmdd_hhmmss_cont.fits
    ;-   HMIyyyymmdd_hhmmss_dop.fits


    ;- Parameters specific to individual flare
    @parameters

    ;- Read headers only from Prepped fits files, return as variable "index"
    if n_elements(index) eq 0 then begin
        resolve_routine, 'read_my_fits'
        READ_MY_FITS, index, instr=instr, channel=channel, $
            nodata=1, prepped=1, $
            year=year, month=month, day=day
    endif

;- Don't think lvl_num tag exists for hmi...
;-    print, 'Reading header for level ', $
;-        strtrim(index[0].lvl_num,1), ' data.'

; Restore data (in variable "cube", with pixel dimensions:
;   AIA [750,500,745] "../aia1600aligned.sav"
;   AIA [750,500,749] "../aia1700aligned.sav"
;   HMI [750,500,400] "../hmi_mag.sav"
;   HMI [750,500,398] "../hmi_cont.sav"

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

    if (strlowcase(instr) eq 'aia') then begin
        restore, path + 'aia' + channel + 'aligned.sav'
    endif
    if (strlowcase(instr) eq 'hmi') then begin
        restore, path + 'hmi_' + channel + '.sav'
    endif


    ;help, cube ; --> INT [1000, 800, 596]  (AIA 1600, 2013 flare)

    time = strmid(index.date_obs,11,11)
    resolve_routine, 'get_jd', /is_function
    jd = GET_JD( index.date_obs + 'Z' )

    ;- interpolate to get missing data and corresponding timestamp
    resolve_routine, 'linear_interp', /either
    LINEAR_INTERP, cube, jd, cadence, time
    ;help, cube ; --> FLOAT [1000, 800, 600]  (AIA 1600, 2013 flare)

    ;- NOTE: original center coords should NOT be used for cropped data.
    ;-  (will be "out of range"). This keyword is more useful when starting with
    ;-  full disk, or zooming in on ROIs within AR.
    ;- If not provided, crop_data.pro computes center using provided dimensions,
    ;-   which is what we want here.
    ;- If dimensions are not provided, default = [500,330,*] (2011 flare dimensions).
    ;- NOTE: dimensions are defined in @parameters
    cube = CROP_DATA(cube, dimensions=dimensions)
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

    ;x1 = 2150
    ;y1 = 1485
    ; NOTE: Hard coded coords of lower left corner;
    ;   can't automatically generate these values unless I somehow
    ;    save them when aligning or prepping the data.
    ;- UPDATE: Run @parameters to read in all values specific to desired flare
    ;-  (make sure the proper lines are commented first).

    ; X/Y coordinates of AR, converted from pixels to arcseconds
;    X = ( (indgen(sz[0]) + x1) - index.crpix1 ) * index.cdelt1
;    Y = ( (indgen(sz[1]) + y1) - index.crpix2 ) * index.cdelt2

    X = ( (indgen(sz[0]) + x1) - index[0].crpix1 ) * index[0].cdelt1
    Y = ( (indgen(sz[1]) + y1) - index[0].crpix2 ) * index[0].cdelt2

    ;- Calculate total flux over AR
    ;cube = float(cube)
    ;flux = fltarr( sz[2] )
    flux = total( total( cube, 1), 1 )


    ;if not keyword_set(ind) then ind = [0:sz[2]]
    if keyword_set(ind) then begin
        cube = cube[*,*,ind]
        flux = flux[ind]
        time = time[ind]
        jd = jd[ind]
    endif

    ;- Standard AIA colors
;    aia_lct, r, g, b, wave=fix(channel);, /load
;    ct = [ [r], [g], [b] ]

;    name = 'AIA ' + channel + '$\AA$'

    ;- 14 December 2018
    ;map = fltarr( sz[0], sz[1], 686 )
    ;map = make_array( sz[0], sz[1], 686, /float, /nozero )
    ;- Not sure if /nozero helps free up memory, but worth a shot.

    ;- MEMORY - Is this making copies of everything?
    struc = { $
        channel: channel, $
        cadence: cadence, $
        exptime: exptime, $
        data: cube, $
        X: X, $
        Y: Y, $
        flux: flux, $
        time: time, $
        jd: jd, $
        color: '', $
        ;ct: ct, $
        ct: BYTARR(256,3), $
        ;map: map, $
        ;name: name $
        name: '' $
    }
    return, struc

;    dic = dictionary( $
;        'data', cube, $
;        'jd', jd, $
;        'time', time, $
;        'cadence', cadence )
    ;aia = dictionary( 'aia1600', aia1600, 'aia1700', aia1700 )
end
