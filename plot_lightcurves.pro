; Last modified:   12 July 2018


pro POST_PLOT, p

    ; show index number on top axis
    indices = where( A[0].jd eq p[0].xtickvalues )
    ax[2].tickname = strtrim(ind,1)
    ax[2].title = 'image #'

    ; y-axis labels - AIA 1600 on the left and AIA 1700 on the right.
    ax[3].showtext=1
    values1 = strtrim( (p[0].ytickvalues + min( A[0].flux/A[0].exptime ))/1e7, 1 )
    values2 = strtrim( (p[1].ytickvalues + min( A[1].flux/A[1].exptime ))/1e8, 1 )
    ax[1].tickname = strmid( values1, 0, 3 ) + '$\times 10^7$'
    ax[3].tickname = strmid( values2, 0, 3 ) + '$\times 10^8$'
    ax[1].title = A[0].name + ' (DN s$^{-1}$)'
    ax[3].title = A[1].name + ' (DN s$^{-1}$)'
end

pro pretty_plots
    ; Time labels in specific increments, e.g. 30 minutes:
    ; only show axis labels on outermost axes
        ; showtext=0|1
    print, 'placeholder'
end


function PLOT_LIGHTCURVES, x, y, $
    layout=layout, $
    current=current, $
    _EXTRA=e

    ; graphics up here (position, layout, etc)
    ; subroutine issues:
    ;  Don't want to pass entire structure (A) into this?

    common defaults

    if not keyword_set(layout) then layout=[1,1,1]
    cols = layout[0]
    rows = layout[1]

    ; Oustide margins - around edge of page
    top = 1.0
    bottom = 1.0
    left = 0.75
    right = 0.75
    margin = [ left, bottom, right, top ]

    w = 6.0
    h = 1.5
    xgap = 0.0
    ygap = 0.0

    wx = 8.5
    wy = 9.0
    if not keyword_set(current) then win = window(dimensions=[wx,wy]*dpi,/buffer)

    for i = 0, rows-1 do begin
        for j = 0, cols-1 do begin
            ;position = GET_POSITION( ... ) ONE AT A TIME!
            x1 = left + j*(w + xgap)
            y1 = bottom + i*(h + ygap)
            x2 = x1 + w
            y2 = y1 + h
            position = [x1,y1,x2,y2]
            graphic = plot2( x, y, $
                /nodata, /current, $
                ;layout=layout, $
                position=position, $
                xticklen=0.05, yticklen=0.015, xminor=5, yminor=4, $
                stairstep = 1, $
                _EXTRA=e
                )
        endfor
    endfor
    return, graphic
end

common defaults

; Portion of time series to show
time = strmid( get_time(A[i].jd), 0, 5 )
; C-class flare ['00:30' --> '01:00']
t_start = time[0]
t_end   = time[-1]
t1 = (where(time eq t_start))[ 0]
t2 = (where(time eq t_end  ))[-1]
;xtickinterval = 30./(60*A[0].cadence)


; What's my problem with creating graphic separately again?
; could easily remove lines themselves after overplotting, then
; re-draw them without re-creating the entire figure...
graphic = PLOT_LIGHTCURVES( [t1:t2], [t1:t2], $
    layout = [1,3,1], $
                ;xtitle = 'Start Time (15-Feb-2011 00:00:31.71)', $
                ; automatically set to t_start somehow?
                xtitle = 'Start time (UT) on 2011-February-15', $
    ytitle = 'counts (DN s$^{-1}$)' )
; rename to plot_position, setup_graphics, or something similar

lc = objarr(n_elements(A))
stop

for i = 0, n_elements(lc)-1 do begin

    ; X/Y data to plot
    xdata = A[i].jd[t1:t2]
    ydata = A[i].flux[t1:t2]

    lc[i] = plot2( xdata, ydata, /overplot, $
        color=A[i].color, $
        name=A[i].name $
        )
endfor

leg = legend2( target=[lc], position=[0.8,0.7] )

file = 'lc_power.pdf'
resolve_routine, 'save2'
save2, file;, /add_timestamp

stop
    ; Flare start, peak, & end times (only for full time series...)
    flare = ['01:44', '01:56', '02:06']
    name = ['start', 'peak', 'end' ]

    ; Vertical lines showing flare start, peak, end
    yrange = p[1].yrange
    for k = 0, n_elements(flare)-1 do begin
        ; TO-DO: Pull yrange straight from current plot
        ind = (where( time eq flare[k] ))[0]
        vx = A[0].jd[ind]
        v = plot( [vx,vx], yrange, overplot=1, ystyle=1, color='silver' );,linestyle=3, color='grey', linestyle=i+2, name=name[i] )
        ; Call with overplot=p[i] (reference to plot... need to double check that this works.)
    endfor
    i1 = (where( time eq flare[0 ] ))[0] - 32
    i2 = (where( time eq flare[-1] ))[0] + 32-1
    ind = [i1, i2]
    for k = 0, 1 do begin
        vx = A[0].jd[ind[k]]
        v = plot( [vx,vx], yrange, overplot=1, ystyle=1, linestyle=3, color='dark gray' );, linestyle=i+2, name=name[i] )
    endfor
endfor

ax1 = axis('x', location=50, major=2, axis_range=[0,64], target=p[1])

leg = legend2( target=[p], position=[0.8,0.9] )


    ; Plot power at x +/- dz to show time covered by each value.
    ;  (see notes from 2018-05-13)

end
