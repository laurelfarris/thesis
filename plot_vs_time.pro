
;----------------------------------------------------------------------------------

;- Lots of subroutines already in this one!


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
    ax = p[0].axes
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

    ; there's a separate subroutine for this...
    ax = lc[0].axes
    ax[0].title = xtitle[0]
    ax[2].title = xtitle[1]
    ax[1].title = ytitle[0]
    ax[3].title = ytitle[1]
end

function MAKE_POSITION, win=win
    ; win kw to see if variable needs to be passed in order to retrieve NAME
    ; Returns position in INCHES

    common defaults

    if not keyword_set(win) then win = GetWindows(/current)

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

function MAKE_LEGEND, $
    ;win=win, $
    _EXTRA=e

    common defaults

    win = GetWindows(/current)
    win.Select, /all
    target = win.GetSelect()
    ;pos = (target[0].position)/dpi

    ; not actually using target here...
    pos = MAKE_POSITION()
    dl = -0.25
    lx = pos[2] - 0.10
    ly = pos[3] - 0.10
    leg = legend2(  $
        /device, $
        position = [lx, ly]*dpi, $
        _EXTRA=e )
    return, leg
end


function SHIFT_YDATA, p

    ; Shift data in Y-direction
    ;for i = 0, n_elements(p)-1 do begin
    ;endfor
    ;ytitle = 'Counts (DN s$^{-1}$)'

    m = 1.0
    format = '(F0.1)'
    ;---
    p[0].GetData, x, y
    b = min(y)
    p[0].SetData, x, y-b
    ax = p[0].axes
    ax[1].tickformat = format
    ax[1].coord_transform = [b,m]
    ;---
    p[1].GetData, x, y
    b = min(y)
    p[1].SetData, x, y-b
    ax = p[1].axes
    ax[3].coord_transform = [b,m]
    ax[3].tickformat = format
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

    ; GOES - create struc if haven't already
    ;    make another struc for this?
    if n_elements(data) eq 0 then data = GOES()

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

function PLOT_WITH_TIME, xdata, ydata, $
    offset=offset, $
    time=time, color=color, name=name, _EXTRA = e

    common defaults
    sz = size( ydata, /dimensions )
    if keyword_set(offset) then begin
        ; could call another subroutine here to keep plotting routine simple.
        N = sz[0]
        xdata = [0:N-1] + offset
    endif else begin
        offset = 0
    endelse

    position = MAKE_POSITION()
    ; TO-DO: if no window exists, create one using
    ; margins and graphic height to set window height.

    lc = objarr(sz[1])
    for i = 0, n_elements(lc)-1 do begin
        lc[i] = PLOT2( $
            xdata, ydata[*,i], $
            /current, $
            /device, $
            position=position*dpi, $
            overplot=i<1, $
            ;xmajor=7, $
            xminor=5, $
            xtickinterval=75, $
            ymajor=5, $
            ;yminor=4, $
            ;xshowtext=1, $
            yshowtext=1, $
            xticklen=0.025, $
            yticklen=0.010, $
            ;stairstep=1, $
            color=color[i], $
            name=name[i], $
            xtitle=xtitle, $
            _EXTRA = e )
    endfor
    ax = lc[0].axes
    ax[0].tickname = time[ax[0].tickvalues]
    ax[0].title = 'Start time (UT) on 15-Feb-2011 00:00'
    ;ax[0].xtitle = 'Start time (UT) on ' + gdata.utbase
    ax[2].title = 'Index'
    ax[2].minor = 4
    ax[2].showtext = 1

    return, lc
end
pro main_level_code

    ; IDL> .run plot_structures
    ;       Already ML, so maybe add color, name, etc. to those structures
    ;S = lightcurve_struc
    ;S = power_flux_struc
    ;S = power_maps_struc
    S = average_power_struc

    ;win = WINDOW2( dimensions=[8.5,4.0], buffer=1 )
    win = WINDOW2( wy=4.0, buffer=1 )
    ;pos = make_position(win=win)

    xrange = [0,748]

    p = PLOT_WITH_TIME( $
        S.xdata, $
        S.ydata, $
        time = strmid( A[0].time, 0, 5 ), $
        xtitle=xtitle, $
        xrange=xrange, $
        color=A.color, $
        name=A.name )

    ;; All the different ways to adjust y-values
    p = SHIFT_YDATA( p )
    ;ax[1].title = '1600$\AA$ (DN s$^{-1}$)'
    ;ax[3].title = '1700$\AA$ (DN s$^{-1}$)'

    ax = p[0].axes
    ax[1].title = '1600$\AA$ 3-minute power'
    ax[3].title = '1700$\AA$ 3-minute power'
    ;p = NORMALIZE_YDATA( p )

    ;p[0].select
    ;p[1].select, /add


    ; Overplot flare start/peak/end times
    resolve_routine, 'oplot_flare_lines', /either
    v = OPLOT_FLARE_LINES( $
            A[0].time, $
            yrange=p[0].yrange, $  ; NOTE: must be called AFTER adjusting y-values
            /send_to_back, $
            ;xshowtext=1, yshowtext=1, $
            color='light gray' )

    ; Overplot GOES lightcurves (only if ydata is normalized)
    ;   ... and only when plotting flux, not power.
    ;g = OPLOT_GOES(gdata)

    leg = MAKE_LEGEND()

    save2, S.file;, /add_timestamp
end
;----------------------------------------------------------------------------------






;; Call PLOT_WITH_TIME with one of these structures

function PLOT_STRUCTURES, $
    ydata, $
    offset=offset, $
    ytitle=ytitle, $
    file=file

    dz = 64
    N = n_elements(ydata[*,0])
    if not keyword_set(offset) then offset = 0

    struc = { $
        xdata : [0:N-1]+offset, $
        ydata : ydata, $
        ytitle : ytitle, $
        file : file }

    return, struc
end
pro main_level_code

    ;xdata = A.jd-min(A.jd)
    ;xtitle = 'Start time (UT) on 15-Feb-2011 00:00'

    ; Lightcurves
    lightcurve_struc = PLOT_STRUCTURES( $
        A.flux, $
        ytitle='DN s$^{-1}$', $
        file='lightcurve_1.pdf' )

    ; Power (flux)
    power_flux_struc = PLOT_STRUCTURES( $
        A.power_flux, $
        offset = (dz/2) - 1, $
        ytitle = '3-minute power', $
        file = 'power_flux.pdf' )

    ; Power (maps)
    power_maps_struc = PLOT_STRUCTURES( $
        A.power_maps, $
        offset = (dz/2) - 1, $
        ytitle = '3-minute power', $
        file = 'power_maps.pdf' )

    ; Average power
    dz = 64
    aia1600power = WA_AVERAGE(A[0].flux, A[0].power_maps, dz=dz)
    aia1700power = WA_AVERAGE(A[1].flux, A[1].power_maps, dz=dz)

    power_average_struc = PLOT_STRUCTURES( $
        [ [aia1600power], [aia1700power] ], $
        offset = dz-1, $
        ytitle = '3-minute power', $
        file = 'average_power_maps.pdf' )

end
;----------------------------------------------------------------------------------





;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------
