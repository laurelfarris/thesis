; Last modified:   04 June 2018

; Read data into array/structures in prep.pro before running this

common defaults
p = objarr(n_elements(A))

; Entire time series
time = ['00:00', '04:59']

; C-class flare
time = ['00:30', '01:00']

; structure for each thing to be plotted?
; or one each for lightcurves, power, power_norm, etc.?
for i = 0, n_elements(p)-1 do begin
    xdata = A[i].jd
    xdata = A[i].flux
    p[i] = PLOT_WITH_TIME( $
        xdata, ydata-min(ydata), $
        layout=[1,3,i+1], $
        overplot=i<1, $
        xtitle = 'Start Time (15-Feb-2011 00:00:31.71)', $
        ytitle = A[i].name + ' (DN s$^{-1}$)', $
        color = A[i].color, $
        name = A[i].name $
        )
endfor

;; Set up a loop to go through each of the four axes, for each plot (p[i])

; x-axis - label with date_obs from header (time = [start, finish])
;  ... not necessarily full range of data shown?
;xtickvalues = xdata[ind], $
;xtickname = date_obs[ind], $
time = ['00:30', '04:30']
date_obs = strmid( A[0].time, 0, 5 )
ind = [ (where(date_obs eq time[0]))[0] : (where(date_obs eq time[1]))[0] : 75 ]
; xname = xvalues converted from JD to time?
ax[0].showtext = 1
ax[2].showtext = 1

; y-axis labels - AIA 1600 on the left and AIA 1700 on the right.
ax[3].showtext=1
values1 = strtrim( (p[0].ytickvalues + min(A[0].flux))/1e7, 1 )
values2 = strtrim( (p[1].ytickvalues + min(A[1].flux))/1e8, 1 )
ax[1].tickname = strmid( values1, 0, 3 ) + '$\times 10^7$'
ax[3].tickname = strmid( values2, 0, 3 ) + '$\times 10^8$'
ax[1].title = A[0].name + ' (DN s$^{-1}$)'
ax[3].title = A[1].name + ' (DN s$^{-1}$)'

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
w.save, '~/power_time_5.png', width=wx*dpi

;---------------------------------------------------------
; Didn't end up doing this...
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
end
