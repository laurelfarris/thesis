
;-
;- 18 October 2018
;- Combined all "like codes" into one file.
;- Adding "_SUBROUTINE" to procedure/function that was being called
;-   from the main level. ML code moved to procedure with original filename.
;- Horizontal line between each formerly individual file.


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
