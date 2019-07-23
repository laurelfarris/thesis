;+
;- Last modified:   23 July 2019
;-
;- ROUTINE:      Prep.pro
;-
;- EXTERNAL SUBROUTINE(S):
;-
;- PURPOSE:
;  Get indices of missing data by subtracting each observation
;  time from the previous time.
;- Find "holes" between consecutive images where
;-   dt (difference in observation time)
;-   does not equal the instrumental cadence, aka:
;-   index[N].date_obs - index[N-1].date_obs NE cadence
;-   (assuming date_obs is in seconds, which it's not, but is converted here)
;-
;- USEAGE:
;-
;- AUTHOR:       Laurel Farris
;-
;+


function FIND_MISSING_IMAGES, jd, cadence, time

    ; Use time to get julian date
    ;jd = GET_JD( timestampstring )

    ;- difference in jd from one image to the next -- small fraction of a day.
    dt = jd - shift(jd,1)

    ; convert from days to seconds
    dt = dt * 24 * 3600

    ; Exclude first element because of wrapping from SHIFT.
    dt = dt[1:*]

    ; use FIX to convert data type from LONG to INT
    dt = fix(round(dt))
      ;- NOTE: dt was calculated from jd, which should be type DOUBLE,
      ;-   therefore dt should be double at this point,
      ;-   but here I seemed to think it was LONG...
      ;- [] double check this (23 July 2019)
    print, TYPENAME(dt)
    stop;-------------------------------------------------------------------


    ; Print where there's a gap in the data (between i-1 and i)
    interp_coords = where(dt ne cadence)

    return, interp_coords
end
