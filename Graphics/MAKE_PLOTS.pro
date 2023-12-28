
;++
;+ 17 October 2018
;+ Combined all plotting routines into one file called 'MAKE_PLOTS.pro'.
;++





;----------------------------------------------------------------------------------
; (1)
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

; (2)
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



; (3)
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



; (4)
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
    ;   09 August 2022 => oplot_goes.pro is not used anywhere else, moved to "old/"

    leg = MAKE_LEGEND()

    save2, S.file;, /add_timestamp
end
;----------------------------------------------------------------------------------

;; Call PLOT_WITH_TIME with one of these structures

; (5)
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

; (6)
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
