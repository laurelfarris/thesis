; Last modified: 16 July 2018

; Input:  3D map
; Keywords: cbar - set to create colorbar
;           layout = [cols, rows]

function IMAGE_composites, map, title=title, upperlimit=upperlimit, _EXTRA=e

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


goto, start

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
