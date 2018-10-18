

;-
;- 18 October 2018
;- Combined all plotting routines into one file.
;-


;----------------------------------------------------------------------------------
pro PLOT_GOES_SUBROUTINE, A, gdata

    common defaults
    dw
    wx = 8.5
    wy = 4.0
    win = window( dimensions=[wx,wy]*dpi, buffer=1 )

    left = 0.75
    bottom = 0.5
    right = 0.5
    top = 0.5
    margin = [left,bottom,right,top]

    width = wx - (left + right)
    height = wy - (top + bottom)
    xticklen = width / 200.
    yticklen = height / 200.


    p = objarr(3)

    for i = 0, 1 do begin
        flux = A[i].flux - min(A[i].flux)
        flux = flux / max(flux)
        xdata = findgen(n_elements(flux)) * A[i].cadence

        p[i] = plot2( $
            xdata, flux, $
            /current, $
            /device, $
            overplot=i<1, $
            layout=[1,1,1], $
            margin=margin*dpi, $
            xmajor=10, $
            xticklen=xticklen, $
            yticklen=yticklen, $
            xtitle='Start Time ' + gdata.utbase, $
            ytitle='intensity (normalized)', $
            color=A[i].color, $
            name=A[i].name )
    endfor

    goesflux = gdata.ydata[*,0] - min(gdata.ydata[*,0])
    goesflux = goesflux / max(goesflux)


    p[2] = plot2( $
        gdata.tarray, $
        goesflux, $
        /overplot, $
        linestyle='--', $
        name = 'GOES 1-8$\AA$')

    xtickvalues = round(p[0].xtickvalues/24)
    xtickname = strmid( A[0].time, 0, 5 )
    p[0].xtickname = xtickname[ xtickvalues ]

    pos = p[2].position * [wx,wy,wx,wy]
    xx = pos[2] - 0.25
    yy = pos[3] - 0.25

    leg = legend2( $
        target=[p], $
        /device, $
        position=[xx,yy]*dpi )

    save2, 'test.pdf'

    stop

end
pro plot_goes

    ;!P.Color = '000000'x
    ;!P.Background = 'ffffff'x

    ;gdata = GOES()

    PLOT_GOES_SUBROUTINE, A, gdata
end
;----------------------------------------------------------------------------------


;
; input:    frequency, power
;              (fourier2.pro needs to be run before this)
; keywords: fmin, fmax - range of frequencies to show on x-axis


; if overplotting multiple data sets in the same set of axes,
; don't plot vertical lines until after, otherwise don't get full yrange,
; and dashed lines can plot on top of each other and looks like
; a solid line.

