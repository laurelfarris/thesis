

; Last modified:    17 November 2018
; Name of file = name of routine called by user.
; x and y titles both need to be optional somehow...
; ytitle changes depending on whether plotting values that are
; normalized, absolute, shifted, exptime-corrected, etc.


;- 02 November 2018 (from Enote on subroutines):
;- Need to be able to call LC routine for any length of time (full data set, small
;- flares before and after, etc. Label ticks outside of main subroutine? Takes
;- longer, but may be easier way to separate things, and leave less important
;- stuff for later)



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

    wx = 8.0
    wy = 2.75
    dw
    win = window( dimensions=[wx,wy]*dpi, buffer=1 )


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
    for ii = 0, nn-1 do begin

        plt[ii] = PLOT2( $
            xdata[*,ii], ydata[*,ii], $
            /current, $
            /device, $
            position=position, $
            overplot=ii<1, $
            color = color[ii], $
            name = name[ii], $
            stairstep=1, $
            thick=0.5, $
            xthick=0.5, $
            ythick=0.5, $
            xminor=5, $
            xtickinterval=75, $
            ymajor=5, $
            yshowtext=1, $
            xticklen=0.025, $
            yticklen=0.010, $
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

goto, start
START:;---------------------------------------------------------------------------------
time = strmid(A[0].time,0,5)

xdata = A.jd
ydata = A.flux

xtickinterval = A[0].jd[75] - A[0].jd[0]
plt = PLOT_LIGHTCURVES( $
    xdata, ydata, $
    font_size=16, $
    name=A.name, $
    color=A.color, $
    xtickinterval=xtickinterval )

LABEL_TIME, plt, time=time, jd=jd

SHIFT_YDATA, plt
file = 'lc'

;NORMALIZE_YDATA, plt
;file = 'lc_norm'

;resolve_routine, 'oplot_goes', /either
;g = OPLOT_GOES( plt, data )
;g = OPLOT_GOES( goes_data ) --> next time. Be more specific than 'data'.
; --> use goes_data.utbase to set xtitle.

resolve_routine, 'oplot_flare_lines', /either
v = OPLOT_FLARE_LINES( plt, A[0].time, A[0].jd, /send_to_back )

resolve_routine, 'legend2', /either
leg = LEGEND2( target=[plt,v], position=[0.95, 0.95], /relative )

save2, file

end
