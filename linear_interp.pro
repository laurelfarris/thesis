;; Last modified:   02 February 2018 10:53:42

;+
; ROUTINE:      linear_interp.pro
;
; PURPOSE:      Linear interpolation at coordinates specified by caller.
;               Each index[i-1] and index[i] are averaged, with new image
;                   inserted between them
;
; USEAGE:       LINEAR_INTERP, array, header, cadence
;
; INPUT:        Array to be interpolated
;               1D array of indices at which to do the interpolation
;
; KEYWORDs:     N/A
;
; OUTPUT:       Array with N more elements in the z direction, where N is equal to the
;               number of elements in the indices array
;
; TO DO:
;
; AUTHOR:       Laurel Farris
;
;KNOWN BUGS:
;-


pro LINEAR_INTERP, header=header, array=array, jd=jd, cadence=cadence



    ; Get indices of missing data by subtracting each observation time
    ; from the previous time.

    dt = jd - shift(jd,1)
    dt = dt * 24 * 3600
    dt = round(dt)
    dt = fix(dt)

    interp_coords = ( where(dt ne cadence) )

    if n_elements(interp_coords) gt 1 then begin

        ; Create interpolated images and put them in the data cube in
        ; DESCENDING order to preserve the indices of the missing data.
        descending = (interp_coords[reverse(sort(interp_coords))])[0:-2]


        foreach i, descending do begin

            missing_image = ( array[*,*,i-1] + array[*,*,i] ) / 2.
            array = [ $
                [[array[*,*,0:i-1]]], $
                [[missing_image]],    $
                [[array[*,*,i:*]]]    $
            ]

            missing_time = ( jd[i-1] + jd[i]) / 2.
            jd = [ jd[0:i-1], missing_time, jd[i:-1] ]

        endforeach


    endif else print, "Nothing to interpolate"


end
