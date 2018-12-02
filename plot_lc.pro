

; Last modified:    28 November 2018

goto, start

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
    ;ylog = 1, $
    color=A.color, $
    name=A.name, $
    buffer=1 )

resolve_routine, 'label_time', /either
LABEL_TIME, plt, time=A.time, jd=A.jd

resolve_routine, 'shift_ydata', /either
SHIFT_YDATA, plt

resolve_routine, 'oplot_flare_lines', /either
OPLOT_FLARE_LINES, plt, t_obs=A[0].time, jd=A.jd

resolve_routine, 'legend2', /either
leg = LEGEND2( target=plt, /upperleft )

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

;- 02 December 2018
;- Mark BDA times on LC.

start:
time = strmid(A[0].time,0,5)
bda_times = ['01:00', '01:45', '02:30', '03:15']
ind = n_elements(bda_times)
ind = where( time eq bda_times )
print, ind


;save2, file

end
