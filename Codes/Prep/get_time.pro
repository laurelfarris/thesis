;; Last modified:   16 May 2018 22:14:06

;+
;
; CREATED       04 April 2018
;
; ROUTINE:      Prep.pro
;
; PURPOSE:
;
; USEAGE:
;
; AUTHOR:       Laurel Farris
;
;-


function GET_TIME, jd
    ; Input jd and return string in form hh:mm:ss.dd

    caldat, jd, month, day, year, hour, minute, second

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
