;+
;- LAST MODIFIED:
;-   Tue Aug 13 12:30:32 MDT 2019
;-
;-   Mon Dec 17 06:15:25 MST 2018
;-       "P_t" --> P(t)
;-
;- ROUTINE:
;-   plot_pt.pro
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



function PLOT_PT, time, power, dz, $
    _EXTRA = e

    @parameters

    sz = size(power,/dimensions)

    xdata = [ [indgen(sz[0])], [indgen(sz[0])] ] + (dz/2)
        ;- Hacky way of creating 2D array of xdata, where both arrays are the same.
        ;- There must be a way to duplicate an array in directio of choice,
        ;-   but it's alluding me. Probably really obvious...
;    help, power
;    help, xdata
;    stop

    color = ['green', 'purple']

    ;resolve_routine, 'batch_plot', /is_function
    resolve_routine, 'batch_plot_2', /is_function

    ;plt = BATCH_PLOT( $
    plt = BATCH_PLOT_2( $
        xdata, power, $
        ;xrange=[0,748], $
        thick=[0.5, 1.0], $
            ;- NOTE: lines look thicker in pdf than xwindow
        xrange=[0,sz[0]+dz-2], $
        xtickinterval = 75, $
        title = class + '-class flare; NOAA AR ' + AR, $
        ytitle='3-minute power', $
        color=color, $
        wy = 3.0, $  ; --> still a kw for batch_plot, which is NOT the same thing as plot3.
        buffer = 1, $
        _EXTRA = e )


    ;- Add top and right axes for plt2 (excluded when axis_style=1)

    resolve_routine, 'axis2', /is_function


    ax2 = axis2( 'X', $
        location='top', $
        target=plt[0], $
        showtext=0 $
    )

    ax3 = axis2( 'Y', $
        location='right', $
        target = plt[1], $
        text_color = color[1], $
        ;title = plt[1].name + ' 3-minute power', $
        showtext=1 $
    )

;- Maps only --> power_flux doesn't need to be shifted
    ;resolve_routine, 'shift_ydata', /either
    ;SHIFT_YDATA, plt, delt=[ mean(power[*,0]), mean(power[*,1]) ]
      ;- kw "delt" used to label each axis

    resolve_routine, 'label_time', /either
    LABEL_TIME, plt, time=time;, jd=A.jd

    resolve_routine, 'oplot_flare_lines', /is_function
    vert = OPLOT_FLARE_LINES( $
        plt, $
        t_obs=time, $
        ;jd=jd, $
        ;utbase = date + ' ' + ts_start, $
           ;- 17 January 2020
           ;-   Don't need utbase unless also setting /goes ...
           ;-   Added utbase to @parameters, so doesn't really matter anymore
        send_to_back=1 )


    resolve_routine, 'legend2', /either
    leg = LEGEND2( target=plt, /upperleft, sample_width=0.2 )

    resolve_routine, 'mini_axis', /is_function
    mini = MINI_AXIS(plt);, location=1.e2)




;- Also maps only:
;    ax = plt[0].axes
;    ax[3].showtext = 1


    ;ax[1].tickvalues=[-100:500:100]
    ;ax = plt[1].axes
    ;ax[3].tickvalues=[1200:1900:100]


;;    ax[1].title = plt[0].name + ' 3-minute power'
;;    ax[3].title = plt[1].name + ' 3-minute power'

    ;- May need to keep these at bottom of code, right before saving,
    ;- if intermediate steps cause ax[3] to disappear again.



    ;- Wed Feb 20 07:53:53 MST 2019
    ;- Color axes to match data (from plot_lc.pro):
    ;- Actually had to add a line up top to define a string array
    ;-   for variable "color" because this isn't main level, and also
    ;-   because P(t) plots use different colors than A.color.
;;    ax[1].text_color = color[0]
;;    ax[3].text_color = color[1]


    
;----------------------------------------------------------------

;- 17 January 2020
;-  Add shading to match light curves
;-  (copied directly from plot_lc.pro... make a subroutine for this?)

yrange = plt[1].yrange

shaded = plot( $
    [ind[0], ind[1]], $
    [yrange[0], yrange[0]], $
    /overplot, $
    /fill_background, $
    fill_color='white smoke', $
    fill_level=yrange[1] $
)
shaded.Order, /send_to_back

;----------------------------------------------------------------

    return, plt
end
