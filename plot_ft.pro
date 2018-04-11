; Last modified:   09 April 2018


pro plot_ft, xdata, A, i, pos


    ;; intermediate place to use _EXTRA ??

    p = objarr(2)
    p[0] = plot2( xdata, A[0].power[*,i], $
        /current, $
        position=pos[*,i], $
        xtitle='frequency (mHz)', ytitle="Power", $
        xtickvalues=[2:max(xdata):4], $
        xtickformat = '(F0.1)', $
        symbol='circle', $
        sym_filled=1, $
        ylog=1, $
        color=A[0].color, $
        name=A[0].name $
        )
    p[1] = plot2( xdata, A[1].power[*,i], $
        /overplot, $
        ylog=1, $
        symbol='circle', $
        sym_filled=1, $
        color=A[1].color, $
        name=A[1].name $
        )

    ax = p[0].axes

    ax[2].title = 'period (seconds)'
    values = [120, 180, 200]
    ax[2].tickvalues = (1./values)*1000.
    ax[2].tickname = strtrim( values, 1 )
    ;ax[2].tickname = strtrim( round(1./(ax[0].tickvalues/1000.)), 1 )
    ax[2].showtext = 1

    v = 1000./values
    yr = p[0].yrange
    for i = 0, 2 do begin
        vert = plot( [v[i],v[i]], [yr[0],yr[1]], /overplot, linestyle='--')
    endfor

    ; Text label
    w = getwindows(/current)
    d = w.dimensions
    tpos = p[0].position
    offset = 20.
    tx = (tpos[2] * d[0]) - offset
    ty = (tpos[3] * d[1]) - offset
    t = text2( tx, ty, A[0].time[i] + ' - ' + A[0].time[i+dz], /device, $
        alignment=1, vertical_alignment=1 )

end
