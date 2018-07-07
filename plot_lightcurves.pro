; Last modified:   29 June 2018

; should have no problem running this, even if spontaneously reading
; random data from a few fits files and want to plot it.
; No loops here; call this routine INSIDE loops.

; Also see aia_prep documentation on plotting light curves.


function PLOT_LIGHTCURVES, x, y, _EXTRA=e

    common defaults
    dw
    wx = 8.5
    wy = 3.0; * 2
    win = window( dimensions=[wx,wy]*dpi, buffer=1 );,location=[600,0] )

    ; Margin values for axes that are not on top of other axes.
    ; These are all you should have to change to adjust margins.
    left = 1.00
    bottom = 0.75
    right = 1.00
    top = 0.75
    margin = [ left, bottom, right, top ] * dpi


        p = plot2( $
            x, y, /current, /device, $
            ;current = ... something similar to i<1 for multi-panel figures
            layout = [1,1,1], $
            margin = margin, $
            xticklen = 0.05, $
            yticklen = 0.015, $
            ystyle = 2, $
            xminor = 4, $
            yminor = 4, $
            xtitle='Start time (UT) on 2011-February-15', $
            ;xtitle = 'Start Time (15-Feb-2011 00:00:31.71)', $
            stairstep = 1, $
            _EXTRA=e $
            )
    return, p
end

; Entire time series
time = ['00:00', '04:59']

; C-class flare
time = ['00:30', '01:00']

;ind = [ (where(date_obs eq time[0]))[0] : (where(date_obs eq time[1]))[0] : 75 ]


; show every 30 minutes on x-axis
;   30 minutes --> step = 75
;    5 minutes --> step = 12.5 (decimal step actually works! Calculated from 75/6.)
ind = [74:748:75]
time = strmid(A[0].time,0,5)
xtickvalues = A[0].jd[ind]
xtickname = time[ind]

p = objarr(n_elements(A))

for i = 0, n_elements(p)-1 do begin

    xdata = A[i].jd
    ydata = A[i].flux / A[i].exptime

    if i eq 0 then begin
        p[i] = PLOT_LIGHTCURVES( $
            xdata, $
            ydata, $
            ;ydata-min(ydata), $
            ;overplot=i<1, $
            ;  this should work... maybe can't use with /current?
            ytitle = 'counts (DN s$^{-1}$)', $
            xtickvalues = xtickvalues, $
            xtickname = xtickname, $
            color = A[i].color, $
            name = A[i].name)
     endif else begin
        p[i] = plot2( xdata, ydata, /overplot, color=A[i].color )
     endelse

endfor

; y-axis labels - AIA 1600 on the left and AIA 1700 on the right.
if 0 gt 1 then begin
    ax[3].showtext=1
    values1 = strtrim( (p[0].ytickvalues + min(A[0].flux))/1e7, 1 )
    values2 = strtrim( (p[1].ytickvalues + min(A[1].flux))/1e8, 1 )
    ax[1].tickname = strmid( values1, 0, 3 ) + '$\times 10^7$'
    ax[3].tickname = strmid( values2, 0, 3 ) + '$\times 10^8$'
    ax[1].title = A[0].name + ' (DN s$^{-1}$)'
    ax[3].title = A[1].name + ' (DN s$^{-1}$)'
endif

    ; TO-DO: Input current plot and pull yrange straight from that.
    ;        Figure out a way to run this first, so they're in background
    ;        'Hide' method?

    ;v = plot( [x,x], yrange, /overplot, ystyle=1, _EXTRA=e )
    ; Could also call with overplot=reference_to_plot

    ; Vertical lines at periods of interest
    ;v = objarr(n_elements(period))
    ;for i = 0, n_elements(v)-1 do $
    ;    v[i] = plot_vline( $
    ;        1./period[i], $
    ;        p.yrange, $
    ;        color='grey' $
            ;name=strtrim( fix(1./vert[i]),1) + ' sec' $
    ;        )
    ;leg = legend2(target = v, position = [0.9,0.8])
    ;leg = legend2( target=p,  position = [0.9,0.8])

; Flare start, peak, & end times, marked with vertical lines.
; (only for full time series though...)
flare = ['01:44', '01:56', '02:06']
yr = p.yrange
foreach f, flare do begin

    v = plot_vline( A[i].jd[ where(date_obs eq f))[0] ], $
        overplot=p[i] )
    ; double check that this method of overplot works!

; Shaded area over main flare +/- dz
    v = plot( $
        [ f[0]-32, f[0]-32, f[-1]+32-1, f[-1]+32-1 ], $
        [ yr[0], yr[1], yr[1], yr[0] ], $
        /overplot, $
        ystyle=1, $
        linestyle=6, $
        fill_background=1, $
        fill_transparency=70, $
        fill_color='light gray' )
endforeach

leg = legend2( target=[ p[0], p[1] ],  position=[0.8,0.7] )
stop

; Save figure (had to use different methods because of shaded part).
;save2, 'power_time_4.pdf'
;write_png, 'power_time_4.png', tvrd(/true)
;w.save, '~/power_time_5.png', width=wx*dpi

; Plot power at x +/- dz to show time covered by each value.
;  (see notes from 2018-05-13)

resolve_routine, 'save2'
file = 'lc_dn_per_second.pdf'
save2, file, /add_timestamp


end
