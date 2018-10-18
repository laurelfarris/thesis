
;-
;- 18 October 2018
;- Combining all "like codes" into one file.
;- Adding "_SUBROUTINE" to procedure/function that was being called
;-   from the main level. ML code moved to procedure with original filename.
;- Horizontal line between each formerly individual file.



;-----------------------------------------------------------------------------------

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

;- This was already a stand-alone subroutine, no main level code in this file.

;-----------------------------------------------------------------------------------




; Last modified: 16 July 2018

; Input:  3D map
; Keywords: cbar - set to create colorbar
;           layout = [cols, rows]

function IMAGE_ALL_SUBROUTINE, data, title=title, _EXTRA=e
    ; data can be actual data or power maps

    common defaults

    sz = size(data, /dimensions)
    im = objarr(sz[2])

    layout = [5,8]
    cols = layout[0]
    rows = layout[1]
    wx = 8.5
    wy = 11.0
    win = window( dimensions=[wx,wy]*dpi, /buffer )
    width = 2.0
    height = width * float(sz[1])/sz[0]


    left   = 0.1
    bottom = 0.1
    right  = 0.1
    top    = 0.5
    margin = [left, bottom, right, top] * dpi

    xoff = -0.05
    yoff = 0.0

    i = 0
    im = objarr(cols,rows)
    for y = 0, rows-1 do begin
    for x = 0, cols-1 do begin
        im[x,y] = image2( $
            map[*,*,i], $
            /current, /device, $
            layout=[cols,rows,i+1], $
            margin=margin, $
            xshowtext=0, $
            yshowtext=0, $
            title=title[i], $
            _EXTRA=e )
        ;offset = [x*xoff, y*yoff, x*xoff, y*yoff]
        ;im[x,y].position = im[x,y].position + offset
        i = i + 1
        ;if i eq 23 then return, im
    endfor
    endfor
    return, im
end
pro IMAGE_ALL
    ;- Previous main level routine

    dz = 64
    ii = 1

    channel = A[ii].channel
    data = aia_intscale( A[ii].data, wave=fix(channel), exptime=A[ii].exptime )
    ;map = AIA_INTSCALE( A[ii].map, wave=fix(channel), exptime=A[ii].exptime )
    sz = size(data, /dimensions)

    time = strmid(A[ii].time,0,5)
    index = indgen(n_elements(time))
    time_obs = time + ' (' + strtrim(index,1) + ')'
    time_range = time + '-' + shift(time, -(dz-1)) + $
        ' (' + strtrim(index,1) + '-' + strtrim(shift(index, -(dz-1)), 1)  + ')'
    time_range = time_range[ 0 : sz[2]-1 ]
    ;time_central = (shift(time, -(dz/2)))[ 0 : sz[2]-1 ]

    for j = 0, 7 do begin
        rows = 8
        cols = 5
        step = 2
        i1 = 0 + j*step*(rows*cols)
        print, i1
        ind = [ i1 : sz[2]-1 : step ]

            im = IMAGE_ALL_POWERMAPS( $
                data[*,*,ind], $
                ;map[*,*,ind], $
                layout=[cols,rows], $
                title=time_obs[ind], $
                ;title=time_range[ind], $
                font_size=9, $
                rgb_table=AIA_COLORS(wave=fix(channel)) )

        file = 'aia' + channel + 'dat_' + strtrim(j,1) + '.pdf'
        save2, file
    endfor
end

;-----------------------------------------------------------------------------------