function PLOT_POWER_SPECTRUM_subroutine, $
    frequency, power, $
    fmin=fmin, fmax=fmax, $
    label_period=label_period, $
    ;fcenter=fcenter, $
    ;bandwidth=bandwidth, $
    ;norm=norm, $
    ;time=time, $
    syntax_help=syntax_help, $
    _EXTRA=e

    if keyword_set(syntax_help) then begin
        print, ""
        print, "Calling sequence:"
        print, "    result = PLOT_POWER_SPECTRUM( $"
        print, "        frequency, power, fmin=fmin, fmax=fmax, fcenter=fcenter, $"
        print, "        label_period=label_period, $"
        print, "        bandwidth=bandwidth, norm=norm, time=time )"
        return, 0
    endif

    common defaults

    left = 1.0
    right = 1.0
    bottom = 0.5
    top = 0.5

    wx = 8.5
    wy = 11.0

    width = wx - (left+right)
    height = wy - (top+bottom)

    win = window( dimensions=[wx,wy]*dpi, buffer=1 )

    if not keyword_set(fmin) then fmin = min(frequency)
    if not keyword_set(fmax) then fmax = max(frequency)
    ind = where( frequency ge fmin AND frequency le fmax )
    frequency = frequency[ind]
    power = power[ind]

    for jj = 0, n_tags(struc)-1 do begin

        position = GET_POSITION( layout=[1,2,jj+1] )
        print, position

        frequency = struc.(jj).frequency
        sz = (size(frequency,/dimensions))
        p = objarr(sz[1])

        for ii = 0, n_elements(p)-1 do begin

            ;t = strtrim(time[*,i])
            p = PLOT2( $
                frequency[*,ii], $
                power[*,ii], $
                /current, $
                /device, $
                overplot = ii<1, $
                position = position*dpi, $
                ;xmajor = 7, $
                name = struc.(jj).names[ii], $
                xtitle = 'frequency (Hz)', $
                ytitle = 'power', $
                _EXTRA=e )
        endfor

        if (p.ylog eq 1) then p.ytitle = 'log power'

        ;- Extra stuff to add to individual panel:

        ax = p.axes

        if keyword_set(label_period) then begin
            ax[2].showtext = 1
            ax[2].title = 'period (seconds)'

            ;- Kind of going in circles, but want to label ticks using actual values,
            ;- not manually setting equal to period array, which could lead to errors,
            ;-  e.g. frequency and period both increasing in the same direction...
            ax[2].tickvalues = 1./[120, 180, 200]
            ax[2].tickname = strtrim( round(1./(ax[2].tickvalues)), 1 )
        endif

        ;- convert frequency units: Hz --> mHz AFTER labeling period.
        ;- SYNTAX: axis = a + b*data
        ax[0].coord_transform=[0,1000.]
        ax[0].title='frequency (mHz)'
        ax[0].tickformat='(F0.2)'

    endfor

    leg = LEGEND2( $
        target = p[0], $
        /data, $
        position = 0.95*[ (p.xrange)[1], (p.yrange)[1] ] )

    ;fmin = 1./400 ; 2.5 mHz
    ;fmax = 1./50 ;  20 mHz
    ;f = [ 1000./180, 1000./(2.*180) ]
end
pro plot_power_spectrum

    ; 24 September 2018

    fmin = 0.0025
    fmax = 0.02

    ;- dz = (30 min * 60 sec/min) / cadence
    ;dz = (30. * 60.) / 24.
    times = ['12:30', '01:30', '02:30', '03:30']
    titles = ['Before', 'During', 'After']

    wx = 8.5
    wy = 3.0
    win = window( dimensions=[wx,wy]*dpi, buffer=0 )

    cols = 3
    rows = 1

    for ii = 0, n_elements(times)-2 do begin

        p = objarr(3)
        for cc = 0, n_elements(p)-1 do begin

            t1 = where( A[cc].time eq times[ii] )
            t2 = where( A[cc].time eq times[ii+1] ) - 1

            n_pixels = 330.*500.
            flux = A[cc].flux[t1:t2]
            flux = (A[cc].flux[t1:t2])/n_pixels

            result = fourier2( flux, A[cc].cadence, norm=0 )
            frequency = reform( result[0,*] )

            power = reform( result[1,*] )
            power = (reform( result[1,*] )) / n_pixels
            print, min(power)
            print, max(power)

            p[cc] = PLOT_POWER_SPECTRUM_subroutine( $
                frequency, power, $
                fmin=fmin, fmax=fmax, $
                overplot = cc<1, $
                layout = [cols, rows, ii+1], $
                color=A[cc].color, $
                name=A[cc].name )
        endfor
    endfor
    ;- Call BDA_structures.pro first, then input structure into plotting routine.
end
;----------------------------------------------------------------------------------


