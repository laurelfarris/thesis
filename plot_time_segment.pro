

; 24 July 2018
function PLOT_TIME_SEGMENT, xdata, ydata, xdata2=xdata2, ydata2=ydata2, $
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
