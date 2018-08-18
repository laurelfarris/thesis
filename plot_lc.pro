

pro MAKE_WINDOW, position
    ; Set up all measurements (margins, window size, etc.)
    ; Create window and return graphic position

    common defaults

    wx = 8.5
    wy = 4.0
    win = window( dimensions=[wx,wy]*dpi, buffer=1 )

    left = 1.0
    bottom = 1.0
    top = 1.0
    right = 1.0

    x1 = left
    y1 = bottom
    x2 = wx - right
    y2 = wy - top

    position = [x1,y1,x2,y2]
end

pro oplot_things

    v = OPLOT_FLARE_LINES( time, yrange=p[0].yrange, /send_to_back, color='light gray' )

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

    pos = p[0].position
    leg = legend2(  $
        target=[p,v], /normal, $
        position = [ pos[2]*0.90, pos[3]*0.97 ], $
        ;position=[ position[2]-0.25, position[3]-0.25 ]*dpi, $
        sample_width=0.2)
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

function PLOT_VS_TIME, xdata, ydata, _EXTRA = e

    p = PLOT2( $
        xdata, ydata, $
        /current, $
        /device, $
        xminor=5, $
        ymajor=7, $
        xticklen=0.025, $
        yticklen=0.010, $
        stairstep=1, $
        xshowtext=1, $
        yshowtext=1, $
        thick=0, $
        _EXTRA = e )
    return, p
end

function PLOT_LC, xdata, ydata, color=color, name=name, _EXTRA = e

    win = GetWindows(/current)
    win.erase

    sz = size( ydata, /dimensions )
    ;xdata = indgen(sz[0])

    ;ytitle = ['1600$\AA$ (DN s$^{-1}$)', '1700$\AA$ (DN s$^{-1}$)']
    ytitle = 'Counts (DN s$^{-1}$)'

    lc = objarr(sz[1])
    for i = 0, sz[1]-1 do begin
        ;ytitle = name[i] + ' (DN s$^{-1}$)'
        lc[i] = PLOT_VS_TIME( $
            xdata, ydata[*,i], $
            ytitle=ytitle, $
            overplot=i<1, $
            ytitle=ytitle, $
            color=color[i], $
            name=name[i], $
            _EXTRA = e )
    endfor
    return, lc
end

; run once, then comment
MAKE_WINDOW, position

p = PLOT_LC, A.jd, A.flux, color=A.color, name=A.name, position=position*dpi



save2, 'lightcurve.pdf', /add_timestamp




end
