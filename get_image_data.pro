;-
;- 23 October 2018

function GET_IMAGE_DATA

    ;- Read data from fits files to show images.
    ;- Return structure with data and other info to show in images

    ;- Show both AIA channels at 01:44 (beginning of GOES flare).
    ;- Read in HMI B_LOS and HMI continuum, and overplot both contours on AIA.
    ;- Save both image files, and use whichever is better in paper/presentation.
    ;-
    ;-
    ;- Needed information:
    ;-  * Center coordinates of AR at desired date_obs
    ;-      (know coords of first image and approximate rotation rate...
    ;-       simple calculation?)
    ;-  *
    ;-
    ;- First read fits files with NODATA=1 to get observation times from header.
    ;- Need this to figure out index of desired time for inst with different cadence,
    ;-   later improve read_my_fits.pro to take time (or array of times) to do this.
    ;-
    ;-


    resolve_routine, 'read_my_fits'

    display_time = '01:44'

    ;- HMI

    instr = 'hmi'

    ; HMI B_LOS
    channel='mag'

    READ_MY_FITS, index, data, instr=instr, channel=channel, nodata=1, prepped=1 ;ind=[0]
    time = strmid(index.date_obs, 11, 5)
    ind = (where( time eq display_time ))[0]

    READ_MY_FITS, index, data, instr=instr, channel=channel, nodata=0, prepped=1, ind=ind
    sz = size( data, /dimensions )
    X = (indgen(sz[0]) - index.crpix1) * index.cdelt1
    Y = (indgen(sz[1]) - index.crpix2) * index.cdelt2
    time = strmid(index.date_obs, 11, 11)
    hmi_BLOS = { $
        data : data, $
        ;data : data<300>(-300), $
        X : X, $
        Y : Y, $
        extra : { title : 'HMI B$_{LOS}$ ' + time + ' UT'} }

    ; HMI continuum
    channel = 'cont'

    READ_MY_FITS, index, data, instr=instr, channel=channel, nodata=1, prepped=1 ;ind=[0]
    time = strmid(index.date_obs, 11, 5)
    ind = (where( time eq display_time ))[0]

    READ_MY_FITS, index, data, instr=instr, channel=channel, nodata=0, prepped=1, ind=ind
    sz = size( data, /dimensions )
    X = (indgen(sz[0]) - index.crpix1) * index.cdelt1
    Y = (indgen(sz[1]) - index.crpix2) * index.cdelt2
    time = strmid(index.date_obs, 11, 11)
    hmi_cont = { $
        data : data, $
        ;data : data<300>(-300), $
        X : X, $
        Y : Y, $
        extra : { title : 'HMI continuum' + time + ' UT' } }


    ;- AIA
    instr='aia'

    ; AIA 1600
    channel='1600'

    READ_MY_FITS, index, data, instr=instr, channel=channel, nodata=1, prepped=1
    time = strmid(index.date_obs, 11, 5)
    ind = (where( time eq display_time ))[0]

    READ_MY_FITS, index, data, instr=instr, channel=channel, nodata=0, ind=ind, prepped=1
    ;print, 'Processing level = ', strtrim(index.lvl_num,1), ' for AIA ', channel
    sz = size( data, /dimensions )
    X = (indgen(sz[0]) - index.crpix1) * index.cdelt1
    Y = (indgen(sz[1]) - index.crpix2) * index.cdelt2
    time = strmid(index.date_obs, 11, 11)
    aia_lct, wave=fix(channel), r, g, b
    aia1600 = { $
        data : aia_intscale(data,wave=fix(channel), exptime=index.exptime), $
        ;data : data, $
        X : X, $
        Y : Y, $
        extra : { $
            title : 'AIA ' + channel + '$\AA$ ' + time + ' UT', $
            rgb_table : [[r],[g],[b]] } }

    ; AIA 1700
    channel='1700'

    READ_MY_FITS, index, data, instr=instr, channel=channel, nodata=1, prepped=1
    time = strmid(index.date_obs, 11, 5)
    ind = (where( time eq display_time ))[0]

    READ_MY_FITS, index, data, instr=instr, channel=channel, nodata=0, ind=ind, prepped=1
    ;print, 'Processing level = ', strtrim(index.lvl_num,1), ' for AIA ', channel

    sz = size( data, /dimensions )
    X = (indgen(sz[0]) - index.crpix1) * index.cdelt1
    Y = (indgen(sz[1]) - index.crpix2) * index.cdelt2
    time = strmid(index.date_obs, 11, 11)
    aia_lct, wave=fix(channel), r, g, b
    aia1700 = { $
        data : aia_intscale(data, wave=fix(channel), exptime=index.exptime), $
        ;data : data, $
        X : X, $
        Y : Y, $
        extra : { $
            title : 'AIA ' + channel + '$\AA$ ' + time + ' UT', $
            rgb_table : [[r],[g],[b]] } }

    S = { aia1600:aia1600, aia1700:aia1700, hmi_BLOS:hmi_BLOS, hmi_cont:hmi_cont }
    return, S
end


S =  GET_IMAGE_DATA()


end
