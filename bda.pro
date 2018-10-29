;- 25 October 2018
;pro get_bda, data, bda, ind, z_start, phase=phase, channel=channel, time=time, exptime=exptime
goto, start
start:;----------------------------------------------------------------------------------

;z_start = [ 16, 58, 196, 216, 248, 280, 314, 386, 450, 525, 600, 658 ]
common defaults

for cc = 0, 1 do begin

phases = [ 'before', 'during', 'after1', 'after2' ]
color = ['black', 'red', 'blue', 'green']
name = [ 'AR_1', 'AR_2', 'AR_3', 'background' ]
add_poly = 1
channel = A[cc].channel
exptime=A[cc].exptime

time = strmid(A[cc].time,0,5)

foreach phase, phases do begin

    file = 'aia' + A[cc].channel + phase

    if phase eq 'before' then begin
        ind = [0:259]
        z_start = [ 16, 58, 196]
    endif

    if phase eq 'during' then begin
        ind = [260:344]
        z_start = [ 216, 248, 280]
    endif

    if phase eq 'after1' then begin
        ;after: z_start = 2:06, 2:30, 3:00 (right before first small post-flare event)
        ind = [314:519]
        z_start = [314, 386, 450]
    endif

    if phase eq 'after2' then begin
        ;after: z_start = 3:30, 4:00, ~4:20 (right before second small post-flare event)
        ind = [520:748]
        z_start = [525, 600, 658 ]
    endif


    dz = 64
    N = n_elements(z_start)

    bda = fltarr(500, 330, N*2)
    title = strarr(N*2)

    threshold = 8000. / exptime
    restore, '../aia' + channel + 'map_2.sav'
    ;mask = mask(A[cc].data, threshold, dz)

    GET_MASK, A[cc].data, mask, threshold, dz, data_avg
    data_avg = data_avg * mask
    map = map * mask

    for ii = 0, N-1 do begin
        ;bda[*,*,ii] = A[cc].data[*,*,z_start[ii]-(dz/2)]
        ;bda[*,*,ii] = mean( data[*,*,z_start[ii]:z_start[ii]+(dz-1)], dim=3 )
        ;bda[*,*,ii] = mask[*,*,z_start[i]]*mean( A[cc].data[*,*,z_start[ii]:z_start[ii]+(dz-1)], dim=3 )
        bda[*,*,ii] = data_avg[*,*,z_start[ii]]
        bda[*,*,ii+N] = map[*,*,z_start[ii]]
        ;title[ii] = time[z_start[ii]+(dz/2)] + ' UT'
        title[ii] = time[z_start[ii]] + '-' + time[z_start[ii]+dz] + ' UT'
    endfor

    imdata = [ $
        [[ aia_intscale( bda[*,*,0:2], wave=fix(A[cc].channel), exptime=1.0 ) ]], $
        [[ alog10(bda[*,*,3:5]) ]] ]

    resolve_routine, 'image3', /either
    im = image3( $
        imdata, $
        xshowtext=0, $
        yshowtext=0, $
        rows=2, cols=3, $
        title=title, $
        rgb_table=A[cc].ct, $
        width = 2.3, $
        left = 0.5, $
        xgap = 0.2, $
        top = 0.25, $
        ygap = 0.25, $
        wy = 4.0 )

    ax = im[0].axes
    ax[1].showtext = 1
    ax[1].tickname = ' '
    ax[1].title = 'mean intensity'

    ax = im[3].axes
    ax[1].showtext = 1
    ax[1].tickname = ' '
    ax[1].title = '3-min power'

    ;- polygons

    x0 = [100, 230, 375, 425]
    y0 = [125, 175, 225,  75]
    r = 125

    if add_poly eq 1 then begin
        for ii = 0, 5 do begin
            for jj = 0, n_elements(x0)-1 do begin
                pol = polygon2( center=[x0[jj],y0[jj]], dimensions=[r,r], target=im[ii], $
                    color = color[jj])
                txt = text2( name[jj], target=pol, position=[x0[jj],y0[jj]]+[-r/2,r/2] )
            endfor
        endfor
        ;file = file  + '_poly'
    endif
    save2, file + '.pdf'


    ;- Plot LC for subregions outlined by polygons

    nn = n_elements(x0)
    flux = fltarr( n_elements(ind), nn )

    for ii = 0, nn-1 do begin
        flux[*,ii] = total( total( $
            crop_data( $
                A[cc].data[*,*,ind], $
                center=[x0[ii],y0[ii]], $
                dimensions=[r,r] ), 1), 1)
    endfor

    continue

    resolve_routine, 'plot3', /either
    plt = plot3( $
        ;A[cc].jd[ind], $
        ind, $
        flux, $
        stairstep = 1, $
        ytitle = A[cc].channel + ' DN s$^{-1}$', $
        xmajor=7, xtitle='time (UT)', $
        linestyle='-', $
        color=color, $
        left = 1.00, right = 0.2, top = 0.2, bottom = 0.5, $
        name=name )

    plt[0].xtickname = time[plt[0].xtickvalues]
    pos = plt[0].position
    leg = legend2( target=plt, position=[pos[2], pos[3]], /relative )

    save2, 'aia' + A[cc].channel + 'lc_subregions_' + phase + '.pdf'

    ;- Plot spectra for subregions outlined by polygons

;    power = []
;    for jj = 0, n_elements(z_start)-1 do begin
;        for ii = 0, (size(flux,/dimensions))[1]-1 do begin
;            FT, flux[ z_start[jj]:z_start[jj]+dz-1,ii], A[cc].cadence, frequency, power
;            win = window(dimensions=[8.5, 4.0], /buffer)
;            plt = plot2( $
;                frequency, power, $
;                /current, $
;                overplot=jj<1, $
;                layout = [3,1,jj+1], $
;                stairstep = 1, $
;                xmajor=7, $
;                ;height=6, $
;                ;left = 0.75, right = 0.2, top = 0.2, bottom = 0.5, $
;                ytitle = A[cc].channel + ' power', $
;                linestyle='-', $
;                color=color, $
;                name=name[ii] )
;        endfor
;        pos = plt[0].position
;        leg = legend2( target=plt, position=[pos[2], pos[3]], /relative )
;    endfor
;    save2, 'aia' + A[cc].channel + 'spectra_subregions' + phase + '.pdf'


;    if (plt[0].ylog eq 1) then plt[0].ytitle = 'log ' + plt[0].ytitle
;
;        ax = plt[0].axes
;
;            ax[2].showtext = 1
;            ax[2].title = 'period (seconds)'
;            ax[2].tickvalues = 1./[120, 180, 200]
;            ax[2].tickname = strtrim( round(1./(ax[2].tickvalues)), 1 )
;
;        ;- convert frequency units: Hz --> mHz AFTER labeling period.
;        ;- SYNTAX: axis = a + b*data
;        ax[0].coord_transform=[0,1000.]
;        ax[0].title='frequency (mHz)'
;        ax[0].tickformat='(F0.2)'
;
endforeach
endfor
end
