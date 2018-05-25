;; Last modified:   11 May 2018 11:08:32








function plot_background, x,y
    ; Pre-flare background

    y = mean( y[0:200] )
    bg = plot2( x,y, /overplot, linestyle=':', thick=1.0, $
        name='pre-flare background')
    return, bg
end

pro plot_lightcurves, A, time=time
    ; time = 2-element array of start and end times, in the form
    ; [ 'hh:mm', 'hh:mm' ]

    common defaults


    ; Still using time from AIA 1600, for consistency.
    date_obs = strmid( A[0].time, 0, 5 )

    p = objarr(n_elements(A))
    for i = 0, n_elements(p)-1 do begin

        ; indices of values to be plotted.
        ; This should accounted for before passing into code that
        ; does the actual plotting...
        if keyword_set( time ) then begin
            i1 = ( where( date_obs eq time[0] ))[ 0]
            i2 = ( where( date_obs eq time[1] ))[-1]
        endif else begin
            i1 = 0
            i2 = -1
        endelse


        ;y = A[i].flux[i1:i2]
        y = A[i].flux_norm[i1:i2]
        ;x = indgen(n_elements(y))
        x = [i1:i2]

        if i eq 0 then begin
            graphic = plot2( $
                x, y, /nodata, $
                /current, $
                /device, $
                layout=[1,2,1], $
                margin=[1.00, 0.75, 0.10, 0.75]*dpi, $
                xtickinterval=12, $
                ;xtickinterval=75, $
                xticklen=0.05, $
                yticklen=0.015, $
                xtitle = 't_obs (UT) on 2011 February 15', $
                ytitle = 'counts (DN)' )
        endif

        p[i] = plot2( $
            x, y, /overplot, $
            stairstep=0, $
            color=A[i].color, $
            name=A[i].name )
    endfor

    ax = graphic.axes
    ; tickvalues on ax[0] are the indices for the correct time array
    ax[0].tickname = date_obs[ ax[0].tickvalues ]
    ax[2].minor = 5
    ax[2].title = 'index'
    ax[2].showtext = 1

    leg = legend2( target=[ p[0], p[1] ] , $
        ;/relative, $
        ;position=[(graphic.xrange)[1],(graphic.yrange)[1]] )
        position=[0.9,0.7] $
        )

end

wx = 8.5
wy = 3.0 * 2
w = window( dimensions=[wx,wy]*dpi );, name='lightcurve' )

plot_lightcurves, A, time=['00:30','01:00']


;save2, 'lightcurve_4.pdf' 

;plot_lightcurves, A, ind=[i1,i2]

;v = plot( [i1,i1], graphic.yrange, /overplot, linestyle='-.', thick=1.5 )
;v = plot( [i2,i2], graphic.yrange, /overplot, linestyle='-.', thick=1.5 )


end
