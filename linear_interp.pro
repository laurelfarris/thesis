;; Last modified:   29 September 2017 11:58:18

;+
; ROUTINE:      linear_interp.pro
;
; PURPOSE:      Linear interpolation at coordinates specified by caller.
;               Each index[i-1] and index[i] are averaged, with new image inserted between them
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
; TO DO:
;
; AUTHOR:       Laurel Farris
;
;KNOWN BUGS:
;-


function LINEAR_INTERP, old_array, index, cadence

    ; Give index.dat_obs to return obs time in seconds ('sunits')
    t = []
    for i = 0, n_elements(index)-1 do $
        t = [ t, GET_TIMESTAMP(index[i].date_obs, /sunits) ]

    ; Get indices of missing data
    dt = t - shift(t,1)
    interp_coords = ( where(dt ne cadence) )


    if n_elements(interp_coords) gt 1 then begin

        descending = ( interp_coords[ reverse(sort(interp_coords)) ] )[0:-2]

        array = old_array
        foreach i, descending do begin
            new_element = ( array[*,*,i-1] + array[*,*,i] ) / 2.
            array = [ [[array[*,*,0:i-1]]], [[new_element]], [[array[*,*,i:*]]] ]
        endforeach

        return, array

    endif else begin
        print, "Nothing to interpolate"
        return, old_array
    endelse


end

@main


hmi = LINEAR_INTERP( hmi_data, hmi_index, hmi_cad )
a6 = LINEAR_INTERP( aia_1600_data, aia_1600_index, aia_cad )
a7 = LINEAR_INTERP( aia_1700_data, aia_1700_index, aia_cad )




end
