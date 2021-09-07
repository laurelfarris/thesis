;+
;- MODIFIED:
;-   04 April 2018
;-     created
;-   16 May 2018 22:14:06
;-     What did I do? Poor commenting...
;-   04 April 2020
;-     Updated comments/documentation at top of file... was terrible.
;-     (same for get_time.pro).
;-   02 September 2021
;-     Added loop so input can be array of many timestamp strings..
;-
;- ROUTINE:
;-   get_jd.pro
;-
;- PURPOSE:
;-   Function takes time string as (only) argument and
;-     returns julian date.
;-   Uses timestamp string to get individual time values
;-     by calling IDL function JULDAY
;-
;- USEAGE:
;-   jd = GET_JD(time_str)
;-
;- NOTE:
;-   Called BY linear_interp.pro (which itself is called by struc_aia,
;-     or whatever I'm calling it now -- 04 April 2020 )
;-
;- AUTHOR:
;-   Laurel Farris
;-



function GET_JD, timestampstring

    
    jd = []
    for ii = 0, n_elements(timestampstring)-1 do begin

        TIMESTAMPTOVALUES, timestampstring[ii], $
            day=day, $
            hour=hour, $
            minute=minute, $
            month=month, $
            second=second, $
            year=year, $
            offset=offset

        ; Covert observations times to JD
        jd = [jd, JULDAY(month, day, year, hour, minute, second)]

    endfor

    return, jd
end
