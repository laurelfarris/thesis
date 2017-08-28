;; Last modified:   15 August 2017 16:32:28

;+
; ROUTINE:      get_missing_indices.pro
;
; PURPOSE:      Get indices of missing data
;
; USEAGE:
;
; INPUT:
;
; KEYWORDs:
;
; OUTPUT:
;
; TO DO:
;
; AUTHOR:       Laurel Farris
;
;KNOWN BUGS:
;-


function GET_MISSING_INDICES, index, cadence

    t = []
    for i = 0, n_elements(index)-1 do begin
        t = [ t, GET_TIMESTAMP(index[i].date_obs, /sunits) ]
    endfor

    dt = t - shift(t,1)

    ; Start at index 1 because wrapping of SHIFT will give a false value at beginning of array
    missing = ( where(dt ne cadence) );[1:*]

    return, missing

end
