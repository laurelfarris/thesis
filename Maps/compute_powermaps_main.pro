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
instr = 'aia'
channel = '1600'
;channel = '1700'

;- Read headers from PREPPED fits files
resolve_routine, 'read_my_fits', /either
READ_MY_FITS, /syntax
READ_MY_FITS, index, data, instr=instr, channel=channel, nodata=1, prepped=1

;- Restore data (var = 'cube')
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


;- Show movie of cropped time series, make sure everything looks okay.
xstepper2, cube, channel=channel

;-
;- Everything up to here is fairly general, not specific to power
;-  maps in any way...
;- In fact, this is exactly what my struc_aia routine does...
;-   (31 July 2019)
;-

;+
;-
;-----------------------------------------------------------------
;-
;-

;- input values for computing maps


@parameters
cc = 0
;cc = 1
;dz = 150 ;- = ~1 hour for 24-second cadence
dz = 64
;- 3-elements array for z_start: BDA
z_start = intarr(3)
;locs = where( strmid(index.date_obs,11,5) eq strmid(gstart,0,5) )
locs = where( strmid(A[cc].time,0,5) eq strmid(gstart,0,5) )
;- start index for "During" = GOES start time
z_start[1] = locs[0]
z_start[0] = locs[0] - dz
z_start[2] = locs[0] + dz
print, z_start
;print, index[z_start].date_obs, format='(A0)'
print, A[cc].time[z_start], format='(A0)'





;+
;- Compute power maps.
;-

;- some of these are defined above, but that entire section can be
;-  skipped if doing a general powermap computation from entire data cube,
;-  using same value for dz I've been using.  -- 20 January 2020 
@parameters
cc = 0
dz = 64
sz = size(cube, /dimensions)
help, cube
print, sz
z_start = [0:sz[2]-dz]
help, z_start

;- print out calling sequence, in case I forgot what args/kws to pass
;-  and in what order (which I probably did).
resolve_routine, 'compute_powermaps', /either
map = COMPUTE_POWERMAPS( /syntax )

;- start computation of power map for 'cube'
resolve_routine, 'compute_powermaps', /either
map = COMPUTE_POWERMAPS( cube, cadence, dz=dz, z_start=z_start )
    ;- standard call to compute map from restored, aligned data
help, map

;map = COMPUTE_POWERMAPS( A[cc].data, A[cc].cadence, z_start=z_start, dz=dz )
    ;- specific values for z_start, dz, etc.

;channel = A[cc].channel
mapfilename = 'aia' + channel + 'map.sav'
print, mapfilename
print, path + mapfilename

save, map, filename=path + mapfilename


end
