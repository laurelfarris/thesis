;; Last modified:   22 February 2018 10:35:36




function get_jd, index
;pro get_jd, index, jd
    ; Use observation time from header to get individual time values
    timestamptovalues, index.t_obs, $
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
