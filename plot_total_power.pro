;; Last modified:   23 May 2018 16:19:13

function PLOT_TOTAL_POWER, xdata, ydata, _EXTRA=e

    ; Plot lightcurve and power as function of time.
    ; ONE panel. Call this from another routine for multi-panel.

    win = getwindows()
    if ( win[i] eq !NULL ) then begin
        wx = 8.5; / 2.0
        wy = 3.0; * 2.0
        w = window( dimensions=[wx,wy]*dpi, location=[600,0] )
    endif


    plt = plot2( $
        xdata, ydata, /current, /device, $
        layout=[1,1,1], $
        margin=0.1, $
        xtickinterval=100, $
        xrange=[i1,i2], $
        xticklen=0.05, $
        yticklen=0.015, $
        xtitle='Start time (UT) on 2011-February-15', $
        ytickvalues=[2:10:2]/10., $
        ytickformat='(F0.1)', $
        stairstep=1, $
        ytitle='Counts (DN)', $
        _EXTRA=e)

    ; only label axes on sides so figure looks nice
    ax = plt.axes
    ax[2].title = 'index'

    leg = legend2( $
        target=[ p[0], p[1] ], $
        ;target=p, $
        position=[0.9,0.85] )

    return, plt
end

p = objarr(3)

; Margin values for axes that are not on top of other axes.
; These are all you should have to change to adjust margins.
left = 0.75
bottom = 1.25
right = 0.10
top = 1.25
margin = [ left, bottom, right, top ] * dpi

; Entire time series
t_start = '00:00'
t_end   = '04:59'

; C-class flare
t_start = '00:30'
t_end   = '01:00'

; String to label plot with date_obs from header.
date_obs = strmid( A[0].time, 0, 5 )
i1 = (where( date_obs eq t_start ))[ 0]
i2 = (where( date_obs eq t_end   ))[-1]

if k eq 0 then ax[2].showtext = 1
if k eq n_elements(p)-1 then ax[0].showtext = 1

for i = 0, n_elements(p)-1 do begin
    p[i] = PLOT3( $
        xdata, ydata, $
        layout=[1,3,i+1], $
        margin=margin, $
        xtickname = date_obs[i1:i2], $
        ;xtickname = date_obs[ ax[0].tickvalues ], $
        color=A[i].color, $
        name=A[i].name $
        )
endfor

; Flare start, peak, & end times, marked with vertical lines.
; (only for full time series though...)
f1 = (where( date_obs eq '01:44'))[0]
f2 = (where( date_obs eq '01:56'))[0]
f3 = (where( date_obs eq '02:06'))[0]
f = [f1, f2, f3]
for j = 0, 2 do begin
    v = plot( [f[j],f[j]], graphic.yrange, /overplot, $
        ystyle=1, linestyle='-.', thick=1.5 )
endfor

; Shaded area over main flare +/- dz
yr = plt.yrange
v = plot( $
    [ f[0]-32, f[0]-32, f[-1]+32-1, f[-1]+32-1 ], $
    [ yr[0], yr[1], yr[1], yr[0] ], $
    ;graphic.yrange, $
    /overplot, $
    ystyle=1, $
    ;color='light gray', $
    linestyle=6, $
    fill_background=1, $
    fill_transparency=70, $
    fill_color='light gray' )


; Plot power at x +/- dz to show time covered by each value.
if k ge 1 then begin
    ;yy1 = [ ydata[*,i], fltarr(dz) ]
    n = n_elements(ydata[*,i])
    yy1 = shift( ydata[*,i], -32 )
    yy1 = yy1[0:n-32]
    yy2 = shift( ydata[*,i],  32 )
    yy2 = yy2[32:*]
    q = plot2( xdata[0:n-32], yy1, /overplot, stairstep=1, color='light gray', $
        ;fill_background=1, fill_level=yy1, $
        name='t-dz' )
    q = plot2( xdata[32:*], yy2, /overplot, stairstep=1, color='light gray', $
        ;fill_background=1, fill_level=yy2, $
        name='t+dz' )
endif

; Save figure
;save2, 'power_time_4.pdf'
;write_png, 'power_time_4.png', tvrd(/true)
w.save, '~/power_time_5.png', width=wx*dpi


end
