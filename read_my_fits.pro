;; Last modified:   10 April 2018

; Read headers
; Channel in STRING form (e.g. '1600')
; Similar to vsoget: uncomment lines you want




pro READ_MY_FITS, path, files, index, data, sub=sub, _EXTRA=e
    fls = (file_search(path + files))
    ;if n_elements(sub) ne 0 then fls = fls[sub]
    READ_SDO, fls, index, data, _EXTRA=e
end



pro READ_HMI, index, data, _EXTRA=e
    ; HMI - Original fits files (no .sav files yet)

    path = '/solarstorm/laurel07/Data/HMI/'
    files = [ $
        '*ic_45s*continuum*.fits', $
        '*m_720s*magnetogram*.fits', $
        '*m_45s*magnetogram*.fits', $
        '*v_45s*Dopplergram*.fits' ]

    ; Read index and/or data
    ; should probably read index at main level, so don't have to
    ; re-read it every time subroutine screws up

    fls = file_search(path + files[2])
    READ_SDO, fls[0], index, data, _EXTRA=e
end


function PREP_HMI, index, data, _EXTRA=e

    ; Return if, e.g. nodata=1, since can't input anything to aia_prep
    ;if n_elements(data) eq 0 then return

    ;-------------------------

    ; Use aia_prep.pro to rotate data, plus coalign with AIA
    ; This takes a long time for full data set.
    aia_prep, index, data, new_index, new_data

    ;outdir = '/solarstorm/laurel07/Data/HMI_prepped/'
    ;aia_prep, index, data, /do_write_fits, outdir=outdir

    index = new_index
    time = strmid(index.date_obs,11,11)

    struc = { $
        name : 'HMI B$_{LOS}$', $
        data : new_data, $
        cadence : 45.0, $
        time : time $
        }
    if n_elements(e) ne 0 then struc = create_struct(struc, e)
    return, struc
end


pro READ_AIA, index, data, channel, _EXTRA=e
;; Add CASE here? Maybe set desired level number...

    ; AIA - Original fits files (level 1.0)
    ;path = '/solarstorm/laurel07/Data/AIA/'
    ;files = '*aia*' + channel + '*2011-02-15*.fits'

    ; AIA - New fits files (level 1.5)
    path = '/solarstorm/laurel07/Data/AIA_prepped/'
    files = 'AIA20110215_*_' + channel + '*.fits'

    ; Read index and/or data
    fls = (file_search(path + files))
    READ_SDO, fls[0], index, data, _EXTRA=e
    return
end


function PREP_AIA, index, data, channel, _EXTRA=e
    
    ; Run aia_prep.pro
    ;read_my_fits, channel, index, data, nodata=0, /aia
    ;aia_prep, index, data, /do_write_fits, outdir=path

    ; AIA - restore aligned data
    ;restore, '../aia_' + channel + '_aligned.sav'
    ;cube = crop_data(cube)
    ;; Restore aligned data
    ;cube = restore_AIA(channel)

    ; AIA colors
    aia_lct, r, g, b, wave=fix(channel), /load
    ct = [ [r], [g], [b] ]


    ;; Interpolate to get missing data and time.

    ; May return time with fewer sig-figs for seconds.
    time = strmid(index.date_obs,11,11)

    ; center coords relative to FULL DISK:
    x_center=2400
    y_center=1650

    ; No center coords - aligned cube is already cropped:
    ;cube = crop_data(cube)
    ;LINEAR_INTERP, cube, index.date_obs+'Z', 24, time=time

    ; Initialize flux array
    ;sz = size(cube, /dimensions)
    ;flux = fltarr(sz[2])

    ; Can struc values be initialized to empty arrays??
    ; Add _EXTRA to this to include color?
    struc = { $
        name : 'AIA ' + channel + '$\AA$', $
        ;data: cube, $
        data: data, $
        cadence : 24.0, $
        ;flux : flux, $
        time : time, $
        ct : ct $
    }
    if n_elements(e) ne 0 then struc = create_struct(struc, e)
    return, struc
end
