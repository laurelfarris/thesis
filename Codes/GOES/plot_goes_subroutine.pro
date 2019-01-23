pro PLOT_GOES_SUBROUTINE, A, gdata

    common defaults
    dw
    wx = 8.5
    wy = 4.0
    win = window( dimensions=[wx,wy]*dpi, buffer=1 )

    left = 0.75
    bottom = 0.5
    right = 0.5
    top = 0.5
    margin = [left,bottom,right,top]

    width = wx - (left + right)
    height = wy - (top + bottom)
    xticklen = width / 200.
    yticklen = height / 200.


    p = objarr(3)

    for i = 0, 1 do begin
        flux = A[i].flux - min(A[i].flux)
        flux = flux / max(flux)
        xdata = findgen(n_elements(flux)) * A[i].cadence

        p[i] = plot2( $
            xdata, flux, $
            /current, $
            /device, $
            overplot=i<1, $
            layout=[1,1,1], $
            margin=margin*dpi, $
            xmajor=10, $
            xticklen=xticklen, $
            yticklen=yticklen, $
            xtitle='Start Time ' + gdata.utbase, $
            ytitle='intensity (normalized)', $
            color=A[i].color, $
            name=A[i].name )
    endfor

    goesflux = gdata.ydata[*,0] - min(gdata.ydata[*,0])
    goesflux = goesflux / max(goesflux)


    p[2] = plot2( $
        gdata.tarray, $
        goesflux, $
        /overplot, $
        linestyle='--', $
        name = 'GOES 1-8$\AA$')

    xtickvalues = round(p[0].xtickvalues/24)
    xtickname = strmid( A[0].time, 0, 5 )
    p[0].xtickname = xtickname[ xtickvalues ]

    pos = p[2].position * [wx,wy,wx,wy]
    xx = pos[2] - 0.25
    yy = pos[3] - 0.25

    leg = legend2( $
        target=[p], $
        /device, $
        position=[xx,yy]*dpi )

    save2, 'test.pdf'

    stop

end
pro plot_goes

    ;!P.Color = '000000'x
    ;!P.Background = 'ffffff'x

    ;gdata = GOES()

    PLOT_GOES_SUBROUTINE, A, gdata
end


function OPLOT_GOES, data
    ; AIA channels probably need to be normalized to overplot

    ; GOES - create struc if haven't already
    ;    make another struc for this?
    if n_elements(data) eq 0 then data = GOES()

    y = data.ydata[*,0]
    y = y - min(y)
    y = y / max(y)
    x = findgen(n_elements(y))
    x = (x/max(x)) * 749
    g = plot2(  $
        x, y, $
        /overplot, $
        linestyle='__', $
        name='GOES 1-8$\AA$' )
    return, g
end
