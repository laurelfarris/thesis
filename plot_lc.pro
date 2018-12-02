

; Last modified:    28 November 2018





file = 'lc'

xdata = A.jd
ydata = A.flux
xtickinterval = A[0].jd[75] - A[0].jd[0]
ytitle=A.name + ' (DN s$^{-1}$)'

dw
resolve_routine, 'batch_plot', /either
plt = BATCH_PLOT(  $
    xdata, ydata, $
    ;xrange=[0,748], $
    xtickinterval=xtickinterval, $
    ylog = 1, $
    color=A.color, $
    name=A.name, $
    buffer=0 )

resolve_routine, 'label_time', /either
LABEL_TIME, plt, time=A.time, jd=A.jd

resolve_routine, 'shift_ydata', /either
SHIFT_YDATA, plt

resolve_routine, 'oplot_flare_lines', /either
OPLOT_FLARE_LINES, plt, t_obs=A[0].time, jd=A.jd

resolve_routine, 'legend2', /either
leg = LEGEND2( target=plt, sample_width=0.30 )

stop

ax = plt[0].axes
ax[1].title = ytitle[0]
ax[1].tickvalues = [2:8:2]*10.^7
ax[1].tickname = scinot( ax[1].tickvalues )
ax[1].minor = 3


ax = plt[1].axes
ax[3].title = ytitle[1]
ax[3].tickvalues = [2.2:2.8:0.2]*10.^8
ax[3].tickname = scinot( ax[3].tickvalues )
ax[3].minor = 3


; Single lines creating each object that can easily be commented.
; Then just erase and re-draw.

;- --> Put ML stuff into a subroutine that calls all the other subroutines?

end
