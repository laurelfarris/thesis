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


function PREP_AIA, channel, index=index

    ; Avoid reading header info every time prep is called,
    if not keyword_set(index) then $
        read_my_fits, channel, index, data, nodata=1, /aia


    ; Observation time.
    time = strmid(index.date_obs,11,11)
    jd = get_jd( index.date_obs + 'Z' )
    ;jd = get_jd( index.t_obs )

    ; Restore aligned data from .sav files, and
    ;   interpolate to get missing data.
    ; Why not crop cube first?
    restore, '../aia_' + channel + '_aligned.sav'
    linear_interp, cube, time, jd=jd, cadence=24
    cube = crop_data(cube)

    ; Total flux from AR
    flux = total( total(cube,1), 1 )
    flux_norm = flux - min(flux)
    flux_norm = flux_norm / max(flux_norm)

    ; Restore power maps.
    restore, '../aia' + channel + 'map.sav'
    restore, '../aia' + channel + 'map2.sav'

    ; Power at each timestep, from integrated flux
    ; (total_power.pro does this calculation)
    power = fltarr( n_elements( flux ) )

    ; Power at each timestep, from total(maps).
    ; Still needs to be corrected for saturated pixels.
    power2 = total( total( map2, 1 ), 1 );, fltarr(dz)  

    ; AIA colors!
    aia_lct, r, g, b, wave=fix(channel), /load
    ct = [ [r], [g], [b] ]

    sz = size( cube, /dimensions )

    ; Center coords of AR (pixels), relative to lower left corner of disk.
    ; PUt in common block? These would never change unless I decided
    ; the AR wasn't quite centered, or maybe if alignment used a different
    ; reference image...
    x_center=2400
    y_center=1650
    pixels_to_arcseconds, [x_center,y_center], [sz[0], sz[1]], index, X, Y

    struc = { $
        name : 'AIA ' + channel + '$\AA$', $
        data: cube, $
        x : x, $
        y : y, $
        cadence : 24.0, $
        jd : jd, $
        time : time, $
        flux : flux, $
        flux_norm : flux_norm, $
        map : map, $
        map2 : map2, $
        power : power, $
        power2 : power2, $
        ct : ct, $
        color : '' $
    }


    return, struc

end
