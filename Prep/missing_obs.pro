;+
;- LAST MODIFIED:
;-   23 July 2019
;-
;- ROUTINE:
;-   missing_obs.pro
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
;-   result = MISSING_OBS( jd, cadence, time )
;-
;- TO DO:
;-   [] Add kw option for tstart and tend ?
;-      Currently finds gaps between first and last obs, but doesn't
;-      account for data missing at beginning or end of time series.
;-    (03 January 2021)
;-
;-
;- AUTHOR:
;-   Laurel Farris
;-
;+


pro MISSING_OBS, $
    cadence, date_obs, $      ; required input
    gaps, $                   ; OUTPUT (main)
    time, jd, dt              ; output (optional, potentially interesting)
    ;syntax=syntax            ;  NOTE: jd and time arrays must be accessible to caller
                              ;   so they can then be interpolated and updated if needed.


    ;- Appears that I have not yet written code to show syntax yet...
    ;-   (03 January 2021)


    time = strmid( date_obs, 11, 11 )

    resolve_routine, 'get_jd', /is_function
    jd = GET_JD( date_obs + 'Z' )

    ;- difference in jd between consecutive observation times in header
    dt = jd - shift(jd,1)

    ; convert dt units from days to seconds
    ;- NOTE: here, 24 is the conversion from days to hours,
    ;-   NOT the cadence of AIA's UV channels
    days_to_hours = 24
    hours_to_minutes = 60
    minutes_to_seconds = 60
    dt = dt * days_to_hours * hours_to_minutes * minutes_to_seconds

    ; Exclude first element because of wrapping from SHIFT.
    dt = dt[1:*]

    ; convert data type from DOUBLE to INT
    ;- NOTE: function "ROUND" returns LONG data type
    dt = fix(round(dt))

    ; Print where there's a gap in the data (between i-1 and i)
    gaps = where(dt ne cadence)

end



;year=['2012', '2014']
;month=['03', '04']
;day=['09', '18']

@parameters
;instr='hmi'
;cadence = 45
;channel='cont'

;- index.cadence -- HMI, doesn't appear to be in AIA headers... ??

instr='aia'
cadence = 24
;channel='1600'
channel='1700'

;nn = 0  ;- M6.3 -- 09 March 2012 flare
;nn = 1  ;- M7.3 -- birthday flare


READ_MY_FITS, index, data, fls, $
    instr=instr, $
    channel=channel, $
;    ind=ind, $
    nodata=1, $
    prepped=0


;time = strmid( index.date_obs, 11, 11 )
;jd = GET_JD( index.date_obs + 'Z' )
MISSING_OBS, cadence, index.date_obs, gaps, time, jd, dt


time = ( strmid( index.date_obs, 11, 8 ) )

;dt = ( jd - shift(jd,1) ) * cadence * 3600
dt = ( shift(jd,-1) - jd ) * cadence * 3600
dt = fix(round(dt))

;help, where( dt eq cadence )
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
