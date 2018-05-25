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



;function get_jd, index
function get_jd, timestampstring
    ;; Last modified:   22 February 2018 10:35:36

    ; Use observation time from header to get individual time values
    ;timestamptovalues, index.t_obs, $
    timestamptovalues, timestampstring, $
        day=day, $
        hour=hour, $
        minute=minute, $
        month=month, $
        offset=offset, $
        second=second, $
        year=year
    ; Covert observations times to JD
    jd = julday(month, day, year, hour, minute, second)
    return, jd
end
