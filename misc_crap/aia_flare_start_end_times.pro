;+
;- LAST MODIFIED:
;-   28 November 2018
;-
;- --> big ugly light curves (for reference, not official sciency figures)
;-
;-
;- Detour (from plot_lc.pro) : AIA flare start/end times


;- End time: after peak, when flux drops to 0.5*(peak-bg).
;-    This is how GOES end time is determined, so using the same thing for AIA.
for cc = 0, 1 do begin
    bg = mean(A[cc].flux[125:159])
    flare_end = bg + 0.05*( max(A[cc].flux) - bg )
    print, (where( A[cc].flux[0:375] ge flare_end ))[-1]
    ;print, (A[cc].time[where( A[cc].flux[0:375] ge flare_end )])[-1]
endfor
stop


;- where do AIA channels start to increase?
;xtemp = [0:225]
;xtemp = [250:375]
;xtemp = [450:525]
xtemp = [630:748]
ytemp = A.flux[xtemp]; * A[cc].exptime
xtemp = [ [xtemp], [xtemp] ]

plt = BATCH_PLOT( $
    xtemp, ytemp, $
    ;xtickinterval = 5, xminor = 3, $
    xtickinterval = 25, xminor = 9, $
    yminor = 9, $
    color = A.color, $
    name = A.name, $
    buffer=0, $
    wx = 11.0, $
    wy = 8.5, $
    left   = 1.25, $
    right  = 1.25, $
    top    = 2.5, $
    bottom = 2.5, $
    sym_size = 0.3, $
    symbol='Circle')

resolve_routine, 'shift_ydata', /either
delt = [ $
    min(ytemp[*,0]), min(ytemp[*,1]) - 0.08*max(ytemp[*,1]) ]
SHIFT_YDATA, plt, delt=delt, ytitle = A.name + ' (DN s$^{-1}$)'

resolve_routine, 'label_time', /either
LABEL_TIME, plt, time=A.time

ax = plt[0].axes

d = goes()
ax[0].title = 'Start Time (' + d.utbase + ' UT)'

ax[2].title = 'Index'
ax[2].minor = 4
ax[2].showtext = 1

;ax[1].tickname = scinot( ax[1].tickvalues )
;ax[3].tickname = scinot( ax[3].tickvalues )

end
