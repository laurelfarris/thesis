; Last modified:        20 August 2018


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
    return, position
end

pro oplot_things

    ;; Make little axis bar showing width of dz
    dz_axis = axis( $
        'X', $
        axis_range=[ dz, dz*2 ], $
        location=(p[0].yrange)[1] - 0.2*(p[0].yrange)[1], $
        major=2, $
        minor=0, $
        tickname=['',''], $
        title='$T=64$', $
        tickdir=1, $
        textpos=1, $
        ;tickdir=(i mod 2), $
        tickfont_size = fontsize )

    p[1].GetData, x, y ; ?

    ax[1].title=ytitle[0]
    ax[3].title=ytitle[1]
end

pro label_time, plt, time

    time = strmid(A[0].time,0,5)
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

function PLOT_LC, xdata, ydata, $
    ytitle=ytitle, xtitle=xtitle, $
    color=color, name=name, _EXTRA = e

    common defaults
    win = MAKE_WINDOW()
    position = MAKE_POSITION()

    sz = size( ydata, /dimensions )

    lc = objarr(sz[1])
    for i = 0, n_elements(lc)-1 do begin
        lc[i] = PLOT2( $
            xdata, ydata[*,i], $
            /current, $
            /device, $
            overplot=i<1, $
            position=position*dpi, $
            ;xmajor=5, $
            ;xminor=4, $
            ;ymajor=5, $
            ;yminor=4, $
            xshowtext=1, $
            yshowtext=1, $
            xticklen=0.025, $
            yticklen=0.010, $
            ;stairstep=1, $
            color=color[i], $
            name=name[i], $
            _EXTRA = e )
    endfor
    ; there's a separate subroutine for this...
    ax = lc[0].axes
    ax[0].title = xtitle[0]
    ax[2].title = xtitle[1]
    ax[1].title = ytitle[0]
    ax[3].title = ytitle[1]
    return, lc
end

win2 = window(buffer=1)
test = plot2( A[0].jd, A[0].flux, /current )
stop
; Name of file = name of routine called by user.

; x and y titles both need to be optional somehow...

; ytitle changes depending on whether plotting values that are
; normalized, absolute, shifted, exptime-corrected, etc.
;ytitle = ['1600$\AA$ (DN s$^{-1}$)', '1700$\AA$ (DN s$^{-1}$)']
;ytitle = 'Counts (DN s$^{-1}$)'

;xdata = indgen(sz[0])
p = PLOT_LC( $
    A.jd, $
    A.flux, $
    position=position*dpi, $
    color=A.color, $
    name=A.name, $
    xtitle=['index', 'Time (jd)'], $
    ytitle=A.name + ' (DN s$^{-1}$)' )

;v = OPLOT_FLARE_LINES( $
;    A[0].time, $
;    yrange=p[0].yrange, $
;    thick=0, $
;    /send_to_back, $
;    color='light gray' )

lshift = -0.25
leg = legend2(  $
    ;/normal, $
    ;position = [ position[2]*0.90, position[3]*0.97 ], $
    position=[ position[2]+lshift, position[3]+lshift ]*dpi, $
    target=[p,v] )

save2, 'lightcurve.pdf';, /add_timestamp


end
