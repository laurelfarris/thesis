;+
;- 20 January 2020 -- 
;-   moved this monstrosity from compute_powermaps_main.pro,
;-     as it has nothing to do with creating power maps.
;-   Comment from 31 July 2019:
;-   "... this is exactly what my struc_aia routine does..."
;-
;-
;-----------------------
;+
;-
;- LAST MODIFIED:
;-   31 July 2019
;-
;- ROUTINE:
;-   prep_flare_data_cube.pro
;-
;-
;- EXTERNAL SUBROUTINES:
;-
;- PURPOSE:
;-
;- TO DO:
;-
;- KNOWN BUGS:
;-
;- AUTHOR:
;-   Laurel Farris
;-
;+

;-
;----
;-


@parameters
instr = 'aia'
channel = '1600'
;channel = '1700'

;- Read headers from PREPPED fits files
resolve_routine, 'read_my_fits', /either
READ_MY_FITS, /syntax
READ_MY_FITS, index, data, instr=instr, channel=channel, nodata=1, prepped=1

;- Restore aligned data cube (var = 'cube')
path = '/solarstorm/laurel07/' + year + month + day + '/'
filename = instr + channel + 'aligned.sav'
print, path + filename
restore, path + filename
help, cube

;cube = CROP_DATA(/syntax)
cube = CROP_DATA(cube)
help, cube

stop


;-
;----
;- Interpolate missing images (if needed)
;-

cadence = 24
;- --> defined in @parameters
;-   ... actually those lines are commented out (04 September 2019)
;time = strmid( index.date_obs,  11, 11 )
;jd = get_jd( index.date_obs + 'Z' )

MISSING_OBS, cadence, index.date_obs, gaps, time, jd, dt
    ;gaps = where(dt ne cadence) -- passed from missing_obs.pro
print, dt[gaps]
print, index[gaps].date_obs, format='(A0)'
;print, index[gaps+1].date_obs, format='(A0)'


;if channel eq 'aia'
resolve_routine, 'linear_interp', /either
LINEAR_INTERP, cube, jd, time, gaps
help, cube


;- movie of cropped time series, make sure alignment looks okay,
;-  edge pixels are trimmed appropriately, etc.
xstepper2, cube, channel=channel


end
