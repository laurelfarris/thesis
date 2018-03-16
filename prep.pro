;; Last modified:   22 February 2018 10:35:36

;+
; ROUTINE:      Prep.pro
;
; PURPOSE:
;
; USEAGE:
;
; AUTHOR:       Laurel Farris
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
    endif else print, "Nothing to interpolate"
end


function getJD, index
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

pro read_my_fits, channel, index=index, data=data
    ; Read headers
    path = '/solarstorm/laurel07/Data/AIA/'
    files = '*aia*' + channel + '*2011-02-*.fits'
    fls = (file_search(path + files))
    if arg_present(data) then nodata=0 else nodata=1
    READ_SDO, fls, index, data, nodata=nodata
    
end

function crop_data, cube

    ;; Crop data array in x & y
    ;arcsec = 200. ; length of side in arcseconds
    ;resolution = index[0].cdelt1  ; arcseconds per pixel
    ;; Center coordinates
    ;x = 365
    ;y = 410
    ;r = (arcsec/resolution)/2
    ;return, cube[ x-r:x+r-1, y-r:y+r-1, * ]

    ;; Center coords relative to full disk
    ;x_center = 2400
    ;y_center = 1650

    sz = size( cube, /dimensions )

    ; Use these for MISaligned data (aia_####_misaligned.sav)
    ;x_center = 365
    ;y_center = 410

    ; Use these for aligned data (aia_####_aligned.sav)
    x_center = sz[0]/2
    y_center = sz[1]/2

    x_length = 500
    y_length = 330

    x1 = x_center - x_length/2
    y1 = y_center - y_length/2
    x2 = x1 + x_length -1
    y2 = y1 + y_length -1

    cube = cube[ x1:x2, y1:y2, * ]

    return, cube

end

GOTO, start

;; Absolute coords of AR center, relative to full disk
;x_center = 2400
;y_center = 1650
;sz = size( cube, /dimensions ) ;; For any size cube
;image_location = [ x_center - sz[0]/2, y_center - sz[1]/2 ]

;; Read headers (and data, if desired) from fits files.
read_my_fits, '1600', index=a6index;, data=a6data
read_my_fits, '1700', index=a7index;, data=a7data

start:;----------------------------------------------------------------------------------

;; Get array of julian dates
a6jd = getJD( a6index )
a7jd = getJD( a7index )

time = strmid(a6index.t_obs,11,5)

;; Restore data... keeping same var name may help if I eventually
;;   put this in a loop.
restore, 'aia_1600_aligned.sav'
a6data = cube
restore, 'aia_1700_aligned.sav'
a7data = cube

;; Interpolate to get missing images for AIA 1700
linear_interp, a7data, jd=a7jd, cadence=24
a7data=fix(a7data)

;; Crop data to region centered around AR.
;;  This needs to be done AFTER alignment.
a6data = CROP_DATA( a6data[*,*,1:*] )
a7data = CROP_DATA( a7data )


;; Structures with all important data for both channels
;;   (these values should never change!)
aia1600 = { $
    data: a6data, $
    jd : a6jd, $
    time : strmid(a6index.t_obs,11,5), $
    flux : total( total(a6data,1), 1 ), $
    name : "AIA 1600$\AA$", $
    color : 'dark orange' }
aia1700 = { $
    data: a7data, $
    jd : a7jd, $
    time : strmid(a7index.t_obs,11,5), $
    flux : total( total(a7data,1), 1 ), $
    name : "AIA 1700$\AA$", $
    color : 'dark cyan' }
S = {  aia1600 : aia1600, aia1700 : aia1700  }

end
