

; 24 July 2018
function PLOT_TIME_SEGMENT, xdata, ydata, x2=x2, y2=y2, $
    color=color, name=name, $
    _EXTRA=e

    wx = 4.5
    wy = 11.0
    win = GetWindows(/current)
    if n_elements(win) eq 0 then $
        win = window( dimensions=[wx,wy]*dpi, location=[300,0], buffer=1 )

    cols = 1
    rows = 4

    left = 1.0
    bottom = 0.5
    right = 1.0
    top = 0.5
    margin=[left, bottom, right, top]*dpi

    yz = size(ydata, /dimensions)
    p = objarr(yz[1])

    for i = 0, n_elements(p)-1 do begin
        x = xdata
        y = ydata[*,i]
        aa = min(y)
        bb = 1.0
        y = ( y - aa ) / bb

        p[i] = plot2(  $
            x, y, $
            /current, $
            /device, $
            layout=[cols,rows,1], $
            overplot=i<1, $
            margin=margin, $
            xtickinterval=75, $
            ;xminor=5, $
            ymajor=7, $
            xticklen=0.025, $
            yticklen=0.010, $
            xtitle='index', $
            stairstep=1, $
            color = color[i], $
            name = name[i] )
    endfor

    ax = p[0].axes

    ax[1].coord_transform = [aa,bb]
    ax[1].title='AIA 1600$\AA$ (DN s$^{-1}$)'

    ax[3].coord_transform = [aa,bb]
    ax[3].title='AIA 1700$\AA$ (DN s$^{-1}$)'
    ax[3].showtext = 1

    if keyword_set(x2) then begin
        ax[2].tickname = strmid(x2[ax[0].tickvalues],1)
        ax[2].title = 'Start time (UT) on 2011-February-15'
        ax[2].showtext = 1
    endif
    return, p
end
goto, start
START:;---------------------------------------------------------------------------------

ind = [58:121]
time = ( strmid(A[0].time,0,5) )[ind]

p = PLOT_TIME_SEGMENT( ind, flux, x2=time )

leg = legend2( target=[p], position=[0.83,0.78], /normal )

save2, 'lightcurve_cflare.pdf', /add_timestamp

end
