;+
;- MODIFIED:
;-

;+
;- 11 June 2021
;-   Added kw flare; defined at ML by calling @par2 and extracting single flare.
;-
;-  [] Find a way to avoid restoring cube if already done so (need jd, time, etc. ??)
;-  [] .run mcb as a SCRIPT, so it can be done within a subroutine.
;-  [] Comment 'if' statement in linear_interp? Copied to test before calling,
;-        but shouldn't cause any problems if test twice (just means that inside linear_interp,
;-        condition will always be true, at least when called from struc_aia).
;+
;-   29 January 2020
;-     Made a copy "struc_aia_OLD.pro", cleaned up current version (a lot...).
;+
;- 21 July 2020
;-   [] omit large arrays from structures (data, map),
;-        ... simply commented the line assigned tag/value in final structure
;-          definition before returning it to ML... should do s/t better, eventually
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


;-
;- PURPOSE:
;-   Read AIA headers and restore .sav files (data)
;-
;- EXTERNAL SUBROUTINES
;-   read_my_fits.pro
;-   get_jd.pro
;-   missing_obs.pro
;-   linear_interp.pro
;-   crop_data.pro
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


function STRUC_AIA, $
    index, $
    cube, $
    flare=flare, $
    cadence=cadence, $
    instr=instr, $
    channel=channel, $
    ind=ind


    ;- Parameters specific to individual flare
    ;@parameters

    class = strlowcase(strjoin(strsplit(flare.class, '.', /extract)))
    year = flare.year
    month = flare.month
    day = flare.day

    ;path = '/solarstorm/laurel07/' + year + month + day + '/'

    @path_temp
    ;path = '/solarstorm/laurel07/flares/' + class + '_' + year + month + day + '/'
    ;path = '../flares/' + class + '_' + year + month + day + '/'
    ; 14 August 2021 relative path while solarstorm is down (usually not ideal...)
    flare_path =  path + 'flares/' + class + '/'
    ; 18 July 2022 -- removed date from flare directory and [future] file names

    ;=============================================================================
    ;===

    ;+
    ;- Restore HEADERS

    if n_elements(index) eq 0 then begin

        index_file = flare_path + class + '_' + instr + channel + 'header.sav'

        if FILE_EXIST( index_file ) then begin

            print, ''
            print, 'Restore EXISTING header file: ', flare_path+index_file
            print, ''
            restore, index_file

        endif else begin

            print, ''
            print, 'Call READ_MY_FITS and save header to file: ', index_file
            print, ''

            resolve_routine, 'read_my_fits'
            READ_MY_FITS, index, $
                flare=flare, $
                instr=instr, $
                channel=channel, $
                nodata=1, $
                prepped=1  ;, $
                ;year=year, $ month=month, $ day=day

            ;- 15 June 2021
            ;-   Save index to .sav file in same location as aligned cube .sav files;
            ;-   much more straightforward to retrieve headers this way.
            help, index[0]
            save, index, filename = index_file + '_NEW'
                ; may to rename from '<fname>.sav_NEW' so "NEW" (or date" is before the .sav extension...

        endelse

        ;- If saving header to file is the only thing I need to do, return to ML now.
        ;return, 0

    endif

    ;- confirm level 1.5, not 1.0


; This is not working:
;    if strmid( strtrim(index[0].lvl_num,1), 0,3) ne '1.5' then begin
;        print, 'FITS headers are for level ', $
;            strtrim(index[0].lvl_num,1), ' data.'
;        print, 'Need to modify code to read level 1.5 data (i.e. processed with aia_prep)'
;    endif
    print, index[0].lvl_num
    print, 'type ".c" if level is 1.5'
    stop


    ;+
    ;- Restore (aligned) DATA CUBE

    ;- Restore data in variable "cube", with pixel dimensions:
    ;- 2011-02-15
    ;-   AIA 1600 [750,500,745]
    ;-   AIA 1700 [750,500,749]
    ;- 2013-12-28
    ;-   AIA 1600 [1000,800,596]
    ;-   AIA 1700 [1000,800,594]


    ;if n_elements(cube) eq 0 then begin
      ;- Only restore cube from .sav file once...
      ;-  Unfortunately, variables 'time' and 'jd' are generated in the same code
      ;-      ( WHAT code?? Comments need to be CLEAR and unambiguous! Even if repetitive... -- 18 July 2022)
      ;-    that crops and interpolates cube.
      ;-  Maybe those should be two separate routines?
      ;-

        data_file  = class + '_' + instr + channel + 'aligned.sav'
        if FILE_EXIST( flare_path + data_file ) then begin
            restore, flare_path + data_file
        endif else begin
            print, '=========================================================='
            print, '>>> aligned data cube file:'
            print, '   ', flare_path+data_file
            print, ' not found!!  <<<'
            print, '=========================================================='
            stop
        endelse
;    endif

    help, cube ; --> INT [1000, 800, 596]  (AIA 1600, 2013 flare)

    ;===
    ;=============================================================================

    time = strmid(index.date_obs,11,11)
    resolve_routine, 'get_jd', /is_function
    jd = GET_JD( index.date_obs + 'Z' )

    ;- Restore shifts to be interpolated (variable name = "shifts" or "aia1600shifts")
    ;restore, flare_path + instr + channel + 'shifts.sav'

    ;+
    ;- Check for MISSING DATA, compute INDICES where dt NE cadence
    resolve_routine, 'missing_obs'
    MISSING_OBS, cadence, index.date_obs, $
        interp_coords, time, jd, dt

    ;- interpolate to get missing data and corresponding timestamp
    if interp_coords[0] ne -1 then begin
        print, "Missing observations! Interpolation needed."
        resolve_routine, 'linear_interp'
        LINEAR_INTERP, cube, jd, time, interp_coords;, shifts=shifts
        ;-  (NOTE: still need to write code to apply interpolation to shifts).

        ;cube --> FLOAT [1000, 800, 600]  (AIA 1600, 2013 flare)

    endif


    ;+
    ;- Trim excess pixels from cube (leftover from alignment process)
    resolve_routine, 'crop_data', /is_function
    print, '============================================='
    print, 'cube prior to cropping:'
    help, cube
    cube = CROP_DATA( cube, dimensions=dimensions ); , center=center )
        ;- kw DIMENSIONS = [500,330,*] by default if undefined
        ;-   (same outcome if set but not defined, or not present in call to subroutine at all).
        ;- kw CENTER [x,y] = center of cube by default
        ;-   Aligned cube is already centered, so default is what we want.
        ;-   (If "out of range" error occurs, may have set dims = AR coords relative to full disk.
        ;-   Only need to set center when, e.g. extracting from full disk, or locating ROIs.
    print, 'cube after cropping:'
    help, cube
    print, '============================================='

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


    ;+
    ;- Lower left corner of AR (arcsec)
    x1 = flare.xcen - (sz[0]/2)*index[0].cdelt1
    y1 = flare.ycen - (sz[1]/2)*index[0].cdelt2

    ;+
    ;- Create ARRAY of AR coordinates using subset dimensions, relative to lower left corner (x1,y1),
    ;-   then convert from pixels to arcseconds.
    ;X = (  ( x1 + indgen(sz[0]) ) - index[0].crpix1  ) * index[0].cdelt1
    ;Y = (  ( y1 + indgen(sz[1]) ) - index[0].crpix2  ) * index[0].cdelt2

    ;- 15 June 2021:
    ;-   [x1,y1] already in arcsec, just need to convert array values (originally sep by 1)
    ;- Define ARRAY of coords (still arcsec) for image x/y tick labels
    X = x1 + findgen(sz[0])*index[0].cdelt1
    Y = y1 + findgen(sz[1])*index[0].cdelt2


    ;+
    ;- Calculate TOTAL FLUX over AR (integrated emission) --> Lightcurves!
    
    ;cube = float(cube)
    ;flux = fltarr( sz[2] )

    flux = total( total( cube, 1), 1 )
        ;- NOTE: function "TOTAL" returns FLOAT data type, even if array is INT.
    flux_avg = mean( mean( cube, dimension=1), dimension=1 )
        ;- ditto for MEAN


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
        date: flare.date, $  ;- from @parameters (03 Aug 2019)
        channel: channel, $
        cadence: cadence, $
        exptime: exptime, $
        data: float(cube), $
        ;data: (float(cube))[*,*,0:-2], $
        X: X, $
        Y: Y, $
        flux: flux, $
        ;flux: flux[0:-2], $
        time: time, $
        ;time: time[0:-2], $
        jd: jd, $
        ;jd: jd[0:-2], $
        color: '', $
        ct: ct, $
        ;map: map, $
        name: name $
    }

    return, struc
