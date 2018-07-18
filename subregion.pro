; Last modified:   16 July 2018

goto, start
start:

plot_color = ['blue', 'red', 'green', 'dark orange', 'purple', 'deep sky blue']
fmin = 0.001
fmax = 0.009
common defaults
rows = 2
cols = 1

for ii = 1, 1 do begin

    channel = A[ii].channel
    file = 'aia' + channel + 'subregion.pdf'
    ct = aia_colors(wave=channel)
    wx = 8.5/2
    wy = wx * 1.5
    ;win.erase
    dw
    win = window( dimensions=[wx,wy]*dpi, buffer=1 )

    restore, '../aia' + channel + 'map.sav'
    ;data = A[ii].data[*,*,0]
    data = map[*,*,560]
    sz = size(data, /dimensions)

    result = AIA_INTSCALE( data, wave=fix(channel), exptime=A[ii].exptime )

    im = image2( $
        result, $
        /current, /device, $
        layout=[cols,rows,1], $
        margin=0.5*dpi, $
        rgb_table=ct, $
        xshowtext=0, $
        yshowtext=0 )

    ; Polygons
    side = 50
    x1 = sz[0]/2 + 50
    y1 = sz[1]/2 + 20
    x2 = x1 + side
    y2 = y1 + side
    ;rec.delete
    rec = POLYGON2( x1, y1, x2, y2, target=im, linestyle=0 );, color='black')
    time = strmid(A[ii].time,0,5)

    p = objarr(3)
    foreach jj, [0, 260, 560], kk do begin
        ;data = A[ii].data[x1:x2,y1:y2,560:623]
        data = A[ii].data[x1:x2,y1:y2,jj:jj+63]
        flux = total( total( data,1 ),1 )
        result = fourier2(flux, 24)
        frequency = reform(result[0,*])
        ind = where( frequency ge fmin AND frequency le fmax )
        power = reform(result[1,*])
        p[kk] = plot2( 1000*frequency[ind], power[ind], $
            /current, $
            overplot=kk<1, $
            color=plot_color[kk], $
            sym_size=0.5, $
            name=strtrim(time[jj],1) + '-' + strtrim(time[jj+63],1), $
            layout=[cols,rows,2], $
            symbol='circle', $
            ylog=1, $
            sym_filled=1, $
            xtitle='frequency (mHz)', $
            ytitle='log power' )
    endforeach

leg = legend2( target=[p], /relative, position=[0.9,0.9] )
save2, file, /add_timestamp
endfor


end
