;+
;- LAST MODIFIED:
;-   18 August 2019
;-
;- ROUTINE:
;-   plot_pt_2.pro
;-
;- EXTERNAL SUBROUTINES (lots of graphics!):
;-   shift_ydata.pro
;-   label_time.pro
;-   oplot_flare_lines.pro
;-   legend2.pro
;-   mini_axis.pro
;-
;- PURPOSE:
;-   Plot Power as function of time
;-
;- USEAGE:
;-   plt = PLOT_PT( power, dz, time, _EXTRA=e )
;-
;- INPUT:
;-   power = NxM array where "N" is number of power points, and M is number of curves to overlay
;-   dz = number of images
;-   time = array of obs time, used to label x-axis
;-      (string array of the form hh:mm:ss.dd, same dims as power)
;-
;- KEYWORDS (optional):
;-   "_EXTRA" -- structure form, passed to plotting routine, can set anything that can
;-    be passed to IDL's PLOT function.
;-
;- OUTPUT:
;-   plt     object array with n_elements = number of curves plotted
;-
;- TO DO:
;-   [] ...
;-
;- KNOWN BUGS:
;-   Possible errors, harcoded variables, etc.
;-
;- AUTHOR:
;-   Laurel Farris
;-
;-



function PLOT_PT_2, power, dz, time, $
    _EXTRA = e


    sz = size(power,/dimensions)

    xdata = [ [indgen(sz[0])], [indgen(sz[0])] ] + (dz/2)
    ;- See Dropbox/Other/matrix.pro

    color = ['green', 'purple']

    ;-
    ;- Advantage of using /overplot vs new axes:
    ;-   • New axes only works for 2 curves -- for more channels, would have
    ;-       to come up with a new way scale values or normalize.
    ;-
    ;- Idea for handling both within a single subroutine:
    ;-    In batch_plot, if kw "overplot" is set, use like normal, but if NOT
    ;-    set, overlay curves using separate axes
    ;-
    ;- --> maybe there's a way to "detach" an overlaid plot?
    ;-  Call original batch_plot, then detach plt[1] and assign a different
    ;-   array of values for the axis...
    ;-

    resolve_routine, 'batch_plot_2', /is_function

    dw

    plt = BATCH_PLOT_2( $
        xdata, power, $
        ;xrange=[0,748], $
        xrange=[0,sz[0]+dz-2], $
        xtickinterval = 75, $
        stairstep = 1, $
        ytitle='3-minute power', $
        color=color, $
        wy = 3.0, $  ; --> still a kw for batch_plot, which is NOT the same thing as plot3.
        buffer = 1, $
        _EXTRA = e )

    ;- Add top and right axes for plt2 (excluded when axis_style=1)
    resolve_routine, 'axis2', /is_function


    ;- Top (x) axis: target should't matter since all plots use the same X-axis.
    ax2 = axis2( 'X', location='top', target=plt[0] )

    ;- Right (y) axis: target is SECOND plot
    ;-   (first one already has y-axis on left side, from orig creation of graphic)
    ax3 = axis2( 'Y', location='right', target=plt[1] )


    ax = plt.axes
    ;- only have ax[0] and ax[1] for axis_style=1 ?
    ;- Once ax2 and ax3 are attached to plt, will ax have all 4 axes again?

    ax[1].title = plt[0].name + " 3-minute power"
    ax[1].text_color = plt[0].color

    ax[3].title = plt[1].name + ' 3-minute power'
    ax[3].text_color = plt[1].color
    ax[3].showtext=1 ; is this already 1 by default?


;    resolve_routine, 'label_time', /either ;- procedure, as of 13 August 2019
    LABEL_TIME, plt, time=time;, jd=A.jd

    resolve_routine, 'oplot_flare_lines', /is_function
    vert = OPLOT_FLARE_LINES( $
        plt, $
        t_obs=time, $
        ;jd=jd, $
        color = 'dark gray', $
        send_to_back=1 )


    resolve_routine, 'legend2', /either
    leg = LEGEND2( target=plt, /upperleft, sample_width=0.2 )

    resolve_routine, 'mini_axis', /is_function
    mini = MINI_AXIS(plt);, location=1.e2)


    return, plt
end
