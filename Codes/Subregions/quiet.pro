

;- 05 October 2018

function EXTRACT_SUNSPOT, A, hmi_cont, hmi_mag
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

    ;hmi_time = strmid( hmi_cont.time, 0, 5 )
    ;z2 = indgen( where( hmi_time eq t_end ) )

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
            name : A[1].name } }
            ;name : A[1].name }, $
;        hmi_cont : { $
;            data : float(crop_data( hmi_cont.data[*,*,z2], center=center+offset, dimensions=dimensions)), $
;            time : hmi_cont.time[z], $
;            cadence : hmi_cont.cadence, $
;            ct : hmi_cont.ct, $
;            name : hmi_cont.name }, $
;        hmi_mag : { $
;            data : float(crop_data( hmi_mag.data[*,*,z2], center=center+offset, dimensions=dimensions)), $
;            time : hmi_mag.time[z], $
;            cadence : hmi_mag.cadence, $
;            ct : hmi_mag.ct, $
;            name : hmi_mag.name } $
;        }
    return, struc
end



function QUIET_POWER_MAPS, struc

    ;- 3 minute period
    fcenter = 1./180
    fmin = 0.0051
    fmax = 0.0061
    aia1600map_3min = powermaps(struc.aia1600.data, 24., fmin=fmin, fmax=fmax, norm=0)
    aia1700map_3min = powermaps(struc.aia1700.data, 24., fmin=fmin, fmax=fmax, norm=0)
    hmicontmap_3min = powermaps(struc.hmi_cont.data, 45., fmin=fmin, fmax=fmax, norm=0)

    ;- 5 minute period
    fcenter = 1./300
    fmin = 0.0028
    fmax = 0.0038
    aia1600map_5min = powermaps(struc.aia1600.data, 24., fmin=fmin, fmax=fmax, norm=0)
    aia1700map_5min = powermaps(struc.aia1700.data, 24., fmin=fmin, fmax=fmax, norm=0)
    hmicontmap_5min = powermaps(struc.hmi_cont.data, 45., fmin=fmin, fmax=fmax, norm=0)

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
;        data, $
;        cols=cols, rows=rows, $
;        xshowtext=0, yshowtext=0, $
;        min_value = min(data), $
;        max_value = max(data), $
;        rgb_table = struc.ct, $
;        title = [ $
;            ;struc.name + time[0] + ' UT' , $
;            struc.titles[0], $
;            struc.titles[1] ] )

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
;    im = IMAGE_ARRAY( $
;        data, $
;        cols=cols, rows=rows, $
;        xshowtext=0, yshowtext=0, $
;        title = title )

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
goto, start

struc = EXTRACT_SUNSPOT( A, hmi_cont, hmi_mag )
;struc = QUIET_POWER_MAPS( struc )


start:;---------------------------------------------------------------------------------------

;- umbra    (370, 215)
;- penumbra (390, 215)

;- coords relative to 100x100 subset.
xx = [50,70]
yy = [50,50]
name = ['umbra', 'penumbra']
color = ['black', 'blue']

dw
win = window( dimensions=[6.0,6.0]*dpi, /buffer)
ind = indgen(250)
cc = 0
plt=objarr(3)
sigplot=objarr(3)

for ii = 0, 1 do begin

    time = strmid( Struc.(cc).time, 0, 5 )

    flux = struc.(cc).data[xx[ii],yy[ii],ind]
    ;flux = struc.(cc).data[ xx[ii]-5:xx[ii]+5-1, yy[ii]-5:yy[ii]+5-1, ind]
    ;flux = total(total(flux,1),1)

    ;flux = total(total(struc.(cc).data[*,*,ind],1),1)
    max_period = (n_elements(flux)*24.)/2.
    min_freq = 1./max_period
    
    ;fake = sin( (ind/250.) *!PI*25) *  0.5*mean(flux)
    ;if ii eq 1 then flux = flux + fake

    result = fourier2( flux, 24, /display, sig_lvl=sig_lvl)
    print, sig_lvl
    frequency = reform(result[0,*])
    power = reform(result[1,*])

    find = where( frequency ge min_freq )
    frequency = frequency[find]
    power = power[find]


    plt[ii] = plot2( $
        ;ind, flux, ylog=0, $
        frequency, power, ylog=1, $
        ;xtitle='frame #', ytitle='intensity', $
        xtitle='frequency (Hz)', ytitle='power', $
        /current, /device, overplot=1<ii, $
        layout=[1,1,1], margin=1.0*dpi, $
        title=struc.(cc).name + ' ' + time[0] + '-' + time[-1], $
        name = name[ii], color=color[ii] ) 
    sig = mean(power) + stddev(power)
    print, sig
    sigplot[ii] = plot2( plt[ii].xrange, [sig_lvl,sig_lvl], ystyle=1, /overplot, $
        linestyle='--', color=color[ii], name='1$\sigma$' )
endfor
;fake = sin( (ind/250.) *!PI*25) *  0.5*mean(flux)

;plt[2] = plot2( ind, fake, /overplot, color='red', name='fake')
;plt[2] = plot2( ind, fake+flux, /overplot, color='red', name='fake')
leg = legend2( target=plt, position=[0.9,0.95])
;file = 'quiet_lightcurves_2.pdf'
file = 'quiet_power_spectra_sig.pdf'

save2, file,  /add_timestamp


stop

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
