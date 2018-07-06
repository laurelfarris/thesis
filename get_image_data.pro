
; Last modified:   06 July 2018

function GET_IMAGE_DATA

    ; Read new data (only what you want to image).

    resolve_routine, 'read_my_fits'

    ; HMI
    READ_MY_FITS, index, data, inst='hmi', channel='mag', ind=[0]
    sz = size( data, /dimensions )
    X = (indgen(sz[0]) - index.crpix1) * index.cdelt1
    Y = (indgen(sz[1]) - index.crpix2) * index.cdelt2
    time = strmid(index.date_obs, 11, 11)
    hmi = { $
        data : data<300>(-300), $
        X : X, $
        Y : Y, $
        extra : { title : 'HMI B$_{LOS}$ ' + time } }

    ; AIA 1600
    READ_MY_FITS, index, data, inst='aia', channel='1600', ind=[0];, prepped=0
    print, 'Processing level = ', strtrim(index.lvl_num,1)

    sz = size( data, /dimensions )
    X = (indgen(sz[0]) - index.crpix1) * index.cdelt1
    Y = (indgen(sz[1]) - index.crpix2) * index.cdelt2
    time = strmid(index.date_obs, 11, 11)
    aia_lct, wave=1600, r, g, b
    aia1600 = { $
        data : aia_intscale(data,wave=1600,exptime=index.exptime), $
        ;data : data, $
        X : X, $
        Y : Y, $
        extra : { $
            title : 'AIA 1600$\AA$ ' + time, $
            rgb_table : [[r],[g],[b]] } }

    ; AIA 1600
    READ_MY_FITS, index, data, inst='aia', channel='1700', ind=[0];, prepped=0
    print, 'Processing level = ', strtrim(index.lvl_num,1)

    sz = size( data, /dimensions )
    X = (indgen(sz[0]) - index.crpix1) * index.cdelt1
    Y = (indgen(sz[1]) - index.crpix2) * index.cdelt2
    time = strmid(index.date_obs, 11, 11)
    aia_lct, wave=1700, r, g, b
    aia1700 = { $
        data : aia_intscale(data,wave=1700,exptime=index.exptime), $
        ;data : data, $
        X : X, $
        Y : Y, $
        extra : { $
            title : 'AIA 1700$\AA$ ' + time, $
            rgb_table : [[r],[g],[b]] } }

    S = { aia1600:aia1600, aia1700:aia1700, hmi:hmi }
    return, S
end
