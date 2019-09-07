;-
;-  Using "data_struc.pro" now.
;-  This file was saved after an unfortunate and careless conflict in git
;-   repositories, but probably not needed. Pretty sure it was renamed to
;-   data_struc... (21 May 2019)
;-
;-
;- LAST MODIFIED:
;-   21 April 2019
;-     Now that the "multi-flare" phase of my research has begun,
;-     added (string) arguments 'year', 'month', and 'day'
;-
;- PURPOSE:
;-   Read AIA headers and restore .sav files (data)
;- INPUT:
;- KEYWORDS:
;-   instr - even though this routine is for aia only, may figure out how
;-          to combine multiple instruments in one routine, so leaving as
;-          general as possible
;-
;- OUTPUT:
;- TO DO:

; May need to rewrite this to separate everything that can be done
; without header information (like when I have access to .sav files,
; but not the fits files, where index is always extracted.

;- TO DO: make a separate routine for reading in maps and power vs. time.
;         Also need a different name for power vs. time.
;         --> Google this, may be an actual analysis method with a real name.



function STRUC_AIA, index, cube, $
    ;year, month, day, $
    cadence=cadence, $
    instr=instr, $
    channel=channel, $
    ind=ind


    ;- Unprepped filename:
    ;-  aia.lev1.channelA_yyyy-mm-ddThh_mm_ss.ssZ.image_lev1.fits
    ;- Prepped filename:
    ;-  AIAyyyymmdd_hhmmss_channel.fits



    ;- Parameters specific to individual flare
    @parameters

    ;- Read headers only from Prepped fits files, return as variable "index"
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

    dic = dictionary( $
        'data', cube, $
        'jd', jd, $
        'time', time, $
        'cadence', cadence )
    ;aia = dictionary( 'aia1600', aia1600, 'aia1700', aia1700 )
end

;---- 03 August 2019
;@parameters
;restore, '../20140418/aia1600aligned.sav'
;cube = cube[*,*,1:749]
;save, cube, filename="aia1600aligned.sav"

;- 1.
;- initialize 'A' as a !NULL variable,
;A = []
;A = [A, STRUC_AIA( aia1600index, aia1600data, cadence=24., instr='aia', channel='1600' ) ]
;A = [A, STRUC_AIA( aia1700index, aia1700data, cadence=24., instr='aia', channel='1700' ) ]


;- 2.
;- Define individual structure for each channel, use to create 'A',
;-  then set = 0 to clear memory.
aia1600 = STRUC_AIA( aia1600index, aia1600data, cadence=24., instr='aia', channel='1600' )
aia1700 = STRUC_AIA( aia1700index, aia1700data, cadence=24., instr='aia', channel='1700' )
;aia1600.color = 'dark orange'
;aia1700.color = 'dark cyan'
A = [ aia1600, aia1700 ]

;aia1600 = !NULL
;aia1700 = !NULL
;- or
;delvar, aia1600
;delvar, aia1700

;A[0].color = 'dark orange'
;A[1].color = 'dark cyan'
A[0].color = 'blue'
A[1].color = 'red'

;print, 'NOTE: aia1600index, aia1600data, aia1700index, and aia1700data'
;print, '         still exist at ML. '
;print, 'Type ".c" to undefine redundant variables.'
;stop

undefine, aia1600
undefine, aia1600index
undefine, aia1600data
undefine, aia1700
undefine, aia1700index
undefine, aia1700data


stop


;--------------------------------------------------------------------------

;- Create different routine for doing this. Leave comment here directing user
;-  to this routine to avoid confusion.
print, ''
print, ''
print, '   Type ".CONTINUE" to restore power maps.'
print, ''
stop

help, A[0].data
@restore_maps
help, A[1].data

;for cc = 0, 1 do begin
;    restore, '../aia' + A[cc].channel + 'map_2.sav'
;    A[cc].map = map
;endfor
stop

; To do: save variables with same name so can call this from subroutine.
restore, '../power_from_maps.sav'
;power_from_maps = aia1600power_from_maps
;save, power_from_maps, filename='aia1600power_from_maps.sav'
;power_from_maps = aia1700power_from_maps
;save, power_from_maps, filename='aia1700power_from_maps.sav'

;A[0].power_maps = aia1600power_from_maps
;A[1].power_maps = aia1700power_from_maps

;------------------------------------------------------------------------------------

; A = replicate( struc, 2 )
; ... potentially useful?
; need to re-read data, but not headers... commented in subroutine for now.

;------------------------------------------------------------------------------------

;- 23 September 2018
A[0].data = A[0].data > 0
;  thought aia_prep produced data with no negative numbers, but not
;   sure why I thought so...

    resolve_routine, 'get_power_from_flux', /either
    power_flux = GET_POWER_FROM_FLUX( $
        flux=flux, $
        cadence=cadence, $
        dz=64, $
        fmin=0.005, $
        fmax=0.006, $
        norm=0, $
        data=cube )

    restore, '../aia' + channel + 'map.sav'

        ;power_flux: power_flux, $
        ;power_maps: fltarr(685), $
        ;map: fltarr(sz[0],sz[1],685), $
        ;map: map, $
end
