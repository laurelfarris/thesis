

;- 21 October 2018





function IMAGE_POWERMAPS, $
    map, $
    rows=rows, $
    cols=cols, $
    titles=titles, $
    rgb_tables=rgb_tables, $
    _EXTRA=e

    common defaults
    ;resolve_routine, 'colorbar2', /either
    resolve_routine, 'get_position', /either

    sz = size(map, /dimensions)

    wx = 8.5
    wy = wx * (float(rows)/cols) * (float(sz[1])/sz[0])
    dw
    win = window( dimensions=[wx,wy]*dpi, /buffer )

    width = 2.5
    height = width

    left=0.75
    top=0.5
    xgap=1.00

    ;- appears that setting right and bottom margins is pointless,
    ;- at least with the way my subroutines are currently set up.
    ;- (also images have preserved aspect ratio... this may not
    ;- be the case for plots.)

    rgb_tables = [ $
        [[ AIA_COLORS(wave=1600)]], $
        [[ AIA_COLORS(wave=1700)]] ]

    im = objarr(cols*rows)

    for ii = 0, n_elements(im)-1 do begin
        position = GET_POSITION( $
            layout=[cols,rows,ii+1], $
            width=width, $
            height=height, $
            wy=wy, $
            left=left, $
            right=right, $
            top=top, $
            bottom=bottom, $
            xgap=xgap )

        im[ii] = image2( $
            ;image_data[*,*,ii], $ Defined when scaling was applied I assume...
            map[*,*,ii], $
            /current, /device, $
            position=position*dpi, $
            ;max_value=0.2*max(map[*,*,ii]), $
            ;min_value=min(map[*,*,ii]), $
            xshowtext=0, $
            yshowtext=0, $
            rgb_table = rgb_tables[*,*,ii], $
            title=titles[ii], $
            _EXTRA=e )
        endfor
    return, im
end

function POWERMAP_CBAR, $
    target=target, $
    _EXTRA=e

    c_width = 0.02
    c_gap = 0.01

    N = n_elements(target)

    for ii = 0, N-1 do begin

        pos = target[ii].position

        cx1 = pos[2] + c_gap
        cy1 = pos[1]
        cx2 = cx1 + c_width
        cy2 = pos[3]

        position=[cx1,cy1,cx2,cy2]

        ;print, position * [wx,wy,wx,wy]

        cbar = COLORBAR( $
            target = target[ii], $
            position=position, $
            /normal, $
            ;/device, $
            ;tickformat='(I0)', $
            ;major=11, $
            textpos=1, $
            orientation=1, $
            tickformat='(F0.1)', $
            font_size = fontsize, $
            font_style = 2, $
            border = 1, $
            title='3-minute power', $
            _EXTRA=e )
        endfor

    return, cbar
end

;- Power maps:
;-   Multiply power maps by mask, which can be created using any threshold.
;-   Compare same power map using multiple thresholds.
;-   Show images used to compute maps: ruNMing average? standard deviation?
;-   How should power maps be scaled visually?  @methods
;-
;- Copy FT bit with fcenter to some other fourier related subroutine.


;- NOTE: initial/final times and location/dimensions of quiet SS from 'quiet.pro'
goto, start
start:;-------------------------------------------------------------------------------------------------

ti = '00:00'
;tf = '01:30'
tf = '01:41'
;ti = '01:30'
;tf = '03:00'
;ti = '03:00'
;tf = '04:30'

norm = 1

;file = 'powermaps_before.pdf'
;file = 'powermaps_during.pdf'
;file = 'powermaps_after.pdf'
;file = 'powermaps_norm_before.pdf'
;file = 'powermaps_norm_during.pdf'
;file = 'powermaps_norm_after.pdf'

;file = 'powermaps_quiet_norm_3min.pdf'
;file = 'powermaps_quiet_norm_5min.pdf'

time = strmid(A[0].time, 0, 5)
zi = (where( time eq ti ))[0]
zf = (where( time eq tf ))[0]
z_ind = [zi:zf]
dz = n_elements(z_ind)

;fcenter = 1./300
;fcenter = 1./180

;- Central frequencies from Reznikova et al. 2012


ff = [0.0050, 0.0055, 0.0060, 0.0070]
foreach fcenter, ff, counter do begin

    file = 'powermaps_quiet_norm_0' + strtrim(counter,1)  + '.pdf'
    print, file

    bandwidth = 0.0004
    ;bandwidth = 0.0010
    fmin = fcenter - (bandwidth/2.)
    fmax = fcenter + (bandwidth/2.)

    result = fourier2( indgen(dz), 24. )
    frequency = result[0,*]
    find = where( frequency ge fmin and frequency le fmax )
    frequency = frequency[find]

    print, ''
    foreach f, frequency do print, f, ' mHz;   ', 1./f, ' sec'
    print, ''


    ;- Crop data to quiet subregion
    dimensions = [125,125]
    center = [365,215]
    data = fltarr(dimensions[0],dimensions[1],dz,2)
    data[*,*,*,0] = crop_data( A[0].data[*,*,z_ind], center=center, dimensions=dimensions )
    data[*,*,*,1] = crop_data( A[1].data[*,*,z_ind], center=center, dimensions=dimensions )

    ;- Use entire AR (no subregion)
    ;data = A.data[*,*,z_ind,*]
    sz = size(data, /dimensions)

    ;-  Calculate power maps
    map = fltarr(sz[0], sz[1], 2)
    resolve_routine, 'power_maps', /either
    for cc = 0, 1 do begin
        map[*,*,cc] = POWER_MAPS( $
            data[*,*,*,cc], $
            A[cc].cadence, fmin=fmin, fmax=fmax, $
            norm=norm )
    endfor

    image_data = map
    cbar_title = strmid( strtrim( 1000.*fcenter, 1 ), 0, 3) + ' mHz'

    ;cbar_title = '3-minute power'
    ;cbar_title = '5-minute power'
    ;cbar_title = '3-minute power (normalized)'
    ;cbar_title = '5-minute power (normalized)'
    ;image_data = alog10(map)
    ;cbar_title = 'log 3-minute power'

    im = IMAGE_POWERMAPS( $
        image_data, $
        rows = 1, $
        cols = 2, $
        titles = A.name + ' ' + ti +  '-' + tf + ' UT' )

    cbar = POWERMAP_CBAR( target=im, title=cbar_title )

    resolve_routine, 'save2', /either
    save2, file

endforeach




stop

    image_data = [ $
        [[data[*,*,130,0]]], $
        [[data[*,*,130,1]]] ]
    im = IMAGE_POWERMAPS( $
        image_data, $
        ;min_value = min(image_data), $
        ;max_value = max(image_data), $
        rows = 1, $
        cols = 2, $
        titles = A.name + ' image' )
    save2, 'images_quiet.pdf'


;- Calculate saturation mask
aia_mask = fltarr( sz[0], sz[1], 2 )
for cc = 0, 1 do begin
    threshold = 9000. / A[cc].exptime
    mask = fltarr( sz[0], sz[1], sz[2] )
    mask[ where( data[*,*,*,cc] lt threshold ) ] = 1.0
    mask = product( mask, 3 )
    aia_mask[*,*,cc] = mask
endfor
image_data = (map * aia_mask)^0.3

end
