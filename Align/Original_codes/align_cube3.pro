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
;   	      Altered by James McAteer March 2002 with ref optional 
;                input
;             Altered by Shaun Bloomfield April 2009 with optional 
;                output of calculated shifts
;
;-
PRO align_cube3, cube, ref
;quiet=quiet, shifts=shifts

    sz = SIZE( cube )
    
    shifts = FLTARR( 2, sz[3] )
    
    IF ( N_ELEMENTS(ref) EQ 0 ) THEN ref=REFORM( cube[*, *, 0] ) ELSE ref=ref 
    
    ;IF ~(quiet) THEN PRINT,'   image      x offset      y offset'
    
    FOR i = 0, sz[3]-1 DO BEGIN
    
    	print,i
       offset = ALIGNOFFSET( cube[*, *, i], ref )
    	;IF ~(quiet) THEN PRINT, i, offset[0], offset[1]
    	;IF ( offset[0] GT 30 ) THEN print, offset[0]
    	;IF ( offset[1] GT 30 ) THEN print, offset[1]
    	;IF abs(offset(0)) GT 30 THEN offset(0)=0.0
    	;IF abs(offset(1)) GT 30 THEN offset(1)=0.0
    	cube[*, *, i] = SHIFT_SUB( cube[*, *, i], -offset[0], -offset[1] )
    	shifts[*, i] = -offset
    	
    ENDFOR
    
END
