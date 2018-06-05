
;; Last modified:   31 May 2018

function PREP, inst, channel, index, cadence, _EXTRA=e
    ; Read header from prepped fits

    ; Be sure to change this if switching data type!
    ; Don't want to use Dopplergram index for continuum data...
    ; Maybe make more like AIA, where caller specifies inst/channel.
    ; Parts of these should be combined anyway.
    ;if n_elements(index) eq 0 then begin
        ;print, "no index in input args."
        read_my_fits, inst, channel, index, data, nodata=1
    ;    endif

    ; Restore aligned data. Returns variable "cube", with dimensions 500x330x398
    restore, '../' + inst + '_' + channel + '.sav'

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

goto, start

resolve_routine, 'read_my_fits'

hmi = prep('hmi', 'cont', hmiContindex, 45., name='HMI cont')
;hmi = prep('hmi', 'mag', index, name='HMI B$_{LOS}$', cadence=45.)
;hmi = prep('hmi', 'dop', index, name='HMI Dopplergram', cadence=45.)


; AIA colors
aia_lct, r, g, b, wave=1600, /load
ct1600 = [ [r], [g], [b] ]
aia_lct, r, g, b, wave=1700, /load
ct1700 = [ [r], [g], [b] ]

aia1600 = PREP('aia', '1600', aia1600index, 24., name='AIA 1600$\AA$', $
    color='dark orange', ct=ct1600)
help, aia1600index
;aia1700 = PREP('aia', '1700', aia1700index, 24., name='AIA 1700$\AA$', $
;    color='dark cyan', ct=ct1700)
stop
;A = [ aia1600, aia1700 ]

restore, '../aia1600aligned_2.sav'
cube = crop_data( aligned_cube ) ; assuming AR is in center already
aia1600=create_struct(aia1600,'before',aligned_cube[100:599,66:395,0:260])
aia1600=create_struct(aia1600,'during',aligned_cube[100:599,66:395,261:349])
aia1600=create_struct(aia1600,'after',aligned_cube[100:599,66:395,350:748])

start:
S = { aia1600:aia1600, aia1700:aia1700, hmi:hmi }

end
