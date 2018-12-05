
;- 02 December 2018



function PREP_HMI, index, cube, cadence=cadence, inst=inst, channel=channel
;- 05 October 2018

    ; Read headers
    if n_elements(index) eq 0 then begin
        resolve_routine, 'read_my_fits'
        READ_MY_FITS, index, $
            inst=inst, $
            channel=channel, $
            nodata=1, $
            prepped=1
    endif

    print, 'Reading header for level ', $
        strtrim(index[0].lvl_num,1), ' data.'

    ; Restore data
    ; "../hmi_mag.sav"  --> variable "cube", dimensions [750,500,400]
    ; "../hmi_cont.sav" --> variable "cube", dimensions [750,500,398]
    restore, '../hmi_' + channel + '.sav'

    ; Interpolate to get missing data and corresponding timestamp,
    ;   then crop data to pixel dimensions [500,330,*].
    ; Can't skip this (e.g. "if n_elements(cube eq 0) then...") because
    ; the same code that crops and interpolates cube also generates
    ;   variables 'time' and 'jd', which are needed for structure

    time = strmid(index.date_obs,11,11)
    jd = GET_JD( index.date_obs + 'Z' )

    resolve_routine, 'linear_interp', /either
    LINEAR_INTERP, cube, jd, cadence, time
    cube = crop_data(cube)
    ;cube = fix( round( cube ) )

    sz = size( cube, /dimensions )

    ; X/Y coordinates of AR (lower left corner),
    ;    converted from pixels to arcseconds
    ; NOTE: Hard coded coords;
    ;   can't automatically generate these values unless I somehow
    ;    save them when aligning or prepping the data.
    x1 = 2150
    y1 = 1485
    X = ( (indgen(sz[0]) + x1) - index.crpix1 ) * index.cdelt1
    Y = ( (indgen(sz[1]) + y1) - index.crpix2 ) * index.cdelt2

    ;- Total flux summed over AR
    flux = total( total( cube, 1), 1 )

    ct = 0
    if channel eq 'mag' then name = 'HMI B$_{LOS}$'
    if channel eq 'cont' then name = 'HMI intensity'

    ;; MEMORY - Is this making copies of everything?
    struc = { $
        data: cube, $
        X: X, $
        Y: Y, $
        flux: flux, $
        time: time, $
        jd: jd, $
        cadence: cadence, $
        color: '', $
        ct: ct, $
        channel: channel, $
        name: name $
    }
    return, struc
end


;hmi_mag = PREP_HMI( hmi_mag_index, hmi_mag_data, cadence=45., inst='hmi', channel='mag' )
;hmi_cont = PREP_HMI( hmi_cont_index, hmi_cont_data, cadence=45., inst='hmi', channel='cont' )

end
