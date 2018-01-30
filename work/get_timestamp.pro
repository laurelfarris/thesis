;; Last modified:   14 August 2017 19:18:00

;; tstr = time string from header, e.g.:  '2011-02-15T00:00:00.00'


; Reference to indices for index.date_obs:
;   2011-02-15  T   00:00:00.00
;   0123456789  10  11-21



function GET_TIMESTAMP, tstr, $
    sunits=sunits, munits=munits, hunits=hunits

    year = strmid( tstr, 0, 4 )
    month = strmid( tstr, 5, 2 )
    day = strmid( tstr, 8, 2 )
    hour = strmid( tstr, 11, 2 )
    minute = strmid( tstr, 14, 2 )
    second = strmid( tstr, 17, 2 )

    ; Total time since midnight (02 Feb 2011)

    if keyword_set(sunits) then return, second + minute*60. + hour*3600. 
    if keyword_set(munits) then return, hour*60. + minute + second/60.
    if keyword_set(hunits) then return, hour + minute/60. + second/3600.

end


;; isolating 3-min period?  Comment your shit better...
; Want images closest to ~2:15 = 8100 seconds


; Seconds since midnight 15 February 2011 using timestamp string from fits header
hsec = get_timestamp( hmi_index.t_rec, /sunits )
;asec = get_timestamp( aia_index.t_rec, /sunits )





;; Move to FT codes?

h_peak = ( where( hsec gt 8100.0 ) )[0]
;a_peak = ( where( asec gt 8100.0 ) )[0]

print, strmid( hmi_index[h_peak].date_obs, 11, 8)
;print, strmid( aia_index[a_peak].date_obs, 11, 8)


; Seconds from one image to the next
;diff = total_seconds - shift( total_seconds, 1 )


;x = where( diff_seconds ne 45.0 )
;print, diff_seconds[x]



end
