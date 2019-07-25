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


;function FIND_MISSING_IMAGES, cadence, date_obs, 
    ;- jd and time arrays must be accessible to caller so they can then be
    ;- interpolated and updated if needed.
function FIND_MISSING_IMAGES, cadence, time, jd

;    time = strmid( date_obs, 11, 11 )
;    jd = GET_JD( date_obs + 'Z' )

    ;- difference in jd between consecutive observation times in header
    dt = jd - shift(jd,1)

    ; convert dt units from days to seconds
    dt = dt * 24 * 3600

    ; Exclude first element because of wrapping from SHIFT.
    dt = dt[1:*]

    ; convert data type from DOUBLE to INT
    ;- NOTE: function "ROUND" returns LONG data type
    dt = fix(round(dt))

    ; Print where there's a gap in the data (between i-1 and i)
    interp_coords = where(dt ne cadence)

    return, interp_coords
end


goto, start
start:;---------------------------------------------------------------------------


year=['2012', '2014']
month=['03', '04']
day=['09', '18']

channel='1600'
;channel='1700'

;nn = 0  ;- M6.3 -- 09 March 2012 flare
nn = 1  ;- M7.3 -- birthday flare

READ_MY_FITS, index, data, fls, $
    instr='aia', $
    channel=channel, $
;    ind=ind, $
    nodata=1, $
    prepped=0, $
    year=year[nn], $
    month=month[nn], $
    day=day[nn]

stop

cadence = 24
;- index.cadence -- HMI, doesn't appear to be in AIA headers... ??


time = strmid( index.date_obs, 11, 11 )
jd = GET_JD( index.date_obs + 'Z' )
gaps = FIND_MISSING_IMAGES( cadence, time, jd )
;gaps = FIND_MISSING_IMAGES( cadence, index.date_obs )

time = ( strmid( index.date_obs, 11, 8 ) )

;dt = ( jd - shift(jd,1) ) * 24 * 3600
dt = ( shift(jd,-1) - jd ) * 24 * 3600
dt = fix(round(dt))

;help, where( dt eq 24 )
;help, where( dt eq 48 )
;help, where( dt eq 72 )

missing_string = $
    strmid(gaps,9,3) + '-' + strmid(gaps+1,9,3) + '     ' + $
        time[gaps] + ' - ' + time[gaps+1] + '     ' + $
        'dt = ' + strtrim(dt[gaps],1)

print, missing_string, format='(A)'
;- format='(A)' --> prints each element in array on a new line!
;-      Don't need to use a loop after all!

;foreach str, missing_string do print, str

end