; 24 July 2018
function PLOT_TIME_SEGMENT_subroutine, $
    xdata, ydata, xdata2=xdata2, ydata2=ydata2, $
    layout=layout, $
    color=color, name=name, $
    lc=lc, power=power, $
    _EXTRA=e

    common defaults

    cols = layout[0]
    rows = layout[1]
    j = layout[2]

    left  = 1.0
    right = left
    bottom = 0.75
    top = bottom
    margin=[left, bottom, right, top]*dpi

    width = 2.5
    height = width*(330./500.)

    wx = 4.5
    wy = 5.0
    win = GetWindows(/current)
    if win eq !NULL then begin
        win = window( dimensions=[wx,wy]*dpi, buffer=1 )
    endif

    ygap=0.0

    x1 = left
    y2 = wy - top - j*(height+ygap)
    y1 = y2 - height
    x2 = x1 + width

    ;y1 = wy - top - height
    ;y2 = y1 + height

    position=[x1,y1,x2,y2]*dpi

    yz = size(ydata, /dimensions)
    p = objarr(yz[1])

    aa = [ min(ydata[*,0]), min(ydata[*,1]) ]
    bb = [ 1.0, 1.0 ]
    x = xdata

    for i = 0, n_elements(p)-1 do begin

        y = ( ydata[*,i] - aa[i] ) / bb[i]

        p[i] = plot2(  $
            x, y, $
            /current, $
            /device, $
            position=position, $
            overplot=i<1, $
            margin=margin, $
            xshowtext=1, $
            xtickinterval=15, $
            xticklen=0.025, $
            yticklen=0.010, $
            xtitle='index', $
            stairstep=1, $
            color = color[i], $
            name = name[i] )
    endfor

    ax = p[0].axes
    ax[1].coord_transform = [aa[0],bb[0]]

    ax = p[1].axes
    ax[3].coord_transform = [aa[1],bb[1]]
    ax[3].showtext = 1

    if keyword_set(xdata2) then begin
        ax[0].tickname = strtrim( xdata2[fix(ax[0].tickvalues)], 1 )
        ax[0].title = 'Start time (UT) on 2011-February-15'
        ;ax[2].showtext = 1
    endif
    return, p
end
pro plot_TIME_SEGMENT

    dz = 64
    cols = 1
    rows = 4
    time = strmid(A[0].time,0,5)
    time2 = strmid(A[0].time,0,8)

    ind = [58:121]
    flux = A.flux[ind,*]

    p = PLOT_TIME_SEGMENT( $
        ind, flux, xdata2=time, layout=[cols,rows,0], color=A.color, name=A.name)
    leg = legend2( target=[p], $
        position=[0.05,0.95], $
        /relative, $
        horizontal_alignment=0.0, transparency=75 )
    (p[0])['axis0'].showtext = 0
    (p[0])['axis1'].title = '1600$\AA$ (DN s$^{-1}$)'
    (p[0])['axis3'].title = '1700$\AA$ (DN s$^{-1}$)'

    power = ( shift(A.power_maps, dz/2) )[ind,*]

    p2 = PLOT_TIME_SEGMENT( $
        ind, power, xdata2=time, layout=[cols,rows,1], $
        color=A.color, name=A.name)
    (p2[0])['axis2'].showtext = 0
    (p2[0])['axis1'].title = '1600$\AA$ 3-min power'
    (p2[0])['axis3'].title = '1700$\AA$ 3-min power'

    save2, 'lightcurve_cflare.pdf', /add_timestamp
    stop

    ; image powermap

    for i = 0, 1 do begin
        dat = AIA_INTSCALE( $
            A[i].map[*,*,ind[0]], $
            wave=fix(A[i].channel), $
            exptime=A[i].exptime )
        im = image2( $
            dat, A[i].X, A[i].Y, $
            /current, $
            /device, $
            layout=[cols,rows,3+i], $
            ;margin=1.00*dpi, $
            rgb_table=A[i].ct, $
            xtitle = 'X (arcseconds)', $
            ytitle = 'Y (arcseconds)', $
            title=A[i].name + ' ' $
                + strtrim(time2[ind[ 0]],1) + '-' $
                + strtrim(time2[ind[-1]],1) )
        pos = im.position
        xoff = 0.0
        yoff = 0.05
        im.position = im.position + [xoff,yoff,xoff,yoff]
    endfor

end
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
