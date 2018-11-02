

; Last modified:        02 November 2018
; Name of file = name of routine called by user.
; x and y titles both need to be optional somehow...
; ytitle changes depending on whether plotting values that are
; normalized, absolute, shifted, exptime-corrected, etc.

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

function MAKE_LEGEND, $
    ;win=win, $
    _EXTRA=e

    common defaults

    win = GetWindows(/current)
    win.Select, /all
    target = win.GetSelect()
    ;pos = (target[0].position)/dpi

    ; not actually using target here...
    ;pos = MAKE_POSITION()
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
    ;ax[1].style = 2
    ;ax[1].major = 6
    ;ax[1].tickinterval = 0.2
    ax[1].tickvalues = [0.0, 0.5, 1.0]
    ;ax[1].tickformat = '(F0.1)'
    ;ax[1].tickname = strtrim(ax[1].tickvalues,1)
    ax[1].title = 'Intensity (normalized)'
    ax[3].showtext = 0
    return, p
end

function PLOT_LIGHTCURVES, $
    xdata, ydata, $
    norm=norm, $
    color=color, $
    name=name, $
    _EXTRA = e

    common defaults

    wx = 8.0
    wy = 3.0
    dw
    win = window( dimensions=[wx,wy]*dpi, /buffer )

    ; For single panel, pick margins, and use window dimensions to set width/height (the other unknown)
    left = 1.00
    right = 1.00
    bottom = 0.5
    top = 0.2

    x1 = left
    y1 = bottom
    x2 = wx - right
    y2 = wy - top
    position = [x1,y1,x2,y2]*dpi

    sz = size(ydata, /dimensions)
    nn = sz[1]

    ;- Get shift (aa) and slope (bb) to use for coord_transform
    aa = [ mean(ydata[*,0]), mean(ydata[*,1]) ]
    bb = [ 1.0, 1.0 ];- slope

    plt = objarr(nn)
    for ii = 0, nn-1 do begin

        x = xdata[*,ii]
        y = ( ydata[*,ii] - aa[ii] ) / bb[ii]

        plt[ii] = PLOT2( $
            x, y, $
            /current, $
            /device, $
            position=position, $
            overplot=ii<1, $
            color = color[ii], $
            name = name[ii], $
            stairstep=1, $
            xminor=5, $
            xtickinterval=75, $
            ymajor=5, $
            yshowtext=1, $
            xticklen=0.025, $
            yticklen=0.010, $
            _EXTRA = e )
    endfor

    diff = (plt[0].xtickvalues)[0] - (x[0])
    plt[0].xtickvalues =  plt[0].xtickvalues - diff

    CALDAT, plt[0].xtickvalues, $
      month, day, year, hour, minute, second

    hour = strtrim(hour,1)
    minute = strtrim(minute,1)
    for jj = 0, n_elements(hour)-1 do begin
        if strlen(hour[jj]) eq 1 then hour[jj] = '0' + hour[jj]
        if strlen(minute[jj]) eq 1 then minute[jj] = '0' + minute[jj]
    endfor

    ax = plt[0].axes

    ax[0].tickname = hour + ':' + minute
    ;print, ax[0].tickname

    ax[0].title = 'Start time (UT) on 15-Feb-2011 00:00'
;    ax[0].xtitle = 'Start time (UT) on ' + gdata.utbase

;    ax[2].title = 'Index'
;    ax[2].minor = 4
;    ax[2].showtext = 1
;
    ax[1].coord_transform = [aa[0],bb[0]]
    ax[3].coord_transform = [aa[1],bb[1]]

    ytitle = name + ' (DN s$^{-1}$)'
    ax[1].title = ytitle[0]
    ax[3].title = ytitle[1]
    ax[3].showtext = 1
    return, plt

end

; Single lines creating each object that can easily be commented.
; Then just erase and re-draw.

goto, start
START:;---------------------------------------------------------------------------------
A[0].color = 'blue'
A[1].color = 'red'
time = strmid(A[0].time,0,5)

xdata = A.jd
ydata = A.flux



xtickinterval = A[0].jd[75] - A[0].jd[0]
plt = PLOT_LIGHTCURVES( xdata, ydata, name=A.name, color=A.color, xtickinterval=xtickinterval)
plt_norm = normalize_ydata(plt)
print, plt_norm[0].ytickname
stop

t_goes = ['01:44', '01:56', '02:06']
ind = []
foreach tt, t_goes do ind = [ ind, (where(time eq tt))[0] ]
;Result = JULDAY( Month, Day, Year, Hour, Minute, Second)
name = t_goes + ' ' + ['start', 'peak', 'end']
v = oplot_lines( $
    A[0].jd[ind], plt[0].yrange, $
    color='gray', /send_to_back, $
    name = name)

leg = legend2( target=[plt,v], position=[0.95, 0.95], /relative)

file = 'lc'
save2, file

end
