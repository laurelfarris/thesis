
;; Last modified:   31 May 2018

function PREP, inst, channel, cadence, _EXTRA=e
    ; Read header from prepped fits

    ; Be sure to change this if switching data type!
    ; Don't want to use Dopplergram index for continuum data...
    ; Maybe make more like AIA, where caller specifies inst/channel.
    ; Parts of these should be combined anyway.

    ;if n_elements(index) eq 0 then begin
        READ_MY_FITS, index, data, inst=inst, channel=channel, nodata=1, $
            prepped=0 ; 28 June 2018 - changed prepped to = 1 by default
    ;    endif

    ; Restore aligned data.
    ; Returns variable "cube", with dimensions 500x330x398 (for hmi I assume...)
    ;restore, '../' + inst + '_' + channel + '.sav'
    restore, '../Data/' + inst + '_' + channel + '.sav'

    ;; Interpolate to get missing data and corresponding timestamp.
    time = strmid(index.date_obs,11,11)
    jd = get_jd( index.date_obs + 'Z' )
    LINEAR_INTERP, cube, jd, cadence, time

    cube = crop_data(cube)

    sz = size( cube, /dimensions )
    flux = fltarr( sz[2] )

    struc = { $
        jd : jd, $
        time : time, $
        cadence : cadence, $
        data : cube, $
        flux : flux $
        }
    if n_elements(e) ne 0 then struc = create_struct(struc, e)
    return, struc
end

function aia_prep, channel

    ; Have PREP call this one, instead of the other way around.
    ; This should be able to be called by itself.

    inst = 'aia'

    ; AIA colors
    aia_lct, r, g, b, wave=fix(channel), /load
    ct = [ [r], [g], [b] ]

    if channel eq '1600' then color='dark orange'
    if channel eq '1700' then color='dark cyan'

    ;struc = PREP('aia', channel, 24., name='AIA'+channel+'$\AA$', color=color, ct=ct)

    restore, '../Data/' + inst + '_' + channel + '.sav'
    ;restore, '../Data/' + inst + '_' + channel + '_' + 'map2.sav'
    cube = crop_data(cube)
    sz = size( cube, /dimensions )

    struc = { $
        data : cube, $
        flux : fltarr(sz[2]), $
        cadence : 24., $
        name : 'AIA' + channel + '$\AA$', $
        color : color, $
        ct : ct }

    ;restore, '../aia1600aligned_2.sav'
    ;cube = crop_data( aligned_cube ) ; assuming AR is in center already
    ;aia1600=create_struct(aia1600,'before',aligned_cube[100:599,66:395,  0:260])
    ;aia1600=create_struct(aia1600,'during',aligned_cube[100:599,66:395,261:349])
    ;aia1600=create_struct(aia1600,'after', aligned_cube[100:599,66:395,350:748])
    return, struc
end


; May need to rewrite this to separate everything that can be done
; without header information (like when I have access to .sav files,
; but not the fits files, where index is always extracted.

;resolve_routine, 'read_my_fits'


;aia1600 = aia_prep('1600')
;aia1700 = aia_prep('1700')
stop

;hmi = prep('hmi', 'cont', hmiContindex, 45., name='HMI cont')
;hmi = prep('hmi', 'mag', index, name='HMI B$_{LOS}$', cadence=45.)
;hmi = prep('hmi', 'dop', index, name='HMI Dopplergram', cadence=45.)

;A = [ aia1600, aia1700 ]
;S = { aia1600:aia1600, aia1700:aia1700, hmi:hmi }

end
