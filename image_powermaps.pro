; Last modified: 16 July 2018

; Input:  3D map
; Keywords: cbar - set to create colorbar
;           layout = [cols, rows]

function IMAGE_POWERMAPS, map, title=title, layout=layout, _EXTRA=e

    sz = size(map, /dimensions)
    common defaults

    cols = layout[0]
    rows = layout[1]
    ;wx = 8.5
    ;wy = wx * (float(rows)/cols) * (float(sz[1])/sz[0])
    ;win = window( dimensions=[wx,wy]*dpi, /buffer )
    width = 2.0
    height = width * float(sz[1])/sz[0]

    i = 0
    im = objarr(cols,rows)
    for y = 0, rows-1 do begin
    for x = 0, cols-1 do begin
        position = POS(layout=[x,y],width=width,height=height,wy=wy)
        im[x,y] = image2( $
            map[*,*,i], $
            /current, /device, $
            position=position, $
            xshowtext=0, $
            yshowtext=0, $
            title=title[i], $
            _EXTRA=e )
        ;t = text2(0.9, 0.9, target=im[x,y], relative=1, i=i, color='black')
        i = i + 1
    endfor
    endfor
    return, im
end
goto, start

START:
dz = 64
for ii = 1, 1 do begin

    channel = A[ii].channel
    map = AIA_INTSCALE( A[ii].map, wave=fix(channel), exptime=A[ii].exptime )
    sz = size(map, /dimensions)
    time = strmid(A[ii].time,0,8)
    index = indgen(n_elements(time))

    time_range = time + '-' + shift(time, -(dz-1)) + $
        ' (' + strtrim(index,1) + '-' + strtrim(shift(index, -(dz-1)), 1)  + ')'
    time_range = time_range[ 0 : sz[2]-1 ]

    rows = 5
    cols = 3
    step = 40
    ind = [ 0 : sz[2]-1 : step ]
    im = IMAGE_POWERMAPS( $
        map[*,*,ind], $
        layout=[cols,rows], $
        title=time_range[ind], $
        ;font_size=9, $
        rgb_table=AIA_COLORS(wave=fix(channel)) )

    ;; Colorbar
    c_width = 0.02
    c_gap = 0.01
    cx1 = (im[cols-1,rows-1].position)[2] + c_gap
    cy1 = (im[cols-1,rows-1].position)[1]
    cx2 = cx1 + c_width
    cy2 = (im[cols-1,0].position)[3]
    c = colorbar2( $
        position=[cx1,cy1,cx2,cy2], $
        tickformat='(I0)', $
        major=11, $
        title='3-minute power' )

    file = 'aia' + channel + 'map.pdf'
    save2, file
endfor

end
