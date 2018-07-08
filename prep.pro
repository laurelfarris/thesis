
; May need to rewrite this to separate everything that can be done
; without header information (like when I have access to .sav files,
; but not the fits files, where index is always extracted.


function PREP, index, cube, cadence=cadence, inst=inst, channel=channel;, interp=interp

    ; read headers
    if n_elements(index) eq 0 then begin
        resolve_routine, 'read_my_fits'
        READ_MY_FITS, index, inst='aia', channel=channel, nodata=1
    endif


    ; Restore data, interpolate to get missing data and corresponding timestamp,
    ; then crop data to 500x330 pixels
    restore, '../aia' + channel + 'aligned.sav'
    time = strmid(index.date_obs,11,11)
    jd = GET_JD( index.date_obs + 'Z' )
    LINEAR_INTERP, cube, jd, cadence, time
    cube = crop_data(cube)

    cube = fix( round( cube ) )
    sz = size( cube, /dimensions )

    ;flux = fltarr( sz[2] )
    flux = total( total( cube, 1), 1 )
    exptime = index[0].exptime

    name = 'AIA ' + channel + '$\AA$'

    aia_lct, r, g, b, wave=fix(channel);, /load
    ct = [ [r], [g], [b] ]

    struc = { $
        data: cube, $
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
        'data', cube, $
        'jd', jd, $
        'time', time, $
        'cadence', cadence )
end


; need to re-read data, but not headers... commented in subroutine for now.

aia1600 = PREP( aia1600index, aia1600data, cadence=24., inst='aia', channel='1600' )
aia1700 = PREP( aia1700index, aia1700data, cadence=24., inst='aia', channel='1700' )

; colors (for plotting)
aia1600.color = 'dark orange'
aia1700.color = 'dark cyan'

A = [ aia1600, aia1700 ]

;aia = dictionary( 'aia1600', aia1600, 'aia1700', aia1700 )


end
