;---------------------------------------------------------------------------------
;- 21 April 2019
;-   This routine is currently outdated!
;-   Use separate routines prep_aia.pro and prep_hmi.pro for now.
;---------------------------------------------------------------------------------
;-
;- LAST MODIFIED: Thu Dec 20 06:33:23 MST 2018
;-   Added keyword "ind" to only return a subset of time series.
;-   However, code still reads in full data set and does all the calculations,
;-     so not sure if this actually frees any memory.
;-
;- PURPOSE:
;-   Combined prep routines for HMI and AIA.
;- CALLING SEQUENCE:
;-   struc = PREP( index, cube, cadence=cadence, inst=inst, channel=channel )
;- KEYWORDS:
;-   cadence - Enter manually because doesn't appear to be in headers.
;-   inst = 'aia' or 'hmi'
;-   channel
;-     1600 or 1700 for aia
;-     mag or cont for hmi
;- OUTPUT:
;-   Structure with tags:
;-   data = cropped data cube,
;-   X, Y = 2D coords in arcseconds (beginning of ts?),
;-   flux array (summed over AR and exposure-time corrected; NOT per pixel),
;-   time = observation time,
;-   jd = julian date of observation time,
;-   cadence = entered by user,
;-   channel = entered by user,
;-   ct = rgb_table,
;-   color = whatever color you want to plot that data in,
;-   name = combination of instrument and channel,
;-   map = initialzed array in which to restore powermaps from .sav files (later).
;-
;- TO DO:
;-   Initialize ct tag and any others that only apply to one instrument.
;-   Make a separate routine for reading in maps and power vs. time.
;-     Also need a different name for power vs. time.
;-      --> Google this, may be an actual analysis method with a real name.
;-   May need to rewrite this to separate everything that can be done
;-     without header information (like when I have access to .sav files,
;-     but not the fits files, where index is always extracted.


function PREP, index, cube, $
    cadence=cadence, $
	instr=instr, $
	channel=channel, $
    ind=ind



    ;- Unprepped filename:
    ;-  aia.lev1.channelA_yyyy-mm-ddThh_mm_ss.ssZ.image_lev1.fits
    ;- Prepped filename:
    ;-  AIAyyyymmdd_hhmmss_channel.fits


    ; Read headers
    if n_elements(index) eq 0 then begin
        resolve_routine, 'read_my_fits'
        READ_MY_FITS, index, inst=inst, channel=channel, $
            nodata=1, prepped=1
    endif

    ;- Restore data (in variable "cube", with pixel dimensions:
    ;-   AIA [750,500,745] "../aia1600aligned.sav"
    ;-   AIA [750,500,749] "../aia1700aligned.sav"
    ;-   HMI [750,500,400] "../hmi_mag.sav"
    ;-   HMI [750,500,398] "../hmi_cont.sav"

    path = '/solarstorm/laurel07/' + year + month + day + '/'
    if (inst eq 'aia') then begin
        restore, path + '/aia' + channel + 'aligned.sav'
        name = 'AIA ' + channel + '$\AA$'
        ;- Standard AIA colors
        aia_lct, r, g, b, wave=fix(channel);, /load
        ct = [ [r], [g], [b] ]
    endif
    if (inst eq 'hmi') then begin
        restore, '../hmi_' + channel + '.sav'
        ;restore, '../' + inst + '_' + channel + '.sav'
        ; --> still doesn't match aia filenames...
        if channel eq 'mag' then name = 'HMI B$_{LOS}$'
        if channel eq 'cont' then name = 'HMI intensity'
        ;- Does HMI have standard colors?
        ct = 0
    endif

    ;- Interpolate to get missing data and corresponding timestamp.
    time = strmid(index.date_obs,11,11)

    resolve_routine, 'get_jd', /either
    jd = GET_JD( index.date_obs + 'Z' )
    resolve_routine, 'linear_interp', /either
    LINEAR_INTERP, cube, jd, cadence, time
      ;- NOTE: get_jd used to be called by linear_interp.pro, but ended
      ;-   up separating them into two separate routines.

    ;- Crop cube to pixel dimensions [500,330,*].
    cube = crop_data(cube)

    ;- Correct for exposure time (standard data reduction)
    exptime = index[0].exptime
    cube = cube/exptime

    sz = size( cube, /dimensions )

    ; X/Y coordinates of AR (lower left corner),
    ;    converted from pixels to arcseconds
    ; NOTE: Hard coded coords;
    ;   can't automatically generate these values unless I somehow
    ;    save them when aligning or prepping the data.
    x1 = 2150
    y1 = 1485
    ;X = ( (indgen(sz[0]) + x1) - index.crpix1 ) * index.cdelt1
    ;Y = ( (indgen(sz[1]) + y1) - index.crpix2 ) * index.cdelt2
    ;- Don't think index and sz[0|1] are the same size...
    X = ( (indgen(sz[0]) + x1) - index[0].crpix1 ) * index[0].cdelt1
    Y = ( (indgen(sz[1]) + y1) - index[0].crpix2 ) * index[0].cdelt2
    ;- Use the first element for crpix and cdelt;
    ;-   already confirmed that they're all the same value (at least for level 1.5)
    ;-   (see prep_hmi.pro)

    ;- Total flux summed over AR
    flux = total( total( cube, 1), 1 )

    ;if not keyword_set(ind) then ind = [0:sz[2]]
    if keyword_set(ind) then begin
        cube = cube[*,*,ind]
        flux = flux[ind]
        time = time[ind]
        jd = jd[ind]

    ;- Initialize array in which to restore powermap .sav files later.
    map = make_array( sz[0], sz[1], 686, /float, /nozero )
    struc = { $
        ;data: cube[*,*,ind], $
        data: cube, $
        X: X, $
        Y: Y, $
        ;flux: flux[ind], $
        flux: flux, $
        ;time: time[ind], $
        time: time, $
        ;jd: jd[ind], $
        jd: jd, $
        cadence: cadence, $
        exptime: exptime, $
        color: '', $
        ct: ct, $
        channel: channel, $
        name: name, $
        map: map $
    }
    return, struc
end