end


;== Call function to return structure with ALL flares
;     (no longer using @parameters OR @par2)
;multiflare = multiflare_struc()

;== Choose flare
;flare = multiflare.c30
;flare = multiflare.c46
;flare = multiflare.c83
;flare = multiflare.m10
;flare = multiflare.m15
;flare = multiflare.m73
;flare = multiflare.x22

;class = 'c83'
;class = 'm73'
class = 'x22'

flare = multiflare_struc(flare_id=class)

aia1600 = STRUC_AIA( aia1600index, aia1600data, cadence=24., instr='aia', channel='1600', flare=flare )
aia1600.color='blue'

aia1700 = STRUC_AIA( aia1700index, aia1700data, cadence=24., instr='aia', channel='1700', flare=flare )
aia1700.color='red'

mismatched_dimensions = where( size(aia1600.data, /dimensions) ne size(aia1700.data, /dimensions) )
print, mismatched_dimensions

if mismatched_dimensions ne -1 then begin

    print, 'need to modify one of the channel structures by hand before continuing.'
    stop

    print, aia1600index[0].t_obs
    print, aia1700index[0].t_obs
    print, aia1600index[-1].t_obs
    print, aia1700index[-1].t_obs

    ; 18 July 2022
    ;   Re-do aia1600 for c83 flare to remove first z-element in arrays for cube, jd, time, and flux
    ;    since 1700 has missing obs at BEGINNING of time series and there's no way to interpolate
    ;    (or TEST for existence for that matter, b/c no time difference to test for 'not equal 24 seconds'...
    aia1600 = { $
            date: aia1600.date, $
            channel: aia1600.channel, $
            cadence: aia1600.cadence, $
            exptime: aia1600.exptime, $
            data: aia1600.data[*,*,1:-1], $
            X: aia1600.X, $
            Y: aia1600.Y, $
            flux: aia1600.flux[1:-1], $
            ;flux: flux[0:-2], $
            time: aia1600.time[1:-1], $
            ;time: time[0:-2], $
            jd: aia1600.jd[1:-1], $
            ;jd: jd[0:-2], $
            color: '', $
            ct: aia1600.ct, $
            ;map: map, $
            name: aia1600.name $
        }
endif

A = [ aia1600, aia1700 ]

stop

undefine, aia1600
undefine, aia1600index
undefine, aia1600data
undefine, aia1700
undefine, aia1700index
undefine, aia1700data


stop ;---------------------------------------------------------

; 18 July 2022
;   Seems like a good time to save 'A' so don't have to run this every time....
save, A, filename = class + '_struc.sav'


;help, /memory
    ;-  No idea how to interpret the output from this...

print, A.date

end
