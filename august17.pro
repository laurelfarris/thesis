;; Last modified:   17 August 2017 13:15:29


goto, START

pro GET_INDICES, result, T, dT, t1, t2

    ;; Get indices for passband of periods/frequencies

    ;; Array of frequencies [Hz] and periods [seconds]
    frequency = result[0,*]
    period = 1./frequency
    power = result[1,*]

    indices = []

    for i = 0, n_elements(period)-1 do begin
        if ( period[i] ge T-dT ) && ( period[i] le T+dT ) then begin
            indices = [ indices, i ]
        endif
    endfor
    t1 = indices


    ;; Apparently this is all I need to do.
    ;; Tried using "&&" instead of "AND", but that didn't work... not sure why.

    indices = where( period ge T-dT AND period le T+dT )
    t2 = indices

    ;return, indices

end
;; May not need this procedure at all.



START: ;--------------------------------------------------------------------------------------------


end
