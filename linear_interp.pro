;; Last modified:   16 May 2018 22:14:06

;+
;
; CREATED       04 April 2018
;
; ROUTINE:      Prep.pro
;
; PURPOSE:
;
; USEAGE:
;
; AUTHOR:       Laurel Farris
;
;-


pro LINEAR_INTERP, array, time, jd=jd, cadence=cadence

; Linear interpolation at coordinates specified by caller.
;  Get indices of missing data by subtracting each observation
;  time from the previous time.
; Each index[i-1] and index[i] are averaged, with new image
;  inserted between them

; Output: Array with N more elements in the z direction,
;   where N is equal to the
;   number of elements in the indices array

; 04 April 2018
;  At some point, array values are converted to float, so
;  added line after loop to convert back to integer data type.

; TO-DO:  Consider using IDL's interpol routine instead of average.

;  Is there a way to read in the input data type at beginning
;  of subroutine, then convert back to that at the end?

    dt = jd - shift(jd,1)
    dt = dt * 24 * 3600
    dt = round(dt)
    ; Is this necessary? Doesn't ROUND convert to INT?
    ; Yes it is --> apparently ROUND alone returns LONG, not INT,
    ; which is why FIX is used below for the data array.
    ; Seriously, comment your shit better.
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

            ; Could actually use MEAN here...
            missing_time = ( jd[i-1] + jd[i] ) / 2.
            jd = [ jd[0:i-1], missing_time, jd[i:-1] ]

        endforeach
        ; Convert from float back to integers by rounding.
        array = fix(round(array))

        ; Use the following in the future, but not worth risking errors right now.
        ;typ = typename(array)
        ;if ( typ ne 'INT') then array = round(array)


        ;---------
        ; Use new jd to update timestamp string (see 2018-05-13 notes).

        caldat, jd, month, day, year, hour, minute, second

        hour_string = strtrim(hour,1)
        minute_string = strtrim(minute,1)
        second_string = strtrim( fix(second),1)

        ; TEST that arrays are of equal length.
        NH = n_elements(hour)
        NM = n_elements(minute)
        NS = n_elements(second)
        if (NM ne NH) OR (NS ne NH) OR (NM ne NS) then $
            print, "Arrays are not of equal length!" $
            else N=NH

        ; create string array of the two digits that comprise the
        ;   nearest 100th of each value in second array.
        dec = strtrim( fix((second - fix(second))*100), 1)

        ; Append '0' to values with only one digit
        for i = 0, N-1 do begin
            if strlen(hour_string[i]) eq 1 then $
                hour_string[i] = '0' + hour_string[i]
            if strlen(minute_string[i]) eq 1 then $
                minute_string[i] = '0' + minute_string[i]
            if strlen(second_string[i]) eq 1 then $
                second_string[i] = '0' + second_string[i]
            second_string[i] = second_string[i] + '.' + dec[i]
        endfor

        time = hour_string + ':' + minute_string + ':' + second_string

    endif else print, "Nothing to interpolate."
end
