
;- 22 October 2018
;-
;- To do: array of structures might be handy here,
;-   e.g. A[0].map as opposed to map[*,*,*,0]


function EXTRACT_SUNSPOT, A, hmi_cont, hmi_mag
    ;- 05 October 2018

    ;- Crop data to SS "2a" (upper right) from 00:00 to beginning of main flare.
    ;- Data over which to calculate power maps

    ;channels = [ 'dop', 'mag', 'cont' ]
    ;HMI, channels, cube, time, X, Y
    ;stop

    t_start = '00:00'
    t_end = '01:44'

    z_start = 0
    z_end = 259
    dz = 260
    z = indgen(dz)

    hmi_time = strmid( hmi_cont.time, 0, 5 )
    z2 = indgen( where( hmi_time eq t_end ) )

    dimensions=[100,100]
    center=[365,215]
    offset = [-10,-2]

    ;- See if it's possible to delete tags from structures,
    ;-   i.e. trim down A instead of creating all new structures with the same information.
    ;- Maybe use prep.pro to create this structure (or dictionary),
    ;-   then just trim it down here.

    struc = { $
        aia1600 : { $
            data : float(crop_data( A[0].data[*,*,z], center=center, dimensions=dimensions)), $
            time : A[0].time[z], $
            cadence : A[0].cadence, $
            ct : A[0].ct, $
            name : A[0].name }, $
        aia1700 : { $
            data : float(crop_data( A[1].data[*,*,z], center=center, dimensions=dimensions)), $
            time : A[1].time[z], $
            cadence : A[1].cadence, $
            ct : A[1].ct, $
            name : A[1].name }, $
        hmi_cont : { $
            data : float(crop_data( hmi_cont.data[*,*,z2], center=center+offset, dimensions=dimensions)), $
            time : hmi_cont.time[z], $
            cadence : hmi_cont.cadence, $
            ct : hmi_cont.ct, $
            name : hmi_cont.name }, $
        hmi_mag : { $
            data : float(crop_data( hmi_mag.data[*,*,z2], center=center+offset, dimensions=dimensions)), $
            time : hmi_mag.time[z], $
            cadence : hmi_mag.cadence, $
            ct : hmi_mag.ct, $
            name : hmi_mag.name } $
        }
    return, struc
end



function QUIET_POWER_MAPS, struc

    ;- 3 minute period
    fcenter = 1./180
    fmin = 0.0051
    fmax = 0.0061
    aia1600map_3min = power_maps(struc.aia1600.data, 24., fmin=fmin, fmax=fmax, norm=0)
    aia1700map_3min = power_maps(struc.aia1700.data, 24., fmin=fmin, fmax=fmax, norm=0)
    hmicontmap_3min = power_maps(struc.hmi_cont.data, 45., fmin=fmin, fmax=fmax, norm=0)

    ;- 5 minute period
    fcenter = 1./300
    fmin = 0.0028
    fmax = 0.0038
    aia1600map_5min = power_maps(struc.aia1600.data, 24., fmin=fmin, fmax=fmax, norm=0)
    aia1700map_5min = power_maps(struc.aia1700.data, 24., fmin=fmin, fmax=fmax, norm=0)
    hmicontmap_5min = power_maps(struc.hmi_cont.data, 45., fmin=fmin, fmax=fmax, norm=0)

    ;- May want to separate calculation of maps from complicated code that may produce errors,
    ;-   especially if maps take a long time to compute.

    aia1600 = create_struct( struc.aia1600, $
        'maps', [ [[aia1600map_3min]], [[aia1600map_5min]] ], $
        'titles', ['AIA 1600$\AA$ @ 5 mHz', 'AIA 1600$\AA$ @ 3 mHz'] )

    aia1700 = create_struct( struc.aia1700, $
        'maps', [ [[aia1700map_3min]], [[aia1700map_5min]] ], $
        'titles', ['AIA 1700$\AA$ @ 5 mHz', 'AIA 1700$\AA$ @ 3 mHz'] )

    hmi_cont = create_struct( struc.hmi_cont, $
        'maps', [ [[hmicontmap_3min]], [[hmicontmap_5min]] ], $
        'titles', ['HMI continuum @ 5 mHz', 'HMI continuum @ 3 mHz'] )

    hmi_mag = struc.hmi_mag

    ;- Add maps to each sub-structure?
    struc = {  aia1600:aia1600, aia1700:aia1700, hmi_cont:hmi_cont, hmi_mag:hmi_mag }
    return, struc

end


