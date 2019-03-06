

; Last modified:    21 November 2018

function PLOT_LIGHTCURVES, $
    xdata, ydata, $
    norm=norm, $
    color=color, $
    name=name, $
    _EXTRA = e
    ;- 16 November 2018
    ;- Need to assign defaults to color and name.
    ;- They're required input as currently written.

    common defaults

    win_scale = 1
    wx = win_scale*8.0
    wy = win_scale*2.75
    win = window( dimensions = [wx,wy]*dpi, buffer=1 )


    ; For single panel, pick margins, and use window dimensions to set width/height (the other unknown)
    ;-  NOTE: left/right margins change depending on whether normalizing or not
    ;-    (don't need extra room for ax[3]). FIX THIS TO BE MORE GENERAL!
    ;-  On second thought, plots look better when they're aligned,
    ;-     with the same width.
    left = 1.00
    right = 1.10
    bottom = 0.5
    top = 0.2

    x1 = left
    y1 = bottom
    x2 = wx - right
    y2 = wy - top
    position = [x1,y1,x2,y2]*dpi

    sz = size(ydata, /dimensions)
    nn = sz[1]

    plt = objarr(nn)
    ;plt = objarr(3)
    for ii = 0, nn-1 do begin

        plt[ii] = PLOT2( $
            xdata[*,ii], ydata[*,ii], $
            /current, $
            /device, $
            position=position, $
            overplot=ii<1, $
            yshowtext=1, $
            stairstep=1, $
            xminor=5, $
            ymajor=5, $
            xtickinterval=75, $
            xticklen=0.025, $
            yticklen=0.010, $
            ;ytickformat='(E0.2)', $
            color = color[ii], $
            name = name[ii], $
            _EXTRA = e )
    endfor

    ax = plt[0].axes

;    ax[2].title = 'Index'
;    ax[2].minor = 4
;    ax[2].showtext = 1

    ytitle = name + ' (DN s$^{-1}$)'
    ax[1].title = ytitle[0]
    ax[3].title = ytitle[1]
    ax[3].showtext = 1
    return, plt

end

; Single lines creating each object that can easily be commented.
; Then just erase and re-draw.

;- --> Put ML stuff into a subroutine that calls all the other subroutines?

goto, start
START:;---------------------------------------------------------------------------------

time = strmid(A[0].time,0,5)

before = { $
    phase : "before", $
    xtickinterval : 15, $
    ind : [0:259] }

during = { $
    phase : "during", $
    xtickinterval : 5, $
    ind : [260:344] }

after1 = { $
    phase : "after1", $
    xtickinterval : 15, $
    ind : [314:519] }

after2 = { $
    phase : "after2", $
    xtickinterval : 15, $
    ind : [520:748] }


struc = { before:before, during:during, after1:after1, after2:after2 }


for ss = 0, 0 do begin
    dw

    xdata = A.jd[struc.(ss).ind]
    ;ydata = A.flux[struc.(ss).ind]
    ydata = A.data[382,193,0:259]


    ;- Plot AIA light curves
    plt = PLOT_LIGHTCURVES( $
        xdata, ydata, $
        xtickinterval = struc.(ss).xtickinterval/(60.*24.), $
        xminor = struc.(ss).xtickinterval - 1, $
        color = A.color, $
        name = A.name )

    LABEL_TIME, plt, time=time, jd=jd


    ;- Shift curves in y by subtracting the mean.
    resolve_routine, 'shift_ydata', /either
    ;file = 'lc'
    ;file = 'lc_' + struc.(ss).phase
    file = 'lc_bp'
    SHIFT_YDATA, plt

    target=[plt]

    resolve_routine, 'legend2', /either
    ;leg.delete
    leg = LEGEND2( target=target, position=[0.92,0.95], sample_width=0.40 )


    dz = 64


    x1 = A[0].jd[75]
    x2 = A[0].jd[75+dz-1]
    y1 = (plt[0].yrange)[0] * 1.1
    y2 = (plt[0].yrange)[1] * 0.9

    ;plt[0].yrange = y2 * 1.1

    ;ax1 = axis( 'x', location = y2, axis_range=[x1, x2], showtext=0, major=2, $
    ;    tickdir=1)

stop
    save2, file
endfor

end
