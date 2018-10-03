
; May need to rewrite this to separate everything that can be done
; without header information (like when I have access to .sav files,
; but not the fits files, where index is always extracted.

;- To do: make a separate routine for reading in maps and power vs. time.
;         Also need a different name for power vs. time.
;         --> Google this, may be an actual analysis method with a real name.



; nodata does the same thing as in read_sdo


function POWER_IN_STRUC, struc


    ;power_flux = GET_POWER( $
    ;    struc.flux, cadence=struc.cadence, channel=struc.channel, data=struc.data)
    ;struc = create_struct( struc, 'power_flux', power_flux )

;    power_maps = GET_POWER_FROM_MAPS( $
;        struc.data, struc.channel, threshold=10000, dz=64)
;    struc = create_struct( struc, 'power_maps', power_maps )

    return, struc
end


function PREP, index, cube, cadence=cadence, inst=inst, channel=channel

    ; Read headers
    if n_elements(index) eq 0 then begin
        resolve_routine, 'read_my_fits'
        READ_MY_FITS, index, $
            instr='aia', $
            channel=channel, $
            nodata=1, $
            prepped=1
            ; set prep to 1 (23 Sep 2018).
            ; Why wasn't this already set???
            ;  kw wasn't present at all!

    endif
    print, 'Reading header for level ', $
        strtrim(index[0].lvl_num,1), ' data.'

    ; Restore data (in variable "cube", with pixel dimensions [750,500,749]),
    ;   interpolate to get missing data and corresponding timestamp,
    ;   then crop data to pixel dimensions [500,330,*].
    ; reasons if statement doesn't work here:
    ;   Also get time and jd, which are needed for structure
    ;if n_elements(cube) eq 0 then begin
        restore, '../aia' + channel + 'aligned.sav'
        time = strmid(index.date_obs,11,11)
        jd = GET_JD( index.date_obs + 'Z' )
        LINEAR_INTERP, cube, jd, cadence, time
        cube = crop_data(cube)
        cube = fix( round( cube ) )
    ;endif

    ;- Correct for exposure time (standard data reduction)
    exptime = index[0].exptime
    print, 'Exposure time = ', strtrim(exptime,1), ' seconds.'
    cube = cube/exptime

    sz = size( cube, /dimensions )

    ; X/Y coordinates of AR, converted from pixels to arcseconds
    x1 = 2150
    y1 = 1485
    X = ( (indgen(sz[0]) + x1) - index.crpix1 ) * index.cdelt1
    Y = ( (indgen(sz[1]) + y1) - index.crpix2 ) * index.cdelt2
    ; NOTE: Hard coded coords of lower left corner;
    ;   can't automatically generate these values unless I somehow
    ;    save them when aligning or prepping the data.

    ;flux = fltarr( sz[2] )
    flux = total( total( cube, 1), 1 )

    aia_lct, r, g, b, wave=fix(channel);, /load
    ct = [ [r], [g], [b] ]
    name = 'AIA ' + channel + '$\AA$'

    resolve_routine, 'get_power_from_flux', /either
    power_flux = GET_POWER_FROM_FLUX( $
        flux=flux, $
        cadence=cadence, $
        dz=64, $
        fmin=0.005, $
        fmax=0.006, $
        norm=0, $
        data=cube )

    restore, '../aia' + channel + 'map.sav'

    ;; MEMORY - Is this making copies of everything?
    struc = { $
        data: cube, $
        X: X, $
        Y: Y, $
        jd: jd, $
        time: time, $
        flux: flux, $
        exptime: exptime, $
        color: '', $
        ct: ct, $
        cadence: cadence, $
        channel: channel, $
        power_flux: power_flux, $
        power_maps: fltarr(685), $
        ;map: fltarr(sz[0],sz[1],685), $
        ;map: map, $
        name: name $
    }
    return, struc

    dic = dictionary( $
        'data', cube, $
        'jd', jd, $
        'time', time, $
        'cadence', cadence )
;aia = dictionary( 'aia1600', aia1600, 'aia1700', aia1700 )
end

goto, start
start:

; A = replicate( struc, 2 )
; ... potentially useful?

; need to re-read data, but not headers... commented in subroutine for now.

aia1600 = PREP( aia1600index, aia1600data, cadence=24., inst='aia', channel='1600' )
aia1700 = PREP( aia1700index, aia1700data, cadence=24., inst='aia', channel='1700' )

help, aia1600
help, aia1600data

A = [ aia1600, aia1700 ]

A[0].color = 'dark orange'
A[1].color = 'dark cyan'

stop

; To do: save variables with same name so can call this from subroutine.
restore, '../power_from_maps.sav'
;power_from_maps = aia1600power_from_maps
;save, power_from_maps, filename='aia1600power_from_maps.sav'
;power_from_maps = aia1700power_from_maps
;save, power_from_maps, filename='aia1700power_from_maps.sav'

A[0].power_maps = aia1600power_from_maps
A[1].power_maps = aia1700power_from_maps

;- 23 September 2018
A[0].data = A[0].data > 0
;  thought aia_prep produced data with no negative numbers, but not
;   sure why I thought so...

end
