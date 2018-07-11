; Last modified:   11 July 2018

; should have no problem running this, even if spontaneously reading
; random data from a few fits files and want to plot it.
; No loops here; call this routine INSIDE loops.

; Also see aia_prep documentation on plotting light curves.

pro PLOT_VS_TIME, xdata, ydata, overplot=overplot, _EXTRA=e

    common defaults

    ; Window dimensions and outside margins (where axis text is showing).
    left = 1.00
    bottom = 0.75
    right = 1.00
    top = 0.75
    margin = [ left, bottom, right, top ]


    dw
    wx = 8.5
    wy = 3.0; * 2
    win = window( dimensions=[wx,wy]*dpi, buffer=1 );,location=[600,0] )
    p = objarr(n_elements(A))
end


function PLOTT, xdata, ydata, overplot=overplot, _EXTRA=e

    ; Indices for tick labels
    ;   30 minutes --> step = 75
    ;    5 minutes --> step = 12.5 (decimal step actually works! Calculated from 75/6.)
    time = strmid(A[0].time,0,5)
    ;t_start = '00:30'
    ;t_end   = '04:30'
    ;i1 = (where( time eq t_start ))[1]
    ;i2 = (where( time eq t_end ))[-1]
    ;ind = [i1:i2:75]
    ind = [0:n_elements(xdata):75]
    xtickvalues = A[0].jd[ind]

    ; Use caldat to get times - ensures correct time for each jd
    ;xtickname = time[ind]
    xtickname = []
    foreach jd, xtickvalues, i do begin
        caldat, xtickvalues, month, day, year, hour, minute, second
        hour = strtrim(hour,1)
        minute = strtrim(minute,1)
        xtickname = [ xtickname, hour + ':' + minute ]
    endforeach

    p = plot2( $
        xdata, ydata, $
        /device, $
        overplot=overplot, $
        /current, $
        layout = [1,1,1], $
        margin = margin*dpi, $
        xticklen = 0.05, $
        yticklen = 0.015, $
        xminor = 5, $
        yminor = 4, $
        xtitle='Start time (UT) on 2011-February-15', $
        ;xtitle = 'Start Time (15-Feb-2011 00:00:31.71)', $
        ; automatically set to t_start somehow?
        xtickvalues = xtickvalues, $
        xtickname = xtickname, $
        stairstep = 1, $
        _EXTRA = e )

    ax = p[1].axes
    ax[2].showtext=1

    ; show index number on top axis
    ax[2].tickname = strtrim(ind,1)
    ax[2].title = 'image #'

    leg = legend2( target=[p], sample_width=0.3,  position=[0.8,0.7] )
end

xdata = A[0].jd
xrange = [ min(xdata), max(xdata) ]
what_to_plot = 'lightcurve'

case what_to_plot of

    'lightcurve': begin
        ytitle = 'counts (DN s$^{-1}$)'
        ;ydata = ydata - min(ydata)
        ;ydata = ydata / max(ydata)
        file = 'lc.pdf'
        end

    'power': begin
        ytitle = '3-minute power'
        N = n_elements(xdata)
        xdata = xdata[32:N-32-1]
        ydata = A[i].flux / A[i].exptime
        ydata = wrapper( ydata, A[i].cadence )
        file = 'power.pdf'
        end
end

PLOT_VS_TIME, A, xdata, ydata, ytitle=ytitle;, xrange=xrange

resolve_routine, 'save2'
save2, file;, /add_timestamp

stop

; y-axis labels - AIA 1600 on the left and AIA 1700 on the right.
ax[3].showtext=1
values1 = strtrim( (p[0].ytickvalues + min( A[0].flux/A[0].exptime ))/1e7, 1 )
values2 = strtrim( (p[1].ytickvalues + min( A[1].flux/A[1].exptime ))/1e8, 1 )
ax[1].tickname = strmid( values1, 0, 3 ) + '$\times 10^7$'
ax[3].tickname = strmid( values2, 0, 3 ) + '$\times 10^8$'
ax[1].title = A[0].name + ' (DN s$^{-1}$)'
ax[3].title = A[1].name + ' (DN s$^{-1}$)'


; Plot power at x +/- dz to show time covered by each value.
;  (see notes from 2018-05-13)

; Vertical SHADED area (not lines) over main flare +/- dz
vx1 = A[0].jd[ (where( time eq flare[ 0] ))[0] - 32   ]
vx2 = A[0].jd[ (where( time eq flare[-1] ))[0] + 32-1 ]
v = plot( $
    ;[ f[0]-32, f[0]-32, f[-1]+32-1, f[-1]+32-1 ], $
    [ vx1, vx1, vx2, vx2 ], $
    [ yrange[0], yrange[1], yrange[1], yrange[0] ], $
    /overplot, $
    ystyle=1, $
    linestyle=6, $
    fill_background=1, $
    fill_transparency=80, $
    fill_color='light gray' )


end
