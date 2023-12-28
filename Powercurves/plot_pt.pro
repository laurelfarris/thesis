;+
;- ROUTINE:
;-   plot_pt.pro

;- LAST MODIFIED:
;-   12/27/2023 -- merged with "plot_pt_2.pro" => added to bottom of file, below "plot_pt.pro"
;-
;-
;-   Tue Aug 13 12:30:32 MDT 2019
;-
;-   Mon Dec 17 06:15:25 MST 2018
;-       "P_t" --> P(t)
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
;-      be passed to IDL's PLOT function.
;-
;- OUTPUT:
;-   plt     object array with n_elements = number of curves plotted
;-
;- TO DO:
;-   [] ...
;-
;- KNOWN BUGS:
;-   Possible errors, harcoded variables, etc.


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

    resolve_routine, 'batch_plot', /is_function
    ;resolve_routine, 'batch_plot_2', /is_function

    plt = BATCH_PLOT( $
    ;plt = BATCH_PLOT_2( $
        xdata, power, $
        top=0.3, $
            ;-------
            ;- 26 June 2020
            ;-   Increased top to allow room for plot title
            ;- 13 June 2020
            ;-   By default, top=0.2 in batch_plot_2 wrapper routine (current dir.)
            ;-   but this line is commented in ../Graphics/batch_plot_2.pro ...
            ;-   In the interest of making things CONSISTENT (and, you know, not
            ;-   having multiple copies of the same damn code floating around),
            ;-   I'm adding kw def here in call to batch_plot_2 so that I can
            ;-   comment the line defining this kw in batch_plot_2, bringing it
            ;-   closer to duplicate of ../Graphics/batch_plot_2.
            ;-   (Goal here is to find all the little differences (there don't
            ;-   appear to be many), making appropriate changes in CALLER,
            ;-   and deleting the duplicate code, probably the one in the current
            ;-   directory, and keeping the one in the Graphics/ directory.
            ;-------
        ;xrange=[0,748], $
        thick=[0.5, 1.0], $
            ;- NOTE: lines look thicker in pdf than xwindow
        xrange=[0,sz[0]+dz-2], $
        xtickinterval = 75, $
        title = class + '-class flare; NOAA AR ' + AR + '; ' + date, $
        ytitle='3-minute power', $
        ;ytitle = name[0] + ' log 3min power', $
        ;text_color = A[0].color
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
        title = plt[1].name + ' 3-minute power', $
        ;title = name[1] + ' log 3min power', $
        ;text_color = A[1].color
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


ind = [(where(time eq my_start))[0],(where(time eq my_end))[0]]
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

    return, plt
end


;=====================================================================================================
;= "plot_pt_2.pro"

;+
;- LAST MODIFIED:
;-   18 August 2019
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

    ;resolve_routine, 'batch_plot_2', /is_function
    resolve_routine, 'batch_plot', /is_function

    dw

    ;plt = BATCH_PLOT_2( $
    plt = BATCH_PLOT( $
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



