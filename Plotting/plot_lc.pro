

; Last modified:    28 November 2018

goto, start

;- Detour: AIA flare start/end times


;- End time: after peak, when flux drops to 0.5*(peak-bg).
;-    This is how GOES end time is determined, so using the same thing for AIA.
for cc = 0, 1 do begin
    bg = mean(A[cc].flux[125:159])
    flare_end = bg + 0.05*( max(A[cc].flux) - bg )
    print, (where( A[cc].flux[0:375] ge flare_end ))[-1]
    ;print, (A[cc].time[where( A[cc].flux[0:375] ge flare_end )])[-1]
endfor
stop


start:;----------------------------------------------------------------------------------
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

;d = goes()
ax[0].title = 'Start Time (' + d.utbase + ' UT)'

ax[2].title = 'Index'
ax[2].minor = 4
ax[2].showtext = 1

;ax[1].tickname = scinot( ax[1].tickvalues )
;ax[3].tickname = scinot( ax[3].tickvalues )

stop




file = 'lc'

ydata = A.flux
;xdata = A.jd
xdata = [ [indgen(749)], [indgen(749)] ]
;xtickinterval = A[0].jd[75] - A[0].jd[0]
xtickinterval = 75
ytitle=A.name + ' (DN s$^{-1}$)'

dw
resolve_routine, 'batch_plot', /either
plt = BATCH_PLOT(  $
    xdata, ydata, $
    xrange=[0,748], $
    thick=[1.0, 1.0], $
    xtickinterval=xtickinterval, $
    ;ylog = 1, $
    color=A.color, $
    name=A.name, $
    buffer=0 )

resolve_routine, 'label_time', /either
LABEL_TIME, plt, time=A.time, jd=A.jd

resolve_routine, 'shift_ydata', /either
SHIFT_YDATA, plt

resolve_routine, 'oplot_flare_lines', /either
OPLOT_FLARE_LINES, plt, t_obs=A[0].time, jd=A.jd, thick=1.0

resolve_routine, 'legend2', /either
leg = LEGEND2( target=plt, /upperleft )

ax = plt[0].axes
ax[1].title = ytitle[0]
ax[1].tickvalues = [2:8:2]*10.^7
;ax[1].tickname = scinot( ax[1].tickvalues )
ax[1].minor = 3


ax = plt[1].axes
ax[3].title = ytitle[1]
ax[3].tickvalues = [2.2:2.8:0.2]*10.^8
ax[3].tickname = scinot( ax[3].tickvalues )
ax[3].minor = 3



;- 14 December 2018
;- Color axes to match data (assuming yshift has been applied)
ax[1].text_color = A[0].color
ax[3].color = A[1].color
print, 'How to colored axes look??'
print, 'ax[1] set color, ax[3] set text_color'
stop


; Single lines creating each object that can easily be commented.
; Then just erase and re-draw.

;- --> Put ML stuff into a subroutine that calls all the other subroutines?

;- 02 December 2018
;- Mark BDA times on LC.

time = strmid(A[0].time,0,5)
bda_times = ['01:00', '01:45', '02:30', '03:15']
nn = n_elements(bda_times)
ind = intarr(nn)
for ii = 0, nn-1 do $
    ind[ii] = (where( time eq bda_times[ii] ))[0]


vert = objarr(nn)
for ii = 0, nn-1 do begin
    vert[ii] = plot( $
        [ind[ii], ind[ii]], $
        plt[0].yrange, $
        /overplot, $
        thick=1.0, $
        color='light gray', $
        ystyle=1 )
    vert[ii].Order, /send_to_back

endfor

;save2, file

end
