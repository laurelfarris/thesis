;+
;- LAST MODIFIED:
;-   31 July 2019
;-
;- ROUTINE:
;-   compute_powermaps_main.pro
;-
;- EXTERNAL SUBROUTINES:
;-
;- PURPOSE:
;-   ML code for COMPUTING (not imaging!) power maps from aligned data. Steps:
;-     * restore aligned data cubes from, e.g. aia1600aligned.sav files
;-     * define time segments: start indices, length of each (T), ...
;-     * save maps to, e.g. aia1600maps.sav if long computation time is required.
;-
;- TO DO:
;-   [] Come up with better filename for main code (avoid capital letters...)
;-      This could also be ML code in same file as compute_powermaps.pro,
;-      not sure if I want to do that... gets sloppy real fast.
;-
;- KNOWN BUGS:
;-
;- AUTHOR:
;-   Laurel Farris
;-
;+


;-
;----
;- Restore aligned data cube, show movie in xsteppper to double check that
;-  alignment looks okay and that edge pixels are trimmed appropriately.
;-


@parameters

;- Read headers from PREPPED fits files
resolve_routine, 'read_my_fits', /either
READ_MY_FITS, /syntax
READ_MY_FITS, index, data, nodata=1, prepped=1

;- Restore data (var = 'cube')
path = '/solarstorm/laurel07/' + year + month + day + '/'
filename = instr + channel + 'aligned.sav'
print, path + filename
restore, path + filename
help, cube

;cube = CROP_DATA(/syntax)
cube = CROP_DATA(cube)
help, cube


;-
;----
;- Interpolate missing images (if needed)
;-

;cadence = 24 --> defined in @parameters
;time = strmid( index.date_obs,  11, 11 )
;jd = get_jd( index.date_obs + 'Z' )
FIND_MISSING_IMAGES, cadence, index.date_obs, time, jd, dt

gaps = where(dt ne cadence)
print, dt[gaps]

print, index[gaps].date_obs, format='(A0)'

print, index[gaps+1].date_obs, format='(A0)'


;if channel eq 'aia'
resolve_routine, 'linear_interp', /either
LINEAR_INTERP, cube, jd, time, gaps

;- Show movie of cropped time series, make sure everything looks okay.
xstepper2, cube, channel=channel



;-
;- Everything up to here is fairly general, not specific to power
;-  maps in any way...
;- In fact, this is exactly what my struc_aia routine does...
;-   (31 July 2019)
;-
;-



;-
;----
;- Set input values for computing maps (central freq, bandwidth, dz, etc.)
;-


print, strmid( index[  0].date_obs, 11, 11 )
print, strmid( index[149].date_obs, 11, 11 )

dz = 150 ;- = ~1 hour for 24-second cadence
;- 3-elements array for z_start: BDA
z_start = intarr(3)
;- start index for "During" = GOES start time
locs = where( strmid(index.date_obs,11,5) eq strmid(gstart,0,5) )
;- decided to use 12:30 instead of 12:31:... for cleaner labeling of figures
;-    (is close enough... for purposes of finishing SHINE poster -- 31 July 2019)
locs = where( strmid(index.date_obs,11,5) eq '12:30' )
z_start[1] = locs[0]
z_start[0] = locs[0] - dz
z_start[2] = locs[0] + dz
print, z_start

print, index[z_start].date_obs, format='(A0)'



;- Only part of this code that actually CREATES power map..
;-  Everything else needs to be done even after maps are created
;-  and saved..
resolve_routine, 'compute_powermaps', /either
map = COMPUTE_POWERMAPS( /syntax )
map = COMPUTE_POWERMAPS( cube, cadence, z_start=z_start, dz=dz )


mapfilename = instr + channel+ 'map.sav'
print, mapfilename
print, path + mapfilename

save, map, filename=path + mapfilename


end
