

; Last modified:    18 November 2018
; Name of file = name of routine called by user.
; x and y titles both need to be optional somehow...
; ytitle changes depending on whether plotting values that are
; normalized, absolute, shifted, exptime-corrected, etc.


;- 02 November 2018 (from Enote on subroutines):
;- Need to be able to call LC routine for any length of time (full data set, small
;- flares before and after, etc. Label ticks outside of main subroutine? Takes
;- longer, but may be easier way to separate things, and leave less important
;- stuff for later)


;- xdata = m x n array
;-   m: array of JDs for each LC
;-   n: # LCs
;- ydata = m x n array
;-   m: array of data points for each LC
;-   n: # LCs



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
    win = window( dimensions = [wx,wy]*dpi, buffer=0 )


    ; For single panel, pick margins, and use window dimensions to set width/height (the other unknown)
    ;-  NOTE: left/right margins change depending on whether normalizing or not
    ;-    (don't need extra room for ax[3]). FIX THIS TO BE MORE GENERAL!
    ;-  On second thought, plots look better when they're aligned,
    ;-     with the same width.
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
dw

time = strmid(A[0].time,0,5)

xdata = A.jd
ydata = A.flux

ylog = 0

;- subtract mean from input data, skip separate routine that does this after plotting.
;ydata[*,0] = ydata[*,0] - min(ydata[*,0])
;ydata[*,1] = ydata[*,1] - min(ydata[*,1])

;- GOES data
;xdata = gdata.tarray
;ydata = gdata.ydata


;- Plot AIA light curves
plt = PLOT_LIGHTCURVES( $
    xdata, ydata, $
    xtickinterval = A[0].jd[75] - A[0].jd[0], $
    ylog = ylog, $
    color = A.color, $
    name = A.name )

LABEL_TIME, plt, time=time, jd=jd


;-----
;- Shift curves in y by subtracting the mean.
resolve_routine, 'shift_ydata', /either
file = 'lc'
SHIFT_YDATA, plt

;- Normalize data between 0 and 1.
;resolve_routine, 'normalize_ydata', /either
;file = 'lc_norm'
;NORMALIZE_YDATA, plt
;-   write this so it pulls ALL data from plt... which it might already be
;-        doing, but GOES is its own variable, not part of plt.

;- Overlay GOES flux on AIA light curves.
;resolve_routine, 'oplot_goes', /either
;OPLOT_GOES, plt, gdata, ylog=ylog

;-----

;- Overlay vertical lines marking start, peak, and end times.
resolve_routine, 'oplot_flare_lines', /either
OPLOT_FLARE_LINES, plt, A[0].time, A[0].jd, /send_to_back


;plt[0].delete
;plt[1].delete
;- plt still has 3 elements though... ?? Maybe just removes from graphic,
;- but object itself still exists.

;plt[2].yrange = [ min(gdata.ydata)/10.0, max(gdata.ydata)*1.1 ]
;plt[2].ytitle = 'GOES flux (W m$^{-2}$)'



;- Legend
;- --> Put somewhere else to easily delete and re-create legend
;-       without re-creating entire graphic every time.

target=[plt]

resolve_routine, 'legend2', /either
;leg.delete
leg = LEGEND2( target=target, position=[0.92,0.95], sample_width=0.50 )


;save2, file

end
