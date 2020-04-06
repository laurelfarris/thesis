;; Last modified:   12 April 2018 14:54:40

pro plot_lightcurves, A, ind=ind

    pos = get_position2(layout=[1,1])

    ; Lightcurves
    ;  y title is the only difference between this and plotting
    ;  power vs. time...
    graphic = plot2( x, y, /nodata, $
        position = pos[*,i], $
        /current, $
        /device, $
        xtickinterval=75, $
        xtitle = 'Start time (2011 February 15 00:00:00)', $
        ytitle = 'Intensity (normalized)' )

    p = objarr(n_elements(A))
    for i = 0, n_elements(A)-1 do begin

        y = A[i].flux_norm
        x = indgen(n_elements(y))
        if keyword_set( ind ) then begin
            y = y[ind[0]:ind[1]]
            x = x[ind[0]:ind[1]]
        endif

        ; Lightcurves
        ;  y array is the only difference between this and plotting
        ;  power vs. time...
        y = A[i].flux_norm
        p[i] = plot2( $
            x, y, /overplot, $
            stairstep=1, $
            color=A[i].color, $
            name=A[i].name )

        sm = plot_smooth( x,y )
        bg = plot_background( x,y )

    endfor

    ax = graphic.axes
    ax[0].tickname = A[0].time[ ax[0].tickvalues ]
    ax[2].minor = 5
    ax[2].title = 'Image number'
    ax[2].showtext = 1

    leg = legend2( target=[ p[0], p[1], sm, bg ], $
        position=pos[2:3] + [0.0, -15.0] )


end
;----------------------------------------------------------------------------------

i1 = ( where( A[0].time eq '01:30' )[ 0]
i2 = ( where( A[0].time eq '02:30' )[-1]

plot_lightcurves, A, ind=[i1,i2]

v = plot( [i1,i1], graphic.yrange, /overplot, linestyle='-.', thick=1.5 )
v = plot( [i2,i2], graphic.yrange, /overplot, linestyle='-.', thick=1.5 )


end
