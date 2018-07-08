; Last modified:   29 June 2018

; should have no problem running this, even if spontaneously reading
; random data from a few fits files and want to plot it.
; No loops here; call this routine INSIDE loops.

; Also see aia_prep documentation on plotting light curves.

; ---
; Entire time series
;time = ['00:00', '04:59']
; C-class flare
;time = ['00:30', '01:00']
;ind = [ (where(date_obs eq time[0]))[0] : (where(date_obs eq time[1]))[0] : 75 ]
; ---

common defaults

; Window dimensions and outside margins (where axis text is showing).
wx = 8.5
wy = 3.0; * 2
left = 1.00
bottom = 0.75
right = 1.00
top = 0.75
margin = [ left, bottom, right, top ]

; Indices for tick labels
;   30 minutes --> step = 75
;    5 minutes --> step = 12.5 (decimal step actually works! Calculated from 75/6.)
t_start = '00:30'
t_end   = '04:30'
time = strmid(A[0].time,0,5)
i1 = (where( time eq t_start ))[0]
i2 = (where( time eq t_end ))[-1]
ind = [74:748:75]
ind = [i1:i2:75]
xtickvalues = A[0].jd[ind]
xtickname = time[ind]

p = objarr(n_elements(A))
for i = 0, n_elements(p)-1 do begin

    xdata = A[i].jd
    ydata = A[i].flux / A[i].exptime
    ydata = ydata - min(ydata)

    if i eq 0 then begin
        dw
        win = window( dimensions=[wx,wy]*dpi, buffer=1 );,location=[600,0] )

        graphic = plot2( $
            xdata, ydata, $
            /current, /device, /nodata, $
            ;current = ... something similar to i<1 for multi-panel figures
            layout = [1,1,1], $
            margin = margin*dpi, $
            ;yrange =
            xticklen = 0.05, $
            yticklen = 0.015, $
            xminor = 5, $
            yminor = 4, $
            xtitle='Start time (UT) on 2011-February-15', $
            ;xtitle = 'Start Time (15-Feb-2011 00:00:31.71)', $
               ; automatically set to t_start somehow?
            ytitle = 'counts (DN s$^{-1}$)', $
            xtickvalues = xtickvalues, $
            xtickname = xtickname, $
            stairstep = 1, $
            _EXTRA=e )
     endif

     p[i] = plot2( $
        xdata, ydata, $
        /overplot, $
        ;overplot=i<1, $
        ;  this should work... maybe can't use with /current?
        color = A[i].color, $
        name = A[i].name, $
        _EXTRA = e )
 endfor

; y-axis labels - AIA 1600 on the left and AIA 1700 on the right.
ax = graphic.axes
ax[3].showtext=1
values1 = strtrim( (p[0].ytickvalues + min(A[0].flux))/1e7, 1 )
values2 = strtrim( (p[1].ytickvalues + min(A[1].flux))/1e8, 1 )
ax[1].tickname = strmid( values1, 0, 3 ) + '$\times 10^7$'
ax[3].tickname = strmid( values2, 0, 3 ) + '$\times 10^8$'
ax[1].title = A[0].name + ' (DN s$^{-1}$)'
ax[3].title = A[1].name + ' (DN s$^{-1}$)'

resolve_routine, 'save2'
file = 'lc_dn_per_second.pdf'
save2, file;, /add_timestamp
 stop

; Flare start, peak, & end times (only for full time series...)
flare = ['01:44', '01:56', '02:06']
yrange = graphic.yrange

foreach f, flare do begin

    vx = A[0].jd[ (where(time eq f))[0] ]
    v = plot( [vx,vx], yrange, overplot=1, ystyle=1, _EXTRA=e )
    ; Call with overplot=p[i] (reference to plot... need to double check that this works.)

endforeach

; TO-DO: Input current plot and pull yrange straight from that.

;leg = legend2( target = v, position = [0.9,0.8])
;leg = legend2( target = p, position = [0.9,0.8])
;leg = legend2( target=[ p[0], p[1] ],  position=[0.8,0.7] )

; Plot power at x +/- dz to show time covered by each value.
;  (see notes from 2018-05-13)

; Vertical SHADED area (not lines) over main flare +/- dz
    ;v = plot( $
    ;    [ f[0]-32, f[0]-32, f[-1]+32-1, f[-1]+32-1 ], $
    ;    [ yr[0], yr[1], yr[1], yr[0] ], $
    ;    /overplot, $
    ;    ystyle=1, $
    ;    linestyle=6, $
    ;    fill_background=1, $
    ;    fill_transparency=70, $
    ;    fill_color='light gray' )


end
