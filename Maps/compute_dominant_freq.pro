;+
;- CREATED:
;-   28 April 2022
;-
;- LAST MODIFIED:
;-   28 April 2022
;-   Copied compute_power_maps.pro, downsized to bare minimum code for computing a single map.
;-   Refer to original code to add extras back later.
;-
;- ROUTINE:
;-   compute_dominant_freq.pro
;-
;- EXTERNAL SUBROUTINES:
;-   fourier2.pro (not mine)
;-
;- PURPOSE:
;-   compute spatial distribution of dominant frequency
;-     ( ~ Kobanov2014; figure 2 )
;-
;- USEAGE:
;-   map = COMPUTE_DOMINANT_FREQ( $
;-     data, cadence, fmin=fmin, fmax=fmax, norm=norm )
;-
;- INPUT:
;-   data      3D data cube
;-   cadence   instrumental cadence at which data was sampled (seconds)
;-
;- KEYWORDS (optional):
;-   fmin,fmax     define range of frequencies to consider for max power
;-                   (probably wider than 3-min band, but may not want full range
;-                   of available frequencies if only interested in specific type of osc.)
;-   norm           sets /NORM kw when computing power using fourier2.pro
;-
;- OUTPUT:
;-    1D power map (not stepping small window through full data cube just yet..)
;-
;- TO DO:
;-   []
;-
;- NOTES:
;-
;- AUTHOR:
;-   Laurel Farris
;+

function COMPUTE_DOMINANT_FREQ, $
    data, $
    cadence, $
    fmin=fmin, $
    fmax=fmax, $
    norm=norm

    sz = size( data, /dimensions )

    ;- Make sure input is 3D (can't compute FFT otherwise...) -- 28 April 2022
    if ( n_elements(sz) eq 2 ) then begin
        print, 'Input data has insufficient dimensions (must be 3D to compute FFT in z-direction).'
        return, 0
    endif

    ;- Initialize 2D map variable
    map = fltarr( sz[0], sz[1] )
    help, map
    stop


    ; Array of available frequencies
    ;   Can get frequency resolution and range from cadence and duration of time series,
    ;   duration = cadence * # images 'N' = sz[2] = z-dimensions of data cube
    frequency = reform( (fourier2( indgen(sz[2]), cadence, NORM=NORM ))[0,*] )

    ; Define default values for optional keywords fmin and fmax
    if not keyword_set(fmin) then fmin = frequency[0]
    if not keyword_set(fmax) then fmax = frequency[-1]
    ind = where( frequency ge fmin AND frequency le fmax )

    freq_res = frequency[1] - frequency[0]
    print, ""
    print, "Frequency resolution = ", freq_res * 1000., " mHz"
    stop

    ;- Start computation

    start_time = systime(/seconds)
    print, ''
    print, 'Computation started ', systime()

    ;- Loop through each pixel location x,y
    for yy = 0, sz[1]-1 do begin
        for xx = 0, sz[0]-1 do begin

            ;- Extract LC at pixel loc x,y
            flux = data[ xx, yy, * ]

            ;- Apply FFT to time series to get power spectrum
            result = fourier2( flux, cadence, norm=norm )

            ;- Crop frequency and corresponding power arrays to desired range [fmin:fmax]
            frequency = (reform(result[0,*]))[ind]
            power = (reform(result[1,*]))[ind]

            ;- set map[x,y] = frequency where power = MAX( power )
            map[ xx, yy ] = frequency[ where( power eq max(power) ) ]
        endfor
    endfor

;    print, format='("Power maps calculated in ~", F0.2, " minutes")', $
    print, format='("Total runtime ~", F0.2, " minutes")', $
        (systime(/seconds) - start_time)/60
    print, format='( "(", F0.2, " hours.")', $
        (systime(/seconds) - start_time)/3660

    return, map
end



@par2
instr = 'aia'
channel = '1600'
;channel = '1700'

cadence = 24


;- Read headers from PREPPED fits files
;-   => save headers along with data cubes in .sav files!
;-     Restore together, don't need to read fits separately every time!
resolve_routine, 'read_my_fits', /either
READ_MY_FITS, /syntax
READ_MY_FITS, index, data, instr=instr, channel=channel, nodata=1, prepped=1

;- Restore data (var = 'cube')
;path = '/solarstorm/laurel07/' + year + month + day + '/'
@path_temp ; single-line code in main work dir.; temporary path to "work" while solarstorm is down
filename = instr + channel + 'aligned.sav'
;print, path + year + month + day + '/' + filename

if not (FILE_EXIST( path + year + month + day + '/' + filename)) then begin
    print, ""
    print, "  ==>> .sav file does not exist."
    print, ""
endif else begin
    restore, path + year + month + day + '/' + filename
endelse

;- Inspect restored data cube
help, cube

;- Crop to VERY small subset (i.e. single sunspot) over pre-flare window.
;-  [] Need easy / intuitive conversion from observation times to z-indices and v. v.

cube = CROP_DATA(/syntax)
;cube = CROP_DATA(cube) ; defaults to center, I think... not sure about x/y dimensions
;help, cube

stop


;- Missing images
time = strmid( index.date_obs,  11, 11 )
jd = get_jd( index.date_obs + 'Z' )
resolve_routine, 'linear_interp', /either
LINEAR_INTERP, cube, jd, time, gaps
help, cube

MISSING_OBS, cadence, index.date_obs, gaps, time, jd, dt
    ;gaps = where(dt ne cadence) -- passed from missing_obs.pro
print, dt[gaps]
print, index[gaps].date_obs, format='(A0)'
;print, index[gaps+1].date_obs, format='(A0)'
stop





;- Compute map

fmin = 0.001
fmax = 0.008
norm = 0
;norm = 1

map = COMPUTE_DOMINANT_FREQ( cube, cadence, fmin=fmin, fmax=fmax, norm=norm )

help, map

stop



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

; 29 June 2020 : skipping the above code means cube isn't defined... defining now:
cube = A[cc].data 
;
@parameters
cc = 0
dz = 64
;
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

end
