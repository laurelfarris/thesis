;+
;- LAST MODIFIED:
;-   04 April 2019 -- convert array from FLOAT back to INT after loop.
;-
;-   30 April 2019 -- Added kw "shifts"
;-      (still commented, haven't written code to compute this yet)
;-
;-   23 July 2019 -- split into two routines:
;-     "missing_obs.pro" finds missing indices
;-     "linear_interp.pro" (this code) applies the interpolation using values computed in
;-        missing_obs, and returns updated data cube.
;-
;- PURPOSE:
;-
;- ROUTINE:
;-   linear_interp.pro
;-
;- EXTERNAL SUBROUTINE(S):
;-   get_time.pro
;-
;- USEAGE:
;-   LINEAR_INTERP, array, jd, time, shifts=shifts
;-
;- INPUT:
;-  array = 3D data cube
;-  jd = array of julian dates corresponding to each observation time in index.date_obs
;-         Updated using "interp_coords"
;-  time = strmid( index.date_obs,11,11 )  --> "hh:mm:ss.dd"
;-          Updated using updated JD values.
;-  interp_coords = OUTPUT from missing_obs.pro (to be run prior to this)
;-
;- KEYWORDS:
;-   shifts = shifts from alignment (I think... ?)
;-     Updated by interpolating at the indices given in "interp_coords"
;-   set to shifts obtained during alignment procedures to apply an interpolation
;-    to the same indices as the missing data.
;-   Aka: get the shifts the missing images WOULD have had, had they existed...
;-    Forgot the purpose of this... in case the values in "shifts" can be used later.
;-  NOTE: code to interpolate and update "shifts" has NOT been written yet.
;-
;- AUTHOR:       Laurel Farris
;-
;-

;+
;- Old notes:
;
; Linear interpolation at coordinates specified by caller.
; Each index[i-1] and index[i] are averaged; new image is inserted between them
;
; Output: Array with N more elements in the z direction,
;   where N = number of elements in the indices array
;
; TO-DO:  Consider using IDL's interpol routine instead of average.
;
;  Is there a way to test data type of input args at beginning, then convert back before return?
;- 23 July 2019 -- Yes: function TYPENAME(); see https://www.harrisgeospatial.com/docs/TYPENAME.html
;


pro LINEAR_INTERP, array, jd, time, interp_coords;, $
    ;shifts=shifts (see commented code below regarding "shifts" array)


    if interp_coords[0] ne -1 then begin

        N = n_elements(interp_coords)
        print, "Interpolating ", strtrim(N,1), $
            " images between z = ", strtrim(interp_coords,1), $
            "and z = ", strtrim(interp_coords+1,1)
        ;print, "Interpolating ", N, " images at z = ", interp_coords

        ; Create interpolated images and put them in the data cube in
        ; DESCENDING order to preserve the indices of the missing data.
        descending = (interp_coords[reverse(sort(interp_coords))]);[0:-2]


        foreach i, descending do begin
            missing_image = ( array[*,*,i-1] + array[*,*,i] ) / 2.
            array = [ $
                [[array[*,*,0:i-1]]], $
                [[missing_image]],    $
                [[array[*,*,i:*]]] ]
            ; Could actually use MEAN here...
            missing_jd = ( jd[i-1] + jd[i] ) / 2.
            jd = [ jd[0:i-1], missing_jd, jd[i:-1] ]

            ;if keyword_set(shifts) then begin
                ;- code here to interpolate missing values in shifts
                ;-   (amount that image would have shifted during alignment
                ;-   had it been there...)
            ;endif

        endforeach

        ; Convert from float back to integers by rounding.
        array = fix(round(array))

        ; Update time array
        time = GET_TIME( jd )

    endif else print, "Nothing to interpolate."
end
