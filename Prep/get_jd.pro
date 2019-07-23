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



function GET_JD, timestampstring

    ; Use timestamp string to get individual time values
    TIMESTAMPTOVALUES, timestampstring, $
        day=day, $
        hour=hour, $
        minute=minute, $
        month=month, $
        offset=offset, $
        second=second, $
        year=year

    ; Covert observations times to JD
    jd = JULDAY(month, day, year, hour, minute, second)

    return, jd
end
