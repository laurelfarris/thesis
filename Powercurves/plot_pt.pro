;-
;- LAST MODIFIED:
;-   Mon Dec 17 06:15:25 MST 2018
;-
;- "P_t" --> P(t)
;-
;- PURPOSE:
;-
;- INPUT:
;-
;- KEYWORDS:
;-
;- OUTPUT:
;-
;- TO DO:
;-




function PLOT_PT, power, dz, time, $
    _EXTRA = e


    sz = size(power,/dimensions)

    xdata = [ [indgen(sz[0])], [indgen(sz[0])] ] + (dz/2)
        ;- Hacky way of creating 2D array of xdata, where both arrays are the same.

    color = ['green', 'purple']

    resolve_routine, 'batch_plot', /either
    dw
    plt = BATCH_PLOT( $
        xdata, power, $
        ;xrange=[0,748], $
        xrange=[0,sz[0]+dz-2], $
        xtickinterval = 75, $
        ytitle='3-minute power', $
        color=color, $
        wy = 3.0, $  ; --> still a kw for batch_plot, which is NOT the same thing as plot3.
        buffer = 1, $
        _EXTRA = e )

;- Maps only --> power_flux doesn't need to be shifted
    resolve_routine, 'shift_ydata', /either
    SHIFT_YDATA, plt, delt=[ mean(power[*,0]), mean(power[*,1]) ]
      ;- kw "delt" used to label each axis


    resolve_routine, 'label_time', /either
    LABEL_TIME, plt, time=time;, jd=A.jd

    ;resolve_routine, 'oplot_flare_lines', /either
    ;OPLOT_FLARE_LINES, plt, t_obs=time, $;, jd=A.jd
    vert = OPLOT_FLARE_LINES( plt, t_obs=time, $;, jd=A.jd
        color = 'dark gray' )

    resolve_routine, 'legend2', /either
    leg = LEGEND2( target=plt, /upperleft, sample_width=0.2 )

    resolve_routine, 'mini_axis', /either
    mini = mini_axis(plt);, location=1.e2)


;- Also maps only:
    ax = plt[0].axes
    ax[3].showtext = 1


    ;ax[1].tickvalues=[-100:500:100]
    ;ax = plt[1].axes
    ;ax[3].tickvalues=[1200:1900:100]


    ax[1].title = plt[0].name + ' 3-minute power'
    ax[3].title = plt[1].name + ' 3-minute power'

    ;- May need to keep these at bottom of code, right before saving,
    ;- if intermediate steps cause ax[3] to disappear again.



    ;- Wed Feb 20 07:53:53 MST 2019
    ;- Color axes to match data (from plot_lc.pro):
    ;- Actually had to add a line up top to define a string array
    ;-   for variable "color" because this isn't main level, and also
    ;-   because P(t) plots use different colors than A.color.
    ax[1].text_color = color[0]
    ax[3].text_color = color[1]

    return, plt
end
