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




function PREP, channel, index=index


    ; 29 March 2018
    ; This should be its own subroutine.
    ; ONE line for each set of data.
    ; No mess of variable names... just return the structure.

    ; Absolute coords of AR center, relative to full disk
    ;   For which image? Before or after alignment?
    ;x_center = 2400
    ;y_center = 1650
    ;sz = size( cube, /dimensions ) ;; For any size cube
    ;image_location = [ x_center - sz[0]/2, y_center - sz[1]/2 ]

    ; Read headers (and data, if desired) from fits files.

    ;read_my_fits, '1600', index=a6index;, data=a6data
    ;read_my_fits, '1700', index=a7index;, data=a7data

    ; Get array of julian dates
    ;a6jd = getJD( a6index )
    ;a7jd = getJD( a7index )

    ;time = strmid(a6index.t_obs,11,5)

    ; Restore data... keeping same var name may help if I eventually
    ;   put this in a loop.
    ;restore, 'aia_1600_aligned.sav'
    ;a6data = cube
    ;restore, 'aia_1700_aligned.sav'
    ;a7data = cube

    ;; Interpolate to get missing images for AIA 1700
    ;linear_interp, a7data, jd=a7jd, cadence=24
    ;a7data=fix(a7data)

    ;; Crop data to region centered around AR.
    ;;  This needs to be done AFTER alignment.
    ;a6data = CROP_DATA( a6data[*,*,1:*] )
    ;a7data = CROP_DATA( a7data )

    ;; Structures with all important data for both channels
    ;;   (these values should never change!)
    ;aia1600 = { $
    ;    data: a6data, $
    ;    jd : a6jd, $
    ;    time : strmid(a6index.t_obs,11,5), $
    ;    flux : total( total(a6data,1), 1 ), $
    ;    name : "AIA 1600$\AA$", $
    ;    color : 'dark orange' }
    ;aia1700 = { $
    ;    data: a7data, $
    ;    jd : a7jd, $
    ;    time : strmid(a7index.t_obs,11,5), $
    ;    flux : total( total(a7data,1), 1 ), $
    ;    name : "AIA 1700$\AA$", $
    ;    color : 'dark cyan' }



    ; New stuff (2018-04-04)

    ; Reading fits files takes a while... probably shouldn't repeat
    ; this step every time one of the others messes up.
    ; Maybe hold off combining variables into a structure until
    ; confirmed that everything looks right. 

    if not keyword_set(index) then $
        read_my_fits, channel, index=index;, data=data



    jd = get_jd( index )
    restore, '../aia_' + channel + '_aligned.sav'
    linear_interp, cube, jd=jd, cadence=24
    cube = crop_data(cube)

    flux = total( total(cube,1), 1 )
    flux_norm = flux - min(flux)
    flux_norm = flux_norm / max(flux_norm)

    restore, 'aia' + channel + 'map.sav'

    ; Could set power_spec and power_map to same 2D indices as data,
    ; but no way to determine what the third dimension should be,
    ; unless I know exactly what I'm going to be plotting, and want
    ; a convenient way to 

    sz = size(cube, /dimensions)

    struc = { $
        name : 'AIA ' + channel + '$\AA$', $
        data: cube, $
        cadence : 24.0, $
        jd : jd, $
        time : strarr(sz[2]), $
        flux : flux, $
        flux_norm : flux_norm, $
        map : map, $
        color : '' $
    }

    struc.time = strmid(index.t_obs,11,5)

    return, struc

end


; Should separate part that calls read_my_fits. Even reading
; just the headers takes too long.

; Be sure to change cadence for HMI! (or other data)
aia1600 = PREP( '1600' )
aia1600.color = 'dark orange'

aia1700 = PREP( '1700' )
aia1700.color = 'dark cyan'





;; Structure of structures, or array of structures? What to do?
;S = {  aia1600 : aia1600, aia1700 : aia1700  }
;A = [ aia1600, aia1700 ]

end
