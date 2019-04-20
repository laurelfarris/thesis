; Last modified:   04 June 2018
;
; ROUTINE:    align_data.pro
;
; PURPOSE:    Run align_cube3 on a loop until standard deviation
;              of shifts don't change by a significant amount.
;
; SUBROUTINES:  alignoffset.pro
;               shift_sub.pro
;               align_cube3.pro
;
; Alignment steps (in general):
;   1. read data
;   2. image center and locate center coords (x0, y0)
;   3. crop data to size 750x500 relative to center
;   4. Align
;   5. save to '*aligned.sav' file
;-



pro ALIGN_DATA, cube, ref, allshifts
    ; aligns data to reference image on a loop,
    ; using standard deviation of shifts as a breaking point
    ; (when it no longer decreases).

    ; save shifts calculated for every iteration.
    sz = size(cube, /dimensions)
    ;allshifts = fltarr( 2, sz[2] )
    allshifts = []

    sdv = []
    print, "Start:  ", systime()
    start_time = systime(/seconds)
    repeat begin
        ALIGN_CUBE3, cube, ref, shifts=shifts
        allshifts = [ [[allshifts]], [[shifts]] ]
        sdv = [ sdv, stddev( shifts[0,*] ) ]
        k = n_elements(sdv)
        print, sdv[k-1]
        if k eq 10 then break
    endrep until ( k ge 2 && sdv[k-1] gt sdv[k-2] )
    print, "End:  ", systime()
    print, format='(F0.2, " minutes")', (systime(/seconds)-start_time)/60.
end
