

; input:    jd, interval (seconds), cadence (seconds)

pro get_times, jd, interval=interval, cadence=cadence, $
    t_start=t_start, t_end=t_end

    ;t_start = '00:30'
    ;t_end   = '04:30'

    time = strmid( update_time(jd), 0, 5 )
    i1 = (where( time eq t_start ))[1]
    i2 = (where( time eq t_end ))[-1]

    ; Indices for tick labels
    ;   30 minutes --> step = 75
    ;    5 minutes --> step = 12.5 (decimal step actually works! Calculated from 75/6.)

    ;ind = [i1:i2:75]
    ind = [0:n_elements(xdata):75]
    xtickvalues = A[0].jd[ind]


     = step / cadence

    for i = 0, n_elements(jd)-1 do begin
        caldat, jd[i], month, day, year, hour, minute, second
        hour = strtrim(hour,1)
        minute = strtrim(minute,1)
        xtickname = [ xtickname, hour + ':' + minute ]
    endforeach




; Use caldat to get times - ensures correct time for each jd
;xtickname = time[ind]
xtickname = []


end


test = get_times( A[0].jd, step=30 )

end
