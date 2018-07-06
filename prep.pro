
; May need to rewrite this to separate everything that can be done
; without header information (like when I have access to .sav files,
; but not the fits files, where index is always extracted.


function PREP, index, data, inst=inst, channel=channel, cadence=cadence

    ; specific to AIA...
    name = 'AIA ' + channel + '$\AA$'

    ; Read headers
    resolve_routine, 'read_my_fits'
    if n_elements(index) eq 0 then begin
        print, 'reading index for ', name
        READ_MY_FITS, index, inst=inst, channel=channel, nodata=1
        endif

    ; Restore aligned data.
    if n_elements(data) eq 0 then begin
        print, 'restoring data for ', name
        restore, '../' + inst + channel + 'aligned.sav'
        endif else cube = data

    ; Interpolate to get missing data and corresponding timestamp.
    time = strmid(index.date_obs,11,11)
    jd = get_jd( index.date_obs + 'Z' )
    LINEAR_INTERP, cube, jd, cadence, time
    cube = crop_data(cube)
    sz = size( cube, /dimensions )

    aia_lct, r, g, b, wave=fix(channel), /load
    ct = [ [r], [g], [b] ]

    dic = dictionary( $
        'data', cube, $
        'flux', fltarr( sz[2] ), $
        'cadence', cadence, $
        'ct', ct, $
        'name', name $
    )

    if channel eq '1600' then dic.color='dark orange'
    if channel eq '1700' then dic.color='dark cyan'

    return, dic

end


aia1600 = PREP( aia1600index, aia1600data, inst='aia', channel='1600', cadence=24 )
aia1700 = PREP( aia1700index, aia1700data, inst='aia', channel='1700', cadence=24 )

; combine dictionaries into one big dictionary?

end
