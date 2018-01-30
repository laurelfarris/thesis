;; Last modified:   15 August 2017 00:29:47

;+
; ROUTINE:      main.pro
;
; PURPOSE:      Reads fits headers and restores data from .sav files.
;               Creates arrays of total flux, and calls routine for power spectrum images,
;                   using time information from the headers for "during" and "all".
;
; USEAGE:       @main.pro
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
;KNOWN BUGS:
;-




pro hmi_prep, index, $
    date_obs


    ;; Fill in gaps in date_obs
    arr = index.date_obs
    str = '2011-02-15T'
    new = [ str + '02:52:57.40', $
        str + '03:16:57.40', $
        str + '03:40:57.40', $
        str + '04:16:57.40' ]
    c1 = interp_coords[0]
    c2 = interp_coords[1]
    c3 = interp_coords[2]
    c4 = interp_coords[3]
    date_obs = [ $
        arr[ 0:c1-1 ], new[0], $
        arr[ c1:c2-1 ], new[1], $
        arr[ c2:c3-1 ], new[2], $
        arr[ c3:c4-1 ], new[3], $
        arr[ c4:* ] ]

end
