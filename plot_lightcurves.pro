; Last modified:   12 July 2018

    ; subroutine issues: Don't want to pass entire structure (A) into this?

;function PLOT_LIGHTCURVES, x, y, $
;    layout=layout, $
;    current=current, $
;    _EXTRA=e

common defaults
dw
wx = 8.5
wy = 9.0
win = window(dimensions=[wx,wy]*dpi,/buffer)

; Oustide margins - around edge of page
top = 1.0
bottom = 1.0
left = 0.75
right = 0.75
margin = [ left, bottom, right, top ]

;if not keyword_set(layout) then layout=[1,1,1]
layout = [1,3,1]
cols = layout[0]
rows = layout[1]

width = 6.0
height = 1.5
xgap = 0.0
ygap = 0.0

x1 = left + 0*(width + xgap)
y1 = bottom + 2*(height + ygap)
;y1 = wy - top - i*(height + ygap)
x2 = x1 + width
y2 = y1 + height
position = [x1,y1,x2,y2]*dpi

;------------------------------------------------
; Portion of time series to show
time = strmid( get_time(A[i].jd), 0, 5 )
; C-class flare ['00:30' --> '01:00']
t_start = time[0]
t_end   = time[-1]
t1 = (where(time eq t_start))[ 0]
t2 = (where(time eq t_end  ))[-1]
time = time[t1:t2]
;xtickinterval = 30./(60*A[0].cadence)

;; Lightcurve data (2D array: 749x2)
xdata = [ $
    [ A[0].jd[t1:t2] ], $
    [ A[1].jd[t1:t2] ] ]
ydata = [ $
    [ A[0].flux[t1:t2] ], $
    [ A[1].flux[t1:t2] ] ]
ymin = min(ydata)
ymax = max(ydata)

graphic = PLOT2( [t1,t2], [ymin,ymax], /nodata, $
    /current, /device, $
    position=position, $
    ;position = GET_POSITION( ... ) ONE AT A TIME!
       ; here, depends on whether plotting lc, power1, or power2
    xticklen=0.05, yticklen=0.015, xminor=5, yminor=4, $
    xtitle = 'Start time (UT) on 2011-February-15', $
    ;xtitle = 'Start Time (15-Feb-2011 00:00:31.71)', $
    ; automatically set to t_start somehow?
    ytitle = 'counts (DN s$^{-1}$)' )

; show index number on top axis
;indices = where( A[0].jd eq p[0].xtickvalues )
str = graphic.xtickname
ind = []
for i = 0, n_elements(str)-1 do $
    ind = [ind, where( time eq str[i] ) ]
ax[2].tickname = strtrim(ind,1)
ax[2].title = 'image #'



;; Overplot vertical lines
PLOT_VERTICAL_LINES, graphic, time

;; Plot actual data
lc = objarr(n_elements(A))
for i = 0, n_elements(lc)-1 do begin
    lc[i] = plot2( xdata, ydata, $
        /overplot, $
        ;overplot = graphic, $
        color=A[i].color, name=A[i].name, stairstep = 1 )
endfor

leg = legend2( target=[lc], position=[0.8,0.9] )
stop

file = 'lc_power.pdf'
resolve_routine, 'save2'
save2, file;, /add_timestamp

stop

;; Small axis to show range covered by each FT
ax1 = axis('x', location=50, major=2, axis_range=[0,64], target=p[1])

stop

; Plot power at x +/- dz to show time covered by each value.
;  (see notes from 2018-05-13)

;pro POST_PLOT, p

    ; y-axis labels - AIA 1600 on the left and AIA 1700 on the right.
    ax[3].showtext=1
    values1 = strtrim( (p[0].ytickvalues + min( A[0].flux/A[0].exptime ))/1e7, 1 )
    values2 = strtrim( (p[1].ytickvalues + min( A[1].flux/A[1].exptime ))/1e8, 1 )
    ax[1].tickname = strmid( values1, 0, 3 ) + '$\times 10^7$'
    ax[3].tickname = strmid( values2, 0, 3 ) + '$\times 10^8$'
    ax[1].title = A[0].name + ' (DN s$^{-1}$)'
    ax[3].title = A[1].name + ' (DN s$^{-1}$)'
;end

;pro pretty_plots
    ; Time labels in specific increments, e.g. 30 minutes:
    ; only show axis labels on outermost axes
        ; showtext=0|1
;end


end
