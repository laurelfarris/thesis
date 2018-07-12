; Last modified:   11 July 2018

; should have no problem running this, even if spontaneously reading
; random data from a few fits files and want to plot it.
; No loops here; call this routine INSIDE loops.

; Also see aia_prep documentation on plotting light curves.



pro POST_PLOT, p

    ; show index number on top axis
    indices = where( A[0].jd eq p[0].xtickvalues )
    ax[2].tickname = strtrim(ind,1)
    ax[2].title = 'image #'

    ; y-axis labels - AIA 1600 on the left and AIA 1700 on the right.
    ax[3].showtext=1
    values1 = strtrim( (p[0].ytickvalues + min( A[0].flux/A[0].exptime ))/1e7, 1 )
    values2 = strtrim( (p[1].ytickvalues + min( A[1].flux/A[1].exptime ))/1e8, 1 )
    ax[1].tickname = strmid( values1, 0, 3 ) + '$\times 10^7$'
    ax[3].tickname = strmid( values2, 0, 3 ) + '$\times 10^8$'
    ax[1].title = A[0].name + ' (DN s$^{-1}$)'
    ax[3].title = A[1].name + ' (DN s$^{-1}$)'

end


function PLOTT, xdata, ydata, $
    left=left, right=right, top=top, bottom=bottom, $
    position=position, $
    _EXTRA=e

    common defaults
    ; Window dimensions and outside margins (where axis text is showing).
    ;wx=wx, wy=wy, $
    margin = [ left, bottom, right, top ]

    p = plot2( $
        xdata, ydata, $
        /device, $
        /current, $
        position=position, $
        overplot=overplot, $
        ;layout = [1,1,1], $
        ;margin = margin*dpi, $
        _EXTRA = e )
    return, p
end

function PLOT_WRAPPER, xdata, ydata, _EXTRA=e

    p = PLOTT( xdata, ydata, $
        left = 1.00, $
        bottom = 0.75, $
        right = 1.00, $
        top = 0.75, $
        ;layout = [1,1,1], $
        position=position, $
        xticklen = 0.05, $
        yticklen = 0.015, $
        xminor = 5, $
        yminor = 4, $
        ;xtitle = 'Start Time (15-Feb-2011 00:00:31.71)', $
        ; automatically set to t_start somehow?
        xtitle = 'Start time (UT) on 2011-February-15', $
        stairstep = 1, $
        _EXTRA = e )
    return, p
end

goto, start

; from power maps (this takes a while)
aia1600power2 = TOTAL_POWER_MAP( A[0].data, '1600', 15000 )
aia1700power2 = TOTAL_POWER_MAP( A[1].data, '1700', 15000 )

common defaults

; portion of time series to plot
time = strmid( update_time(A[0].jd), 0, 5 )
; if not kw_set(t_start/end) then = time[0], time[-1]
t_start = '00:00'
t_end = '04:59'
t1 = (where(time eq t_start))[ 0]
t2 = (where(time eq t_end  ))[-1]
xtickinterval = 30./(60*A[0].cadence)

lc = { $
    xdata : [ [ A[0].jd[t1:t2] ], [ A[1].jd[t1:t2] ] ], $
    ydata : [ [ A[0].flux[t1:t2] ], [ A[1].flux[t1:t2] ] ], $
    ytitle : 'counts (DN s$^{-1}$)' }

; Power --- calculations should go somewhere else!
;   esp since calculating mask map takes a while

; from total flux
xdata = A[0].jd[t1:t2]
N = n_elements(xdata)
aia1600power = CALC_POWER_TIME( A[0].flux, A[0].cadence )
aia1700power = CALC_POWER_TIME( A[1].flux, A[1].cadence )
power1 = { $
    xdata : lc.xdata[32:N-32-1,*], $
    ydata : [ [aia1600power], [aia1700power] ], $
    ytitle : '3-minute power' }

power2 = { $
    xdata : lc.xdata[32:N-32-1,*], $
    ydata : [ [aia1600power2], [aia1700power2] ], $
    ytitle : '3-minute power' }

stop

start:

plot_data = { power1:power1, power2:power2, lc:lc }

dw
wx = 8.5
wy = 9.0
win = window( dimensions=[wx,wy]*dpi, buffer=1 )

top = [2.00, 0.0, 0.0 ]
bottom = [0.0, 0.0, 2.0]

w = 6.0
h = 1.5

xrange = [ min(xdata), max(xdata) ]
for j = 0, 2 do begin
    p = objarr(n_elements(A))
    for i = 0, n_elements(p)-1 do begin
        x1 = 1.00 
        y1 = 1.00 + j*h
        x2 = x1 + w
        y2 = y1 + h
        position=[x1,y1,x2,y2]*dpi
        ydata = plot_data.(j).ydata[*,i]
        ydata = ydata - min(ydata)
        ydata = ydata / max(ydata)
        p[i] = PLOT_WRAPPER( $
            plot_data.(j).xdata[*,i], $
            ydata, $
            position=position, $
            ;layout=[1,3,j+1], $
            ;top = top[j], $
            ;bottom = bottom[j], $
            xshowtext = 0, $
            overplot=i<1, $
            xrange=xrange, $
            xtickinterval=xtickinterval, $
            color=A[i].color, $
            name=A[i].name)
    endfor
    if j eq 0 then begin
        ax = p[0].axes
        ax[0].tickname = strmid(update_time(p[0].xtickvalues),0,5)
        ax[0].showtext=1
    endif

    ; Flare start, peak, & end times (only for full time series...)
    flare = ['01:44', '01:56', '02:06']
    name = ['start', 'peak', 'end' ]

    ; Vertical lines showing flare start, peak, end
    yrange = p[1].yrange
    for k = 0, n_elements(flare)-1 do begin
        ; TO-DO: Pull yrange straight from current plot
        ind = (where( time eq flare[k] ))[0]
        vx = A[0].jd[ind]
        v = plot( [vx,vx], yrange, overplot=1, ystyle=1, color='silver' );,linestyle=3, color='grey', linestyle=i+2, name=name[i] )
        ; Call with overplot=p[i] (reference to plot... need to double check that this works.)
    endfor
    i1 = (where( time eq flare[0 ] ))[0] - 32
    i2 = (where( time eq flare[-1] ))[0] + 32-1
    ind = [i1, i2]
    for k = 0, 1 do begin
        vx = A[0].jd[ind[k]]
        v = plot( [vx,vx], yrange, overplot=1, ystyle=1, linestyle=3, color='dark gray' );, linestyle=i+2, name=name[i] )
    endfor
endfor

ax1 = axis('x', location=50, major=2, axis_range=[0,64], target=p[1])

leg = legend2( target=[p], position=[0.8,0.9] )

file = 'lc_power.pdf'
resolve_routine, 'save2'
save2, file;, /add_timestamp

    ; Plot power at x +/- dz to show time covered by each value.
    ;  (see notes from 2018-05-13)

end
