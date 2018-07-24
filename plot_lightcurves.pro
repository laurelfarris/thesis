; Last modified:   12 July 2018

    ; subroutine issues: Don't want to pass entire structure (A) into this?

function PLOT_LIGHTCURVES, $
    time, $
    xdata, ydata, $
    layout=layout, $
    color=color, $
    name=name, $
    _EXTRA=e

    common defaults

    cols = layout[0]
    rows = layout[1]

    ; Oustide margins - around edge of page
    top = 1.0
    bottom = 1.0
    left = 1.00
    right = 0.5
    margin = [ left, bottom, right, top ]

    width = 6.0
    height = 1.5
    xgap = 0.0
    ygap = 0.0

    ;; Position
    x1 = left + 0*(width + xgap)
    y1 = bottom + (layout[2]-1)*(height + ygap)
    x2 = x1 + width
    y2 = y1 + height
    position = [x1,y1,x2,y2]*dpi

    ; Overplot vertical lines (may not need this anymore - see plot_lines.pro)
    flare = ['01:44', '01:56', '02:06']
    ;name = ['start', 'peak', 'end' ]
    i1 = (where( time eq flare[0 ] ))[0]
    i2 = (where( time eq flare[1 ] ))[0]
    i3 = (where( time eq flare[2 ] ))[0]
    vx = [ i1-32, i1, i2, i3, i3+32-1 ]

    ;; Axis ranges
    xrange = [0,748]
    pad = 0.05*( max(ydata) - min(ydata) )
    yrange = [ min(ydata)-pad, max(ydata)+pad ]

    graphic = PLOT2( $
        xdata, ydata[*,0], /nodata, $
        /current, /device, $
        position=position, $
        xticklen=0.05, yticklen=0.015, xminor=5, yminor=4, $
        xtickvalues = [0:749:75], $
        xrange = xrange, $
        yrange = yrange, $
        xshowtext=0, $
        xtitle = 'Start time (UT) on 2011-February-15', $
        _EXTRA=e )

    p = objarr( (size(ydata, /dimensions))[1] )
    for ii = 0, n_elements(p)-1 do begin
        y = ydata[*,ii]
        p[ii] = plot2( $
            xdata, ydata[*,ii], /overplot, $
            color=color[ii], name=name[ii], $
            stairstep=1 )
    endfor

    ; Shaded region
    v = plot( $
        ;[ vx[0], vx[0], vx[-1], vx[-1] ], $
    ;vx = [ i1-32, i1, i2, i3, i3+32-1 ] --> vx = [i1,i2,i3]
        [ vx[0]-32, vx[0]-32, vx[-1]+32-1, vx[-1]+32-1 ], $
        [ yrange[0], yrange[1], yrange[1], yrange[0] ], $
        /overplot, ystyle=1, linestyle=6, $
        fill_transparency=50, $
        fill_background=1, $
        fill_color='light gray' )
    v.Order, /SEND_TO_BACK
    ;for jj = 1, n_elements(vx)-2 do v = plot( [vx[jj],vx[jj]], yrange, overplot=1, ystyle=1, linestyle=3 )

    ; Could also replace this with 'plot_flare_times'
    resolve_routine, 'plot_lines', /either, /compile_full_file
    v = PLOT_VERTICAL_LINES( [ vx[1], vx[2], vx[3] ], yrange )
    v.Order, /SEND_TO_BACK
    return, p
end

;dw
wx = 8.5
wy = 7.0
win = WINDOW(dimensions=[wx,wy]*dpi, buffer=0)

;; Time (x-axis)
time = strmid( get_time(A[0].jd), 0, 5 )
;x = [ [ A[0].jd[t1:t2] ], [ A[1].jd[t1:t2] ] ]
dz = 64
N = 500.*330.

p = objarr(3)

;; Lightcurve data (2D array: 749x2)

ytitle = 'counts (DN s$^{-1}$)'
ydata = [ [ A[0].flux/N ], [ A[1].flux/N ] ]
xdata = [0:n_elements(ydata[*,0])]

p[0] = PLOT_LIGHTCURVES( time, xdata, ydata, layout=[1,3,3], $
    color=A.color, name=A.name, ytitle=ytitle )
ax = (p[0])[0].axes
ax[2].showtext = 1
ax[2].title = 'index'


;; Power data (2D array: 749x2)

ytitle = '3-minute power'
ydata = [ [ A[0].power_flux ], [ A[1].power_flux ] ]
xdata = [ (dz/2) : 749-(dz/2)-1 ]

p[1] = PLOT_LIGHTCURVES( time, xdata, ydata, layout=[1,3,2], $
    color=A.color, name=A.name, ytitle=ytitle )

ydata = [ [ A[0].power_maps ], [ A[1].power_maps ] ]

p[2] = PLOT_LIGHTCURVES( time, xdata, ydata, layout=[1,3,1], $
    color=A.color, name=A.name, ytitle=ytitle )

leg = legend2( target=[p[0]], position=[0.85,0.7], /relative )
ax = (p[2])[0].axes
ax[0].tickname = time[fix(ax[0].tickvalues)]
ax[0].showtext = 1

; Pass targets in the form of arrays (whatever method did that...)

win.Select, /ALL
target = win.GetSelect()
t = TEXT2( target=target )

file = 'lc_power.pdf'
resolve_routine, 'save2'
save2, file;, /add_timestamp

;; Small axis to show range covered by each FT
;ax1 = axis('x', location=50, major=2, axis_range=[0,64], target=p[1])

; Plot power at x +/- dz to show time covered by each value.
;  (see notes from 2018-05-13)

;pro POST_PLOT, p

    ; y-axis labels - AIA 1600 on the left and AIA 1700 on the right.
;    ax[3].showtext=1
;    values1 = strtrim( (p[0].ytickvalues + min( A[0].flux/A[0].exptime ))/1e7, 1 )
;    values2 = strtrim( (p[1].ytickvalues + min( A[1].flux/A[1].exptime ))/1e8, 1 )
;    ax[1].tickname = strmid( values1, 0, 3 ) + '$\times 10^7$'
;    ax[3].tickname = strmid( values2, 0, 3 ) + '$\times 10^8$'
;    ax[1].title = A[0].name + ' (DN s$^{-1}$)'
;    ax[3].title = A[1].name + ' (DN s$^{-1}$)'
;end

;pro pretty_plots
    ; Time labels in specific increments, e.g. 30 minutes:
    ; only show axis labels on outermost axes
        ; showtext=0|1
;end

; show index number on top axis
;indices = where( A[0].jd eq p[0].xtickvalues )
;str = graphic.xtickname
;ind = []
;for i = 0, n_elements(str)-1 do $
;    ind = [ind, where( time eq str[i] ) ]
;ax[2].tickname = strtrim(ind,1)
;ax[2].title = 'image #'

; Portion of time series to show
;time = strmid( get_time(A[0].jd), 0, 5 )
; C-class flare ['00:30' --> '01:00']
;t_start = time[0]
;t_end   = time[-1]
;t1 = (where(time eq t_start))[ 0]
;t2 = (where(time eq t_end  ))[-1]
;time = time[t1:t2]


end
