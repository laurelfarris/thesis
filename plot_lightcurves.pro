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
    ; Use time from AIA 1600 to label axes (close enough)
    date_obs = strmid( A[0].time, 0, 5 )

    ; increment by 75 data points (30 minutes)
    time = ['00:30','01:00','01:30','02:00','02:30','03:00','03:30','04:00','04:30']
    ind = []
    foreach t, time do $
        ind = [ind, (where( date_obs eq t ))[0]]

    p = objarr(n_elements(A))

        ; struc to separate stuff that never changes,
        ; or stuff that's the same for each iteration (no i-dependence)
        e = { $
            margin : [1.00, 0.75, 1.00, 0.75]*dpi, $
            layout : [1,1,1], $
            xticklen : 0.05, $
            yticklen : 0.015, $
            ytickformat : '(F0.1)', $
            ystyle : 2, $
            xtitle : 'Start Time (15-Feb-2011 00:00:31.71)', $
            stairstep : 1 }

    inc = []
    for i = 0, 1 do begin
        xdata = A[i].jd
        ydata = A[i].flux
        p[i] = plot2( xdata, ydata-min(ydata), /current, /device, overplot=i, $
            xtickvalues = xdata[ind], $
            xtickname = date_obs[ind], $
            color = A[i].color, $
            name = A[i].name, $
            _EXTRA=e )
        ;values = (p[i].ytickvalues + min(ydata))/10e7
        ;if i eq 0 then (p[i].axes)[1].tickname = strtrim( values, 1 )
        ;if i eq 1 then (p[i].axes)[3].tickname = strtrim( values, 1 )
        ;(p[i].axes)[3].showtext = 1
        inc = [inc, (max(ydata)-min(ydata))/4 ]

    endfor

    ;values1 = strtrim([ min(A[0].flux):max(A[0].flux):inc[0] ]/10e0, 1)
    ;values2 = strtrim([ min(A[1].flux):max(A[1].flux):inc[1] ]/10e0, 1)

    values1 = strtrim( (p[0].ytickvalues + min(A[0].flux))/1e7, 1 )
    values2 = strtrim( (p[1].ytickvalues + min(A[1].flux))/1e8, 1 )

    ax = p[0].axes
    ax[1].tickname = strmid( values1, 0, 3 ) + '$\times 10^7$'
    ax[3].tickname = strmid( values2, 0, 3 ) + '$\times 10^8$'
    ;ax[1].tickname = values1
    ;ax[3].tickname = values2
    ax[3].showtext=1
    ax[1].title = A[0].name + ' (DN s$^{-1}$)'
    ax[3].title = A[1].name + ' (DN s$^{-1}$)'

    leg = legend2( target=[ p[0], p[1] ],  position=[0.8,0.7] )

stop
end


;A = [ aia1600, aia1700 ]

wx = 8.5
wy = 3.0; * 2
w = window( dimensions=[wx,wy]*dpi );, name='lightcurve' )


plot_lightcurves, A;, time=['00:30','01:00']


;save2, 'lightcurve_4.pdf' 

;plot_lightcurves, A, ind=[i1,i2]

;v = plot( [i1,i1], graphic.yrange, /overplot, linestyle='-.', thick=1.5 )
;v = plot( [i2,i2], graphic.yrange, /overplot, linestyle='-.', thick=1.5 )


end
