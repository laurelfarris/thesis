

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


function crop_data, cube
    ;; Last modified:   22 February 2018 10:35:36

    ;; Center coords relative to full disk
    ;x_center = 2400
    ;y_center = 1650

    sz = size( cube, /dimensions )

    ; Use these for MISaligned data (aia_####_misaligned.sav)
    ;x_center = 365
    ;y_center = 410

    ; Use these for aligned data (aia_####_aligned.sav)
    x_center = sz[0]/2 + 15
    y_center = sz[1]/2 + 15

    x_length = 500
    y_length = 330

    x1 = x_center - x_length/2
    y1 = y_center - y_length/2
    x2 = x1 + x_length -1
    y2 = y1 + y_length -1

    cube = cube[ x1:x2, y1:y2, * ]

    return, cube

end



pro LINEAR_INTERP, array, jd=jd, cadence=cadence

; TO-DO:        Consider using IDL's interpol routine
;                (this is currently just using the average)

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

;  04 April 2018
; Added line after loop to convert back to integer data type, to match
; what the data was to begin with.
;  Is there a way to read in the input data type at beginning
;  of subroutine, then convert back to that at the end?

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


function get_jd, index
    ;; Last modified:   22 February 2018 10:35:36

    ; Use observation time from header to get individual time values
    timestamptovalues, index.t_obs, $
        day=day, $
        hour=hour, $
        minute=minute, $
        month=month, $
        offset=offset, $
        second=second, $
        year=year
    ; Covert observations times to JD
    jd = julday(month, day, year, hour, minute, second)
    return, jd
end


function PREP, channel, index=index

    ; As I learned the hard way, even if a kw is set to a variable name,
    ; it's not actually set if the variable is undefined. So this works :)
    ; Actually, may need to double check the differences in how functions
    ; and procedures behave for this and arg_present.
    if not keyword_set(index) then $
        read_my_fits, channel, index=index;, data=data

    jd = get_jd( index )
    restore, '../aia_' + channel + '_aligned.sav'
    linear_interp, cube, jd=jd, cadence=24
    cube = crop_data(cube)

    flux = total( total(cube,1), 1 )
    flux_norm = flux - min(flux)
    flux_norm = flux_norm / max(flux_norm)

    restore, '../aia' + channel + 'map.sav'

    ; Could set power_spec and power_map to same 2D indices as data,
    ; but no way to determine what the third dimension should be,
    ; unless I know exactly what I'm going to be plotting, and want
    ; a convenient way to

    sz = size(cube, /dimensions)

    aia_lct, r, g, b, wave=fix(channel), /load
    ct = [ [r], [g], [b] ]

    struc = { $
        name : 'AIA ' + channel + '$\AA$', $
        data: cube, $
        cadence : 24.0, $
        jd : jd, $
        time : strarr(sz[2]), $
        flux : flux, $
        flux_norm : flux_norm, $
        map : map, $
        ct : ct, $
        color : '' $
    }

    struc.time = strmid(index.t_obs,11,11)

    return, struc

end

goto, start
start:;-----------------------------------------------------------------------------

;resolve_routine, 'graphics'
;/compile_full_file --> this doesn't mean put the file's name... just means
; that IDL will compile every subroutine in the file where it finds the one
; entered here as an argument (usually it stops once that one is found).
define_block
common defaults

read_my_fits, '1600', index=aia1600index;, data=data
aia1600 = PREP( '1600', index=aia1600index )
aia1600.color = 'dark orange'

read_my_fits, '1700', index=aia1700index;, data=data
aia1700 = PREP( '1700', index=aia1700index )
aia1700.color = 'dark cyan'

;S = {  aia1600 : aia1600, aia1700 : aia1700  }
A = [ aia1600, aia1700 ]

; Structure of structures, or array of structures? What to do?
; With an array, can do things like A.t_obs to get just the observation time
; for every substructure (can't do this with struc).
; However, all substructures in array would have to have the same tags,
; with the same data type and same size, which would make it impossible
; to combine AIA and HMI.

end
