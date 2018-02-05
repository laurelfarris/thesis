;; Last modified:   05 February 2018 14:17:50
;
; ROUTINE:    align_cube3
;
; PURPOSE:    align a series of images in a data cube to
;             the first image
;
; USEAGE:     align_cube3, cube
;
; INPUT:      cube = array of images (x,y,t)
;
; OUTPUT:     cube = data aligned to the middle image

; AUTHOR:     Peter T. Gallagher, July 2001
;             Altered by James McAteer March 2002 with ref optional
;                input
;             Altered by Shaun Bloomfield April 2009 with optional
;                output of calculated shifts
;             Altered by Laurel Farris to use quiet region to determine shifts
;                (to be applied to saturated active region).
;                February 2017 - current
;-


PRO align_cube3, quiet_cube, AR_cube, shifts


    ;; Number of images in data cube.
    sz = size(quiet_cube, /dimensions)

    ;; Use middle image as ref.
    ref = REFORM( quiet_cube[*,*, ((sz[2])/2)-1 ] )

    ;; 2xN array for shifts in x and y for every image, for a total of N images.
    shifts = FLTARR( 2, sz[2])

    FOR i = 0, sz[2]-1 DO BEGIN

        ;; Use quiet cube to determine offsets
        offset = ALIGNOFFSET( quiet_cube[*, *, i], ref )

        ;; Shift the i-th image in BOTH data cubes
        quiet_cube[*, *, i] = SHIFT_SUB( quiet_cube[*, *, i], -offset[0], -offset[1] )
        AR_cube[*, *, i] = SHIFT_SUB( AR_cube[*, *, i], -offset[0], -offset[1] )

        ;; Append offsets for the i-th image to the 'shifts' array
        shifts[*, i] = -offset
    ENDFOR

    RETURN


END
