;+
;- MODIFIED:
;-   04 April 2018
;-     created
;-   16 May 2018 22:14:06
;-     What did I do? Poor commenting...
;-   04 April 2020
;-     Updated comments/documentation at top of file... was terrible.
;-     (same for get_jd.pro).
;-
;- ROUTINE:
;-   get_time.pro
;-
;- PURPOSE:
;-   Function takes julian date as (only) argument and
;-     returns time string in form hh:mm:ss.dd
;-   Uses jd to get time string by calling IDL procedure CALDAT.
;-
;- USEAGE:
;-   time = GET_TIME(jd)
;-
;- NOTE:
;-   Called BY linear_interp.pro (which itself is called by struc_aia,
;-     or whatever I'm calling it now -- 04 April 2020 )
;-
;- AUTHOR:
;-   Laurel Farris
;-


function GET_TIME, jd

    CALDAT, jd, month, day, year, hour, minute, second

    hour_string = strtrim(hour,1)
    minute_string = strtrim(minute,1)
    second_string = strtrim( fix(second),1)

    ; TEST that arrays are of equal length.
    NH = n_elements(hour)
    NM = n_elements(minute)
    NS = n_elements(second)
    if (NM ne NH) OR (NS ne NH) OR (NM ne NS) then $
        print, "Arrays are not of equal length!" $
        else N=NH

    ; create string array of the two digits that comprise the
    ;   nearest 100th of each value in second array.
    dec = strtrim( fix((second - fix(second))*100), 1)

    ; Append '0' to values with only one digit
    for i = 0, N-1 do begin
        if strlen(hour_string[i]) eq 1 then $
            hour_string[i] = '0' + hour_string[i]
        if strlen(minute_string[i]) eq 1 then $
            minute_string[i] = '0' + minute_string[i]
        if strlen(second_string[i]) eq 1 then $
            second_string[i] = '0' + second_string[i]
        second_string[i] = second_string[i] + '.' + dec[i]
    endfor

    return, hour_string + ':' + minute_string + ':' + second_string

end
