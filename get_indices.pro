;; Last modified:   21 July 2017 11:05:36

;+
; ROUTINE:      get_indices.pro
;
; PURPOSE:      Get indices (or values) of array based on some criteria
;
; USEAGE:       .run get_indices
;
; INPUT:        N/A
;
; KEYWORDs:     N/A
;
; OUTPUT:       N/A
;
; TO DO:        
;
; AUTHOR:       Laurel Farris
;
;KNOWN BUGS:    Cockroaches. I hate 'em.
;-


function get_indices, result, delt

    ;result = fourier2( cube2[500,500,*], delt )

    ;; Array of frequencies [Hz] and periods [seconds]
    frequency = result[0,*]
    period = 1./frequency
    power = result[1,*]

    T = 180.
    dT = 15.

    indices = []

    for i = 0, n_elements(period)-1 do begin
        if ( period[i] ge T-dT ) && ( period[i] le T+dT ) then begin
            indices = [ indices, i ]
        endif
    endfor

    return, indices

end
