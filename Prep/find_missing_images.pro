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


function FIND_MISSING_IMAGES, jd, cadence, time

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

cadence = 24

year=['2012', '2014']
month=['03', '04']
day=['09', '18']

;channel='1600'
channel='1700'

;nn = 0  ;- M6.3 -- 09 March 2012 flare
nn = 1  ;- M7.3 -- birthday flare
stop

start:;---------------------------------------------------------------------------

ind=[0:130]

READ_MY_FITS, index, data, fls, $
    instr='aia', $
    channel=channel, $
    ind=ind, $
    nodata=0, $
    prepped=0, $
    year=year[nn], $
    month=month[nn], $
    day=day[nn]

;- get indices of missing images (gaps), where each z-index points to location
;-  of an observation that is followed by an observation NE previous obs + cadence
time = strmid( index.date_obs, 11, 11 )
jd = GET_JD( index.date_obs + 'Z' )
gaps = FIND_MISSING_IMAGES( jd, cadence, time )
stop

time = strmid( index.date_obs, 11, 8 )

dt = []
  ;- # seconds between consecutive observation times in header

foreach zz, gaps, ii do begin
    jd1 = GET_JD( index[zz].date_obs + 'Z' )
    jd2 = GET_JD( index[zz+1].date_obs + 'Z' )
    dt = [ dt,  (jd2 - jd1) * 24 * 3600  ]

    ;print, gaps[zz], '  ', index[ gaps[zz] ].date_obs
    print, strmid(zz,9,3), '-', strmid(zz+1,9,3), '   ', $
        time[zz], '--', time[zz+1], '   ', $
        'dt = ', strtrim(dt[ii],1), ' sec'
        ;'dt = ', round( strtrim(dt[ii],1) ), ' sec'

endforeach
stop


locs = where( round(dt) ne 48 )
print, round(dt[locs])

end
