;; Last modified:   29 January 2018 19:38:35

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


pro LINEAR_INTERP, array, index, cadence, interp_coords


    ; Use observation date from each header (index[i].dat_obs)
    ;    to return arry of observation times for all images in seconds ('sunits')
    t_seconds = []
    for i = 0, n_elements(index.date_obs)-1 do $
        t_seconds = [ t_seconds, GET_TIMESTAMP(index[i].date_obs, /sunits) ]

    ; Get indices of missing data by subtracting each observation time from the
    ;    previous time.
    dt = t_seconds - shift(t_seconds,1)
    interp_coords = ( where(dt ne cadence) )


    ; Check if there are any places in time series where the time difference was
    ;    NOT equal to the cadence (indicating at least one missing image).
    ; There will be at least one element in this array due to the wrapping that
    ;    occurs with the SHIFT function.
    ; Can't simply use interp_coords[1:*] because an error would occur for data
    ;    sets that don't have any missing data (i.e. would only have one element,
    ;    with index 0).
    if n_elements(interp_coords) gt 1 then begin

        ; Create interpolated images and put them in the data cube in
        ; DESCENDING order so that the indices of the missing data are preserved.
        descending = ( interp_coords[ reverse(sort(interp_coords)) ] )[0:-2]
        foreach i, descending do begin
            ;; Better make sure there aren't any negative values!
            missing_image = ( array[*,*,i-1] + array[*,*,i] ) / 2.
            array = [ [[array[*,*,0:i-1]]], [[missing_image]], [[array[*,*,i:*]]] ]
            ;missing_time = (t_seconds[i-1] + t_seconds[i]) / 2.
            ;t_seconds = [ t_seconds[0:i-1], missing_time, t_seconds[i:*] ]
        endforeach


    endif else print, "Nothing to interpolate"


end
