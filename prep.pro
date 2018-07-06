
; May need to rewrite this to separate everything that can be done
; without header information (like when I have access to .sav files,
; but not the fits files, where index is always extracted.

pro PRE_PREP, index, cube, channel

    ; read headers
    if n_elements(index) eq 0 then begin
        resolve_routine, 'read_my_fits'
        READ_MY_FITS, index, inst='aia', channel=channel, nodata=1
    endif

    ; restore data
    restore, '../aia' + channel + 'aligned.sav'
end

function PREP, index, data, cadence=cadence, channel=channel, interp=interp

    ; Interpolate to get missing data and corresponding timestamp,
    ;  then crop data to 500x330 pixels

    if keyword_set(interp) then begin
        time = strmid(index.date_obs,11,11)
        jd = GET_JD( index.date_obs + 'Z' )
        LINEAR_INTERP, data, jd, cadence, time
        data = crop_data(data)
    endif

    data = fix( round( data ) )
    sz = size( data, /dimensions )

    ;flux = fltarr( sz[2] )
    flux = total( total( data, 1), 1 )
    exptime = index[0].exptime

    name = 'AIA ' + channel + '$\AA$'

    aia_lct, r, g, b, wave=fix(channel);, /load
    ct = [ [r], [g], [b] ]

    struc = { $
        data: data, $
        jd: jd, $
        time: time, $
        flux: flux, $
        exptime: exptime, $
        color: '', $
        ct: ct, $
        cadence: cadence, $
        name: name $
    }
    return, struc

    dic = dictionary( $
        'data', data, $
        'jd', jd, $
        'time', time, $
        'cadence', cadence )
end


; need to re-read data, but not headers... commented in subroutine for now.

PRE_PREP, aia1600index, aia1600data, '1600'
aia1600 = PREP( aia1600index, aia1600data, cadence=24., channel='1600', /interp )

PRE_PREP, aia1700index, aia1700data, '1700'
aia1700 = PREP( aia1700index, aia1700data, cadence=24., channel='1700', /interp )

; colors (for plotting)
aia1600.color = 'dark orange'
aia1700.color = 'dark cyan'

A = [ aia1600, aia1700 ]

;aia = dictionary( 'aia1600', aia1600, 'aia1700', aia1700 )


end
