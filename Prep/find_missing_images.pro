;+
;- LAST MODIFIED:
;-   23 July 2019
;-
;- ROUTINE:
;-   find_missing_images.pro
;-
;- PURPOSE:
;-   Generalized code to read observation times from fits headers
;-   (index.date_obs) and display information about the missing images:
;-   what the z-indices are (or should have been), dt between images,
;-   number of consecutive images missing at each hole,
;-   (i.e. how LONG is each gap? Are there lots of intermittent gaps,
;-   randomly distributed throughout the full time series, or are there
;-   a few gaping holes where linear interpolation may not be an acceptable
;-   way to fill in missing data...)
;-
;-   Find indices of missing data using dt between observation times
;-   of consecutive images that WERE successfully downloaded
;-   ( where dt = index[N].date_obs - index[N-1].date_obs ,
;-   assuming date_obs is in seconds; it's not at first, but is converted here )
;-   and, where dt NE cad, returning the indices of index[N-1].
;-  --> IMPORTANT!! : Be sure to keep track of whether returned indices are for
;-    image[N] (observation BEFORE the missing one) or
;-    image[N-1] (observation AFTER the missing one)
;-
;- USEAGE:
;-   result = FIND_MISSING_IMAGES( jd, cadence, time )
;-
;- TO DO:
;-   []
;-
;- AUTHOR:
;-   Laurel Farris
;-
;+


function FIND_MISSING_IMAGES, jd, cadence, time, dt=dt


    ;- Compute number of images that should have been downloaded,
    ;-  given instrumental cadence and amount of obs. time queried (5 hours)
    ;- Not high priority right now...
    ;if keyword_set(dt) then n_expected_obs = fix(float(dt)/cadence)


    ;- difference in jd from one image to the next
    ;-   (24 seconds = small fraction of a day).
    dt = jd - shift(jd,1)

    ; convert units of "dt" from days to seconds
    dt = dt * 24 * 3600

    ; Exclude first element because of wrapping from SHIFT.
    dt = dt[1:*]

    ; convert data type from DOUBLE to INT
    dt = fix(round(dt))

    ; Print where there's a gap in the data (between i-1 and i)
    interp_coords = where(dt ne cadence)

    return, interp_coords
end


goto, start


year=['2012', '2014']
month=['03', '04']
day=['09', '18']

channel='1600'
;channel='1700'

;nn = 0  ;- M6.3 -- 09 March 2012 flare
nn = 1  ;- M7.3 -- birthday flare

;ind=[  0:149]  ; 150 files ... 750/5 = 150, should be 1 hour of data
;ind=[150:699]  ; remaining 550 files downloaded for AIA 1700Å (700 total)


READ_MY_FITS, index, data, fls, $
    instr='aia', $
    channel=channel, $
    ;ind=ind, $
    nodata=0, $
    prepped=0, $
    year=year[nn], $
    month=month[nn], $
    day=day[nn]

;foreach ind, index, ii do begin
    ;print, ind 
    ;- NOTE: each "ind" is a full header, since "index" is an array of structures.
    ;print, index[ii].date_obs
;endforeach
;- --> 2014-04-18T13:24:30.71

;- 23 July 2019:
;-  Testing "find_missing_images.pro", where coords of missing observations are
;-  determined in separated routine. Returned coords are then used to apply
;-  interpolations, or just to display WHERE missing images should have been,
;-  see if they're spread out or if there's a continuous time chunk of time with
;-  no data.
;-

cadence = 24
time = strmid( index.date_obs, 11, 11 )
jd = GET_JD( index.date_obs + 'Z' )

dt = 5 * 3600
interp_coords = FIND_MISSING_IMAGES( jd, cadence, time, dt=dt )
help, interp_coords
stop

time = strmid( index.date_obs, 11, 8 )

foreach ii, interp_coords do begin
    ;- Print indices where images are missing, along with
    print, ii, '  ', index[ii].date_obs
endforeach
stop

for ii = 0, n_elements(interp_coords)-2 do begin
    ;- Print # images (z-value) BETWEEN missing images
    ;-   Actually not sure this makes sense... come back when I'm less tired
    print, interp_coords[ii+1] - interp_coords[ii]
endfor
stop

print, ''
;for ii = 13, 19 do begin
dt = []
foreach zind, interp_coords, ii do begin
    jd1 = GET_JD( index[zind].date_obs + 'Z' )
    jd2 = GET_JD( index[zind+1].date_obs + 'Z' )
    dt = [ dt,  (jd2 - jd1) * 24 * 3600  ]

    ;print, interp_coords[zind], '  ', index[ interp_coords[zind] ].date_obs
    print, strmid(zind,9,3), '-', strmid(zind+1,9,3), '   ', $
        time[zind], '--', time[zind+1], '   ', $
        'dt = ', strtrim(dt[ii],1), ' seconds'

endforeach

start:;---------------------------------------------------------------------------

locs = where( round(dt) ne 48 )
print, round(dt[locs])


;print, format='( "Number of seconds between observations: ", F0.2)', dt


end
