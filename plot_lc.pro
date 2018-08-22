; Last modified:        20 August 2018

; Name of file = name of routine called by user.

; x and y titles both need to be optional somehow...
; ytitle changes depending on whether plotting values that are
; normalized, absolute, shifted, exptime-corrected, etc.

; Single lines creating each object that can easily be commented.
; Then just erase and re-draw.


pro LABEL_TIME, p, time

    win = GetWindows(/current)
    ;time = strmid(A[0].time,0,5)
    ax = plt[0].axes
    ax[0].tickname = time[ax[0].tickvalues]
    ax[0].title = 'Start time (UT) on 2011-February-15'

    ; use JULDAY to set xtickvalues before plotting?
    month = 2
    day = 15
    year = 2011
    minute = 0
    second = 0

    xmajor = 5
    xtickvalues = julday( month, day, year, indgen(xmajor), minute, second )

    ;xtickvalues = fltarr(xmajor)
    ;for i = 0, xmajor do begin $
        ;xtickvalues[i] = julday( month, day, year, indgen(xmajor), minute, second )

    ; Or use intervals...
    xtickinterval = 75
end
function MAKE_WINDOW, _EXTRA=e
    ; Set up all measurements (margins, window size, etc.)
    ; Create window and return graphic position

    common defaults
    wx = 8.5
    wy = 4.0

    win = GetWindows(/current)

    if win eq !NULL then begin
        win = window( $
            Name='LC', $
            ;window_title = '', $
            ;title = '', $
            dimensions=[wx,wy]*dpi, $
            buffer=1, $
            font_size=fontsize, $
            _EXTRA=e )
        print, 'Created window "', win.name, '"'
    endif else begin
        win.erase
        print, 'Erased window "', win.name, '"'
    endelse
    return, win
end

function MAKE_POSITION

    common defaults

    win = GetWindows(/current)

    ; Dimensions of current window
    wx = ((win.dimensions)[0])/dpi
    wy = ((win.dimensions)[1])/dpi

    left = 1.0
    bottom = 1.0
    top = 1.0
    right = 1.0

    x1 = left
    y1 = bottom
    x2 = wx - right
    y2 = wy - top

    position = [x1,y1,x2,y2]
    return, position*dpi
end

function MAKE_LEGEND, _EXTRA=e

    win = GetWindows(/current)
    win.Select, /all
    target = win.GetSelect()

    pos = make_position()
    dl = -0.25
    leg = legend2(  $
        /device, $
        position=[ pos[2]+dl, pos[3]+dl ], $
        _EXTRA=e )
    return, leg
end


function PLOT_LC, xdata, ydata, $
    color=color, name=name, _EXTRA = e

    position = MAKE_POSITION()
    ; TO-DO: if no window exists, create one using
    ; margins and graphic height to set window height.

    sz = size( ydata, /dimensions )
    lc = objarr(sz[1])
    for i = 0, n_elements(lc)-1 do begin
        lc[i] = PLOT2( $
            xdata, ydata[*,i], $
            /current, $
            /device, $
            overplot=i<1, $
            position=position, $
            ;xmajor=7, $
            ;xminor=4, $
            xtickinterval=75, $
            ymajor=5, $
            ;yminor=4, $
            ;xshowtext=1, $
            ;yshowtext=1, $
            xticklen=0.025, $
            yticklen=0.010, $
            ;stairstep=1, $
            color=color[i], $
            name=name[i], $
            _EXTRA = e )
    endfor
    return, lc
    ; there's a separate subroutine for this...
    ax = lc[0].axes
    ax[0].title = xtitle[0]
    ax[2].title = xtitle[1]
    ax[1].title = ytitle[0]
    ax[3].title = ytitle[1]
end

function ADJUST_YDATA, p

    ; Shift data in Y-direction
    ;for i = 0, n_elements(p)-1 do begin
    ;endfor
    ;ytitle = 'Counts (DN s$^{-1}$)'

    m = 1.0
    ;---
    p[0].GetData, x, y
    b = min(y)
    p[0].SetData, x, y-b
    ax = p[0].axes
    ax[1].coord_transform = [b,m]
    ax[1].title = '1600$\AA$ (DN s$^{-1}$)'
    ;---
    p[1].GetData, x, y
    b = min(y)
    p[1].SetData, x, y-b
    ax = p[1].axes
    ax[3].title = '1700$\AA$ (DN s$^{-1}$)'
    ax[3].showtext = 1
    return, p
end

function NORMALIZE_YDATA, p
    for i = 0, n_elements(p)-1 do begin
        p[i].GetData, x, y
        y = y-min(y)
        y = y/max(y)
        p[i].SetData, x, y
    endfor
    ax = p[0].axes
    ax[1].style = 2
    ax[1].tickinterval = 0.2
    ax[1].title = 'Intensity (normalized)'
    return, p
end

function OPLOT_GOES, data
    ; AIA channels probably need to be normalized to overplot
    ;  GOES data
    y = data.ydata[*,0]
    y = y - min(y)
    y = y / max(y)
    x = findgen(n_elements(y))
    x = (x/max(x)) * 749
    g = plot2(  $
        x, y, $
        /overplot, $
        linestyle='__', $
        name='GOES 1-8$\AA$' )
    return, g
end


; GOES data - make another struc for this?
;gdata = GOES()

win = MAKE_WINDOW()
ydata = A.flux
;xdata = A.jd-min(A.jd)
xdata = indgen( (size(ydata))[1] )

p = PLOT_LC( xdata, ydata, $
    yshowtext=1, $
    color=A.color, $
    name=A.name )

time = strmid( A[0].time, 0, 5 )
p[0].xtickname = time[p[0].xtickvalues]
p[0].xtitle = 'Start time (UT) on 15-Feb-2011 00:00'
;p[0].xtitle = 'Start time (UT) on ' + gdata.utbase

;; All the different ways to adjust y-values
;p = ADJUST_YDATA( p )
p = NORMALIZE_YDATA( p )

v = OPLOT_FLARE_LINES( $
        A[0].time, $
        yrange=p[0].yrange, $
        /send_to_back, $
        color='light gray' )

; Overplot GOES lightcurves
g = OPLOT_GOES(gdata)



leg = MAKE_LEGEND()

save2, 'lightcurve_1.pdf';, /add_timestamp
end