pro MAKE_IMAGES, struc, wave, exptime, contour_data=contour_data, savefile=savefile

    ;- Tried scaling logarithmically (~Rouppe van der Voort et al. 2003)

    maps = alog10(struc.maps)
    data = [ $
        ;[[ aia_intscale( struc.data[*,*,0], wave=wave, exptime=exptime )]], $
        [[ maps[*,*,0] ]], $
        [[ maps[*,*,1] ]] ]

    common defaults
    dw
    wx = 8.5/2
    wy = 7.0
    cols = 1
    rows = 2

    time = strmid(struc.time,0,5)

    win = window( dimensions=[wx,wy]*dpi, /buffer)
    resolve_routine, 'contour2', /either
    resolve_routine, 'image_array', /either
    ;im = IMAGE_ARRAY( $
    im = IMAGE2( $
        data, $
        cols=cols, rows=rows, $
        xshowtext=0, yshowtext=0, $
        min_value = min(data), $
        max_value = max(data), $
        rgb_table = struc.ct, $
        title = [ $
            ;struc.name + time[0] + ' UT' , $
            struc.titles[0], $
            struc.titles[1] ] )

     for ii = 0, 1 do begin

        im[ii].Select
        cbar = colorbar2( target=im[ii], title='log power' )

        ;sz = (size(contour_data, /dimensions))[0]
        ;quiet_avg = mean(contour_data[sz-100:sz-1,0:99])
        ;c2 = quiet_avg * 0.6
        ;c1 = quiet_avg * 0.9

        contours = CONTOUR2( $
            contour_data[*,*,70], $
            ;n_levels=2, $
            c_value = [0.6, 0.9] * max(contour_data[*,*,70]), $ 
            c_thick = [0.5, 0.5], $
            color = 'black', $
            ;c_color = 0, $
            ;c_color = ['black','black'], $
            c_label_show=0, $
            /overplot )
    endfor

    save2, savefile
end

pro HMI_IMAGES, hmi_cont, hmi_mag, savefile=savefile

    common defaults
    dw
    wx = 8.5/2
    wy = 7.0
    cols = 1
    rows = 2

    z = 70

    data = [ [[hmi_cont.data[*,*,z]]], [[hmi_mag.data[*,*,z]]] ]
    title = [ $
        hmi_cont.name + ' ' + strmid(hmi_cont.time[z],0,5) + ' UT', $
        hmi_mag.name + ' ' + strmid(hmi_mag.time[z],0,5) + ' UT' $
        ]
    cbar_title = [ 'intensity', 'magnetic field (Gauss)' ]
    win = window( dimensions=[wx,wy]*dpi, /buffer)

    resolve_routine, 'image_array', /either
    ;im = IMAGE_ARRAY( $
    im = IMAGE2( $
        data, $
        cols=cols, rows=rows, $
        xshowtext=0, yshowtext=0, $
        title = title )

     for ii = 0, 1 do begin

        im[ii].Select
        c = colorbar2( target=im[ii], title=cbar_title[ii] )

        contours = CONTOUR2( $
            data[*,*,ii], $
            n_levels = 1, $
            c_thick = 0.5, $
            color = 'red', $
            c_label_show=0, $
            /overplot )
    endfor

    save2, savefile
end

pro ML_code

    struc = EXTRACT_SUNSPOT( A, hmi_cont, hmi_mag )
    struc = QUIET_POWER_MAPS( struc )
    stop

    start:;---------------------------------------------------------------------------------------
    ;contour_data = struc.hmi_cont.data
    contour_data = struc.hmi_mag.data
    MAKE_IMAGES, struc.aia1600, 1600, A[0].exptime, contour_data=contour_data, $
        savefile = 'aia1600quiet_mag.pdf'
    MAKE_IMAGES, struc.aia1700, 1700, A[1].exptime, contour_data=contour_data, $
        savefile = 'aia1700quiet_mag.pdf'
    stop

    HMI_IMAGES, struc.hmi_cont, struc.hmi_mag, savefile = 'hmi.pdf'

    plus = symbol( 55, 50, 'plus', /data, sym_color='white', sym_size=1 )
    plus = symbol( 75, 50, 'plus', /data, sym_color='white', sym_size=1 )

    save2, 'test_symbol.pdf'
    stop



    ;- FT plots
    ;- Same center coords for umbra, penumbra estimated ~20 pixels below

    z = [0:259]
    umbra = reform( A[1].data[370,215,z] )
    penumbra = reform( A[1].data[390,215,z] )

    result1 = fourier2( umbra, 24 )
    result2 = fourier2( penumbra, 24 )

    freq1 = result1[0,*] * 1000
    freq2 = result2[0,*] * 1000
    power1 = result1[1,*]
    power2 = result2[1,*]

    power1 = power1 - min(power1)
    power1 = power1 / max(power1)
    power2 = power2 - min(power2)
    power2 = power2 / max(power2)

    dw
    win = window(/buffer)
    p1 = plot( freq1, power1, /current, $
        xrange=[0.0,10.0], yrange=[0.0,1.0], $
        xtitle = 'frequency (mHz)', $
        ytitle = 'power (arbitrary)', $
        name='umbra', color='blue' )
    p2 = plot( freq2, power2, /overplot, name='penumbra' )
    leg = legend2(target=[p1,p2])
    save2, 'test_ft_1600.pdf'

    stop

    ;- Image each data set at 00:00


    ; pre-flare data (up to but not including C-flare)
    data = crop_data( A[0].data[*,*,0:125], dimensions=dimensions, center=center )
    fmin = 0.005
    fmax = 0.006
    result = fourier2(z, 24)
    frequency = result[0,*]
    ind = where( frequency ge fmin AND frequency le fmax ) 

end



pro plot_lc, data
;--- Plot light curves for quiet umbra, penumbra, ... --------

    umb = data[ sz[0]/2, sz[1]/2, *, 0 ]
    pen = data[ 100, 75, *, 0 ]

    dw
    win = window(/buffer)
    p = objarr(2)
    p[0] = plot2( umb, /current, layout=[1,1,1], margin=0.2, name='umbra' )
    p[1] = plot2( pen, /overplot, color='blue', name='penumbra' )
    leg = legend2( target=p )
    save2, 'lc_test.pdf', /add_timestamp

end

pro image_AR, data
    dw
    win = window(/buffer)
    im = image2( data[*,*,0,1], /current, layout=[1,1,1], margin=0.1, rgb_table=A[1].ct)
    save2, 'test.pdf'
end

pro powermap_subregion, time, data

    ;- input arguments: things that typically have to come from main level:
    ;-   AIA structure elements and
    ;-   specific values (bandpass, fcenter, t_start, etc.)

    ;- Calculate power maps for quiet subregion at several central frequencies

    norm = 1

    ;- Center/dimensions of sunspot at upper right of AR 11158
    xx = 150
    yy = xx
    dimensions = [ xx, yy ]
    center = [365,215]

    fcenter = [ $
        0.0033, $
        0.0056, $
        0.0065, $
        0.0083 ]

    rows = 2
    cols = 2

    ti = '00:00'
    tf = '01:41'

    ;- Reznikova2012 \pm 0.2 mHz
    ;bandwidth = 0.0004
    bandwidth = 0.001

    ;- Crop data to desired spatial and temporal (z) coords
    time = strmid(A[0].time, 0, 5)
    zi = (where( time eq ti ))[-1]
    zf = (where( time eq tf ))[ 0]
    z_ind = [zi:zf]
    dz = n_elements(z_ind)

    resolve_routine, 'crop_data', /either
    data = crop_data( A.data, center=center, dimensions=dimensions, z_ind=z_ind ) 
    sz = size(data, /dimensions)

    map = fltarr(sz[0], sz[1], n_elements(fcenter), 2 )

    resolve_routine, 'power_maps', /either
    for cc = 0, 1 do begin
        foreach fc, fcenter, ii do begin
            fmin = fc - (bandwidth/2.)
            fmax = fc + (bandwidth/2.)
            map[*,*,ii,cc] = POWER_MAPS( data[*,*,*,cc], $
                A[cc].cadence, fmin=fmin, fmax=fmax, norm=norm )
        endforeach
    endfor
    return, map
end

pro image_powermap_subregion, map
    ;-- Image power maps

    common defaults
    resolve_routine, 'save2', /either

    for cc = 0, 1 do begin
        ;image_data = crop_data( map[*,*,*,cc], dimensions=[20,20], center=[25,25] )
        image_data = alog10(map[*,*,*,cc])

        im_titles = alph[0:(rows*cols)-1] + ' ' + [ $
                ;A[cc].channel + '$\AA$ ' + time[sz[2]/2] + ' UT', $
            strmid( strtrim( 1000.*fcenter, 1 ), 0, 4) + ' mHz' ]

        resolve_routine, 'image_powermaps', /either
        im = IMAGE_POWERMAPS( $
            image_data, $
            rows = rows, $
            cols = cols, $
            xtitle = 'X (pixels)', $
            ytitle = 'Y (pixels)', $
            rgb_table = A[cc].ct, $
            titles = im_titles )

        win = GetWindows(/current)
        win.title = 'AIA ' + A[cc].channel
        cbar = COLORBAR2( target=im, major=5, title='log power' )

        file = 'aia' + A[cc].channel + 'powermap_norm_2.pdf'
        ;file = 'aia_quiet_powermaps.pdf'
        save2, file, append=0, close=0, /add_timestamp
    endfor
end


goto, start
start:;---------------------------------------------------------------------------------------



end
