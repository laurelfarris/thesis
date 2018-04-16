; Last modified:   04 April 2018

; Added line after loop to convert back to integer data type, to match
; what the data was to begin with.
;  Is there a way to read in the input data type at beginning
;  of subroutine, then convert back to that at the end?

;+
; ROUTINE:
;
; PURPOSE:
;
; USEAGE:
;
; AUTHOR:       Laurel Farris
;
; TO-DO:        Consider using IDL's interpol routine
;                (this is currently just using the average)
;
;
;-

pro LINEAR_INTERP, array, jd=jd, cadence=cadence

; Linear interpolation at coordinates specified by caller.
;  Get indices of missing data by subtracting each observation
;  time from the previous time.
; Each index[i-1] and index[i] are averaged, with new image
;  inserted between them

; Output: Array with N more elements in the z direction, 
;   where N is equal to the
;   number of elements in the indices array

; NOTE --> This converts values to float. Input from AIA data is
;   usually in integer form. Either change type back before returning,
;   or convert all other data values to float.

    dt = jd - shift(jd,1)
    dt = dt * 24 * 3600
    dt = round(dt)
    dt = fix(dt)

    ;; There is a gap between i-1 and i.
    interp_coords = ( where(dt ne cadence) )

    if n_elements(interp_coords) gt 1 then begin

        print, "Interpolating..."

        ; Create interpolated images and put them in the data cube in
        ; DESCENDING order to preserve the indices of the missing data.
        descending = (interp_coords[reverse(sort(interp_coords))])[0:-2]

        foreach i, descending do begin

            missing_image = ( array[*,*,i-1] + array[*,*,i] ) / 2.
            array = [ $
                [[array[*,*,0:i-1]]], $
                [[missing_image]],    $
                [[array[*,*,i:*]]] ]

            missing_time = ( jd[i-1] + jd[i]) / 2.
            jd = [ jd[0:i-1], missing_time, jd[i:-1] ]

        endforeach
        array = fix(array)

    endif else print, "Nothing to interpolate."
end
