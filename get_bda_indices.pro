;; Last modified:   18 August 2017 12:01:16

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


pro get_bda_indices, index, t1, t2

    ;; find coordinates of image at start of flare and image at end of flare
    times = strmid(index.date_obs, 11, 5)
    t1 = (where( times eq '01:20' ))[0]
    t2 = (where( times eq '03:10' ))[-1]

    return

    ;; From different code:

    fb = flux[0:t1-1]
    fd = flux[t1:t2]
    fa = flux[t2+1:*]

    cube_b = hmi_cube[*,*,0:t1-1]
    cube_d = hmi_cube[*,*,t1:t2]
    cube_a = hmi_cube[*,*,t2+1:*]

    ;; Power spectrum images
    ps_before = FA_2D( cube_before, delt )
    ps_during = FA_2D( cube_during, delt )
    ps_after = FA_2D( cube_after, delt )


end

get_bda_indices, hmi_index, ht1, ht2
get_bda_indices, aia_1600_index, a6t1, a6t2
get_bda_indices, aia_1700_index, a7t1, a7t2


end
