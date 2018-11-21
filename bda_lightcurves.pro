
;- 20 November 2018

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

end
