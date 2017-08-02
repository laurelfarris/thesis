;; Last modified:   18 July 2017 11:05:09

;+
; ROUTINE:      linear_interp.pro
;
; PURPOSE:      Linear interpolation at coordinates specified by caller
;
; USEAGE:       LINEAR_INTERP, array, indices
;
; INPUT:        Array to be interpolated
;               1D array of indices at which to do the interpolation
;
; KEYWORDs:     N/A
;
; OUTPUT:       Array with N more elements in the z direction, where N is equal to the
;               number of elements in the indices array
;
; TO DO:        Can't find subroutine that produced coordinates of missing hmi data,
;                   but numbers are saved in linear_interp.pro
;
; AUTHOR:       Laurel Farris
;
;KNOWN BUGS:
;-


function LINEAR_INTERP, old_array, indices

    descending = indices[ reverse(sort(indices)) ]

    array = old_array
    foreach i, descending do begin
        new_element = ( array[*,*,i] + array[*,*,i+1] ) / 2.
        array = [ [[array[*,*,0:i]]], [[new_element]], [[array[*,*,i+1:*]]] ]
    endforeach

    return, array

end
