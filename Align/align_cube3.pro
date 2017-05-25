;+
; ROUTINE:    align_cube3
;
; PURPOSE:    align a series of images in a data cube to
;             the first image
;
; USEAGE:     align_cube3, cube
;
; INPUT:      cube = array of images (x,y,t)
;
; OUTPUT:     cube = data aligned to the first image

; Example:
;
; AUTHOR:     Peter T. Gallagher, July 2001
;             Altered by James McAteer March 2002 with ref optional
;                input
;             Altered by Shaun Bloomfield April 2009 with optional
;                output of calculated shifts
;;        Slight alterings by Laurel Farris 2015, commented with
;;               double semi-colons (;;)
;
;-
PRO align_cube3, cube ;; added 'shifts' as output for calculating the
                                   ;; average, checking to see if data cube is
                                   ;; sufficiently aligned, etc.
;quiet=quiet, shifts=shifts

    sz = SIZE( cube ) ; For accessing data cube dimensions

    ref = REFORM( cube[*,*,(sz[3]/2)] ) ;; Use middle image as ref

    shifts = FLTARR( 2, sz[3] ) ;; shift in x and y (2) for every image (sz[3]).

    ;; Align to first image if no reference image is specified
    ;IF ( N_ELEMENTS(ref) EQ 0 ) THEN ref=REFORM( cube[*, *, 0] ) ELSE ref=ref

    ;IF ~(quiet) THEN PRINT,'   image      x offset      y offset'
    ;; ????


PRINT, "Start:  ", SYSTIME() ; Display time that code started running
    FOR i = 0, sz[3]-1 DO BEGIN ;; Subtract 1 to account for i starting at 0.

 ;      PRINT,i  ;; To make sure it's making progress??
       offset = ALIGNOFFSET( cube[*, *, i], ref )
        ;IF ~(quiet) THEN PRINT, i, offset[0], offset[1]
        ;IF ( offset[0] GT 30 ) THEN print, offset[0]
        ;IF ( offset[1] GT 30 ) THEN print, offset[1]
        ;IF abs(offset(0)) GT 30 THEN offset(0)=0.0
        ;IF abs(offset(1)) GT 30 THEN offset(1)=0.0
        cube[*, *, i] = SHIFT_SUB( cube[*, *, i], -offset[0], -offset[1] )
           ;; Not sure why offset values are set to be negative...
        shifts[*, i] = -offset

    ENDFOR

PRINT, "Finish: ", SYSTIME() ; Display time that code started running
   ;x_avg = MEAN( ABS( shifts[0,*] ) )
   ;y_avg = MEAN( ABS( shifts[1,*] ) )
   x_sdv = STDDEV( shifts[0,*] )
   y_sdv = STDDEV( shifts[1,*] )

   ;PRINT, 'Shifts:  ' & PRINT, shifts
;   PRINT, 'x average: ' & PRINT, x_avg
;   PRINT, 'y average: ' & PRINT, y_avg

   PRINT, FORMAT='("x stddev: ", F0.4)' , x_sdv
   PRINT, FORMAT='("y stddev: ", F0.4)' , y_sdv



END