pro IMAGE_AR_SUBROUTINE, S
;function image_ar, data, X, Y, layout=layout, _EXTRA=e
    ;X = ( (indgen(sz[0]) + image_location[0]) - crpix ) * cdelt
    ;Y = ( (indgen(sz[1]) + image_location[1]) - crpix ) * cdelt


    ; Last modified:   06 July 2018

    common defaults

    cols = 3
    rows = 2
    im = objarr(cols,rows)

    left = 0.5
    bottom = 0.5
    right = 0.5
    top = 0.5

    ; width (w) and height (h) of individual panels
    w = 2.0
    h = w

    ; Center of AR* --> lower left corner of AR
    ;   *according to green book (page 50, February 2)
    x0 = 2375
    y0 = 1660
    xl = x0 - 250
    yl = y0 - 165

    ;wx = 8.5/2
    ;wy = wx * (sz[1]/sz[0]) * 2
    wx = 8.0
    wy = 5.0
    dw
    win = window( dimensions=[wx,wy]*dpi, buffer=1 )


    ; Need to speed this part up a little bit...
    for j = rows-1, 0, -1 do begin
        for i = 0, cols-1 do begin

            ; Set up X/Y axis labels in solar coords (arcsec, rel to disk center)
            if j eq 0 then begin
                data = crop_data(S.(i).data, center=[x0,y0])
                X = (S.(i).X)[xl:xl+500-1]
                Y = (S.(i).Y)[yl:yl+330-1]
            endif
            if j eq 1 then begin
                data = S.(i).data
                X = S.(i).X
                Y = S.(i).Y
            endif

            ; Image positions

            ; Multiply by i to add space between panels
            x1 = 0.75 + i*(w+0.1)

            ; shift in h moves TOP row up and down
            y1 = 0.40 + j*(h)
            ;y1 = 0.40 + j*(h-0.5) ; not enough space
            ;y1 = 0.40 + j*(h+0.5) ; too much space

            position=[x1,y1,x1+w,y1+h]

            ;data = aia_intscale(data, wave=wave, exptime=exptime)

            im[i,j] = image2( $
                data, X, Y, $
                /current, /device, $
                position=position*dpi, $
                xshowtext=0, $
                yshowtext=0, $
                _EXTRA=S.(i).extra )

            ; Show x-labels for full disk and AR, since they don't match.
            ax = im[i,j].axes
            ax[0].showtext = 1

            ; Far left column
            if i eq 0 then begin
                ax[1].showtext = 1
                ax[1].title='Y (arcseconds)'
            endif

            ; bottom row
            if j eq 0 then begin
                im[i,j].title = ''
                ax[0].title='X (arcseconds)'
            endif
        endfor
    endfor

    resolve_routine, 'save2'
    file = 'color_images.pdf'
    save2, file;, /add_timestamp
    return

    ; Polygons - Draw rectangle around (temporary) area of interest.
    ;rec = polygon2( x1, y1, x2, y2, target=im[i])
    ;rec = polygon2( 40, 90, 139, 189, target=[im[0,0],im[1,0],im[2,0])
    rec = polygon2( xl, yl, xl+500, yl+330,/device, target=[im[0,0],im[1,0],im[2,0]])

    ; Add text to graphics
    txt = [ '(a)', '(b)' ]
    t = text2( $
        position[0,i], position[3,i], $  ; upper left corner of each panel
        ;0.03, 0.9, $
        txt[i], $
        device=1, $
        ;relative=1, $
        target=im[i], $
        vertical_alignment=1.0, $
        color='white' )
end
pro IMAGE_AR
    ;- Previous main level routine

    ; External routine to save single image in structure S
    ;resolve_routine, 'get_image_data', /either
    ;S = get_image_data()

    IMAGE_AR_SUBROUTINE, S

end

;-----------------------------------------------------------------------------------
function IMAGE_ARRAY_SUBROUTINE, $
    data, $
    ;X, Y, $
    ;dic, $
    cols = cols, $
    rows = rows, $
    title = title, $
    colorbar = colorbar, $
    _EXTRA=e

    ;- Last modified:       05 October 2018


    common defaults

    im = objarr(cols*rows)

    sz = size(data, /dimensions)
    ;wy = wx * (float(sz[1])/sz[0]) * (float(rows)/cols)
    resolve_routine, 'get_position', /either
    resolve_routine, 'colorbar2', /either

    for ii = 0, n_elements(im)-1 do begin

        ; add space to right margin to leave room for colorbar?
        position = GET_POSITION( layout=[cols,rows,ii+1], ygap=0.40 )

        im[ii] = IMAGE2( $
            data[*,*,ii], $
            X, Y, $
            /current, $
            /device, $
            title = title[ii] + '; AR_2a', $
            position=position*dpi, $
            _EXTRA = e )
    endfor
    return, im

    ;- Make separate routine to create colorbar, then return to this level.
    if keyword_set(colorbar) then begin
        for ii = 0, n_elements(im)-1 do begin
            ;im[ii].position = im[ii].position
            ;c = colorbar2(
        endfor
    endif
end
pro IMAGE_ARRAY

    ;- Create 3D array of images you want to show.

    data = [ [[A[0].data[*,*,0]]], [[A[1].data[*,*,0]]], [[hmi_mag[*,*,0]]], [[hmi_cont[*,*,0]]] ]

    aia1600 = dictionary( $
        "data", A[0].data[*,*,0], $
        "title", A[0].name)

    aia1700 = dictionary( $
        "data", A[1].data[*,*,0], $
        "title", A[1].name)

    hmi_mag = dictionary( $
        "data", hmi_mag[*,*,0], $
        "title", "HMI B$_{LOS}$")
end
;-----------------------------------------------------------------------------------


; Last modified: 16 July 2018

; Input:  3D map
; Keywords: cbar - set to create colorbar
;           layout = [cols, rows]

function IMAGE_COMPOSITES_SUBROUTINE, map, title=title, upperlimit=upperlimit, _EXTRA=e

    common defaults

    sz = size(map, /dimensions)

    image_data = map > 0.001; < upper_limit

    cols = 3
    rows = 1
    wx = 8.5
    wy = wx * (float(rows)/cols) * (float(sz[1])/sz[0])
    dw
    win = window( dimensions=[wx,wy]*dpi, /buffer )

    width = 2.30
    height = width * float(sz[1])/sz[0]

    im = objarr(cols*rows)
    for i = 0, n_elements(im)-1 do begin
        position = GET_POSITION( layout=[cols,rows,i+1], $
            width=width, height=height, wy=wy, left=0.1, right=1.5, top=0.25, bottom=0.1, xgap=0.15 )
        im[i] = image2( $
            image_data[*,*,i], $
            /current, /device, $
            position=position*dpi, $
            xshowtext=0, $
            yshowtext=0, $
            title=title[i], $
            _EXTRA=e )
    endfor

    ;; Colorbar
    c_width = 0.02
    c_gap = 0.01
    ;cx1 = (im[cols-1,rows-1].position)[2] + c_gap
    ;cy1 = (im[cols-1,rows-1].position)[1]
    cx1 = (im[-1].position)[2] + c_gap
    cy1 = (im[-1].position)[1]
    cx2 = cx1 + c_width
    cy2 = (im[cols-1].position)[3]
    c = colorbar2( $
        position=[cx1,cy1,cx2,cy2], $
        tickformat='(I0)', $
        major=11, $
        title='3-minute power' )
    return, im
end
pro image_composites

    common defaults

    alph = '(' + string( bindgen(1,26)+(byte('a'))[0] ) + ')'

    dz = 64
    zo = 86 ; z-overlap

    ; Composite power maps
    z_start = [110, 260, 410]
    ;z_str = strtrim(z_start,1)
    titles = strarr( n_elements(z_start), 2 )

    aia_dat = fltarr( 500, 330, n_elements(z_start), 2 )
    aia_map = fltarr( 500, 330, n_elements(z_start), 2 )

    START:
    for ii = 0, 1 do begin
        time = strmid(A[ii].time,0,8)
        titles[*,ii] = alph[0:n_elements(z_start)-1] + '  ' $
            + time[z_start] + ' - ' + time[z_start+dz+zo-1] $
            + ' (' + strtrim(z_start,1) + '-' + strtrim( (z_start+dz+zo-1), 1) + ')'
        foreach z, z_start, jj do begin
            aia_dat[*,*,jj,ii] = mean( A[ii].data[*,*,z:z+dz+zo-1], dimension=3 )
            aia_map[*,*,jj,ii] = mean( A[ii].map[*,*,z:z+zo-1], dimension=3 )
        endforeach
    endfor

    ;frac = [ 0.003, 0.025 ]
    upperlimit = [550,4500]

    for ii = 0, 1 do begin

        channel = A[ii].channel
        im = IMAGE_COMPOSITES( $
            ;AIA_INTSCALE( aia_dat[*,*,*,ii], wave=fix(A[ii].channel), exptime=A[ii].exptime ), $
            aia_map[*,*,*,ii], $
            title=titles[*,ii], $
            max_value = upperlimit[ii], $
            rgb_table=AIA_COLORS(wave=fix(channel)) )
        ;file = 'aia' + channel + 'composite_dat.pdf'
        file = 'aia' + channel + 'composite_maps.pdf'
        save2, file
    endfor

        ;map = AIA_INTSCALE( A[ii].map, wave=fix(channel), exptime=A[ii].exptime )
        ;sz = size(map, /dimensions)
        ;time = strmid(A[ii].time,0,8)
        ;index = indgen(n_elements(time))
        ;time_range = time + '-' + shift(time, -(dz-1)) + ' (' + strtrim(index,1) + '-' + strtrim(shift(index, -(dz-1)), 1)  + ')'
        ;time_range = time_range[ 0 : sz[2]-1 ]
        ;ind = [ 0 : sz[2]-1 : 40 ]

end
;-----------------------------------------------------------------------------------


; Last modified: 16 July 2018

; Input:  3D map
; Keywords: cbar - set to create colorbar
;           layout = [cols, rows]

function IMAGE_POWERMAPS_SUBROUTINE, map, title=title, upperlimit=upperlimit, _EXTRA=e

    common defaults

    ;frac = 0.005
    sz = size(map, /dimensions)
    ;N = n_elements(map)
    ;locs = where( map le frac * max(map) )
    ;print, n_elements(locs) / float(N)

    ;map = map < 0.01 * max(map)
    ;map = map >
    ;map = alog10(map)

    ;image_data = map > 0.001 < frac * max(map)
    image_data = map > 0.001; < upper_limit

    ;image_data = alog10(map[*,*,i])
    ;image_data = map[*,*,i]/mean(map[*,*,i])
    ;image_data = image_data^0.3

    ;cols = 3
    ;rows = 5
    cols = 3
    rows = 3
    wx = 8.5
    wy = wx * (float(rows)/cols) * (float(sz[1])/sz[0])
    dw
    win = window( dimensions=[wx,wy]*dpi, /buffer )

    width = 2.30
    height = width * float(sz[1])/sz[0]

    im = objarr(cols*rows)
    ;resolve_routine, 'get_position', /either
    for i = 0, n_elements(im)-1 do begin
        position = GET_POSITION( layout=[cols,rows,i+1], $
            width=width, height=height, wy=wy, left=0.1, right=1.5, top=0.25, bottom=0.1, xgap=0.15 )
        im[i] = image2( $
            image_data[*,*,i], $
            /current, /device, $
            position=position*dpi, $
            ;max_value=max(image_data), $
            xshowtext=0, $
            yshowtext=0, $
            title=title[i], $
            _EXTRA=e )
    endfor

    ;; Colorbar
    c_width = 0.02
    c_gap = 0.01
    ;cx1 = (im[cols-1,rows-1].position)[2] + c_gap
    ;cy1 = (im[cols-1,rows-1].position)[1]
    cx1 = (im[-1].position)[2] + c_gap
    cy1 = (im[-1].position)[1]
    cx2 = cx1 + c_width
    cy2 = (im[cols-1].position)[3]
    c = colorbar2( $
        position=[cx1,cy1,cx2,cy2], $
        tickformat='(I0)', $
        major=11, $
        title='3-minute power' )
    return, im
end
pro IMAGE_POWERMAPS

    common defaults


    alph = '(' + string( bindgen(1,26)+(byte('a'))[0] ) + ')'


    dz = 64

    ; Composite power maps
    z_start = [0,50,150,200,280,370,430,525,645]
    aia_map = fltarr( 500, 330, n_elements(z_start), 2 )
    titles = strarr( n_elements(z_start), 2 )

    for ii = 0, 1 do begin
        time = strmid(A[ii].time,0,8)
        foreach z, z_start, jj do begin
            map_cube = A[ii].map[*,*,z:z+16]
            aia_map[*,*,jj,ii] = mean( map_cube, dimension=3 )
            titles[jj,ii] = $
                alph[jj] + '  ' + strtrim(time[z],1) + ' - ' + strtrim(time[z+16+dz],1) $
                + ' (' + strtrim(z,1) + '-' + strtrim( (z+16+dz),1) + ')'
        endforeach
    endfor


    ;frac = [ 0.003, 0.025 ]
    upperlimit = [550,4500]

    for ii = 0, 1 do begin

        channel = A[ii].channel
        im = IMAGE_POWERMAPS( $
            aia_map[*,*,*,ii], $
            title=titles[*,ii], $
            max_value = upperlimit[ii], $
            rgb_table=AIA_COLORS(wave=fix(channel)) )

        file = 'aia' + channel + 'composite_maps.pdf'
        save2, file
    endfor

        ;map = AIA_INTSCALE( A[ii].map, wave=fix(channel), exptime=A[ii].exptime )
        ;sz = size(map, /dimensions)
        ;time = strmid(A[ii].time,0,8)
        ;index = indgen(n_elements(time))
        ;time_range = time + '-' + shift(time, -(dz-1)) + ' (' + strtrim(index,1) + '-' + strtrim(shift(index, -(dz-1)), 1)  + ')'
        ;time_range = time_range[ 0 : sz[2]-1 ]
        ;ind = [ 0 : sz[2]-1 : 40 ]

end

;-----------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------
