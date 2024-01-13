;+
;- LAST MODIFIED:
;-   03 August 2019
;-
;- PURPOSE:
;-   General for plotting light curves (any event).
;-   "Early attempts to write subroutine that is COMPLETELY generalized
;-
;- INPUT:
;-   flux = 2D NxM array
;-      N = # observations (n_obs); =~750 for 5-hour time series
;-      M = # curves to plot on same axes; =2 for AIA 1600 and 1700
;-   time = 1D (string) array of length N
;-
;- KEYWORDS:
;-   xtickinterval = time between major tick marks on x-axis (min)
;-   e.g. = 75 for 30 minutes
;-
;- OUTPUT:
;-
;- TO DO:
;-   [] "batch_plot" and "plot3" names should be more similar
;-      "batch_plot" could be "oplot2"...
;-   [] Add "date" tag to @parameters or A.
;-


pro PLOT_LC, flux, time, xtickinterval=xtickinterval, _EXTRA=e
    ;-
    ;- GENERAL plotting routine for light curves; call to plot
    ;-   flux as function of time, for ANY event, subset, or length of time.
    ;-

    @parameters

    sz = size(flux, /dimensions)
    n_obs = sz[0]
    xdata = [ [indgen(n_obs)], [indgen(n_obs)] ]

    resolve_routine, 'batch_plot', /either
    plt = BATCH_PLOT(  $
        xdata, flux, $
        ystyle=1, $
        thick=[0.5, 0.8], $
        xrange=[0,n_obs-1], $
        ;xtickinterval = A[0].jd[75] - A[0].jd[0], $
        xtickinterval = 75, $
        ;ytickinterval = 0.2, $
        xtickinterval=xtickinterval, $
        ;ytickinterval=ytickinterval, $
        ;ymajor = 2, $
        ;ylog = 1, $
        buffer=0, $
        _EXTRA=e )
    ;- If, e.g. buffer=1 was passed to PLOT_LC, what would be passed to
    ;-  BATCH_PLOT?  0 or 1 ?


    ;- NOTE: batch_plot.pro returns OBJARR to var "plt"
    ax = plt[0].axes

    ;- X-axis (time)
    ax[0].tickname = time[ ax[0].tickvalues ]
    ax[0].title = 'Start time (' + date + ' ' + tstart + ')'

    ;increment = (max(ydata1)-min(ydata1))/ymajor
    ;ax[1].tickname = string( [ min(A[0].flux) : max(A[0].flux) : increment ] )
    ;ax[3].tickname = string( [ min(A[1].flux) : max(A[1].flux) : increment ] )
    ;ax[1].tickname = [ '2.78$\times10^{7}$' , '2.94$\times10^{7}$' ]
    ;ax[3].tickname = [ '4.96$\times10^{8}$' , '9.08$\times10^{8}$' ]
    ax[3].showtext = 1

    ;dy = ytickinterval * (max(A[0].flux)-min(A[0].flux))
    ;ax[1].tickname = string( [ min(A[0].flux) : max(A[0].flux) : dy ] )
    ;ax[1].tickname = strarr( plot[0].ymajor )

    ;resolve_routine, 'label_time', /either
    ;LABEL_TIME, plt, time=A.time;, jd=A.jd

    ;resolve_routine, 'shift_ydata', /either
    ;SHIFT_YDATA, plt


end


;- ML:  harcoded values (specific to event, instrument, ROIs, etc.)

;jd = A.jd
;time = strmid( A[0].time, 0, 5 )
time = strmid( A.time, 0, 5 )

color=A.color
name=A.name
ytitle=A.name + ' (DN s$^{-1}$)'

dw
PLOT_LC, flux, time

    resolve_routine, 'oplot_flare_lines', /either
    OPLOT_FLARE_LINES, plt, t_obs=A[0].time, thick=1.0;, jd=A.jd
    ;-   17 April 2019
    ;-    oplot_flare_lines.pro does not appear to be using jd...
    ;-     unless plot_lc.pro is also outdated, I'm not sure what's going on here.

    resolve_routine, 'legend2', /either
    leg = LEGEND2( target=plt, /upperleft, sample_width=0.25 )

    ax = plt[0].axes
    ax[1].title = ytitle[0]
    ;ax[1].tickvalues = [2:8:2]*10.^7 ; -- hardcoded, 2011 flare
    ;ax[1].tickname = scinot( ax[1].tickvalues )
    ax[1].minor = 3

    ax = plt[1].axes
    ax[3].title = ytitle[1]
    ;ax[3].tickvalues = [2.2:2.8:0.2]*10.^8 ; -- hardcoded, 2011 flare
    ;ax[3].tickname = scinot( ax[3].tickvalues )
    ax[3].minor = 3

    ;- 14 December 2018
    ;- Color axes to match data (assuming yshift has been applied)
    ax[1].text_color = A[0].color
    ;ax[3].color = A[1].color
    ax[3].text_color = A[1].color
    ;print, 'How do colored axes look??'
    ;print, 'ax[1] set color, ax[3] set text_color'
    ; 17 February 2019 - going with text_color

    ; Single lines creating each object that can easily be commented.
    ; Then just erase and re-draw.

    ;- --> Put ML stuff into a subroutine that calls all the other subroutines?

    ;- 02 December 2018
    ;- Mark BDA times on LC.

    time = strmid(A[0].time,0,5)
    ;bda_times = ['01:00', '01:45', '02:30', '03:15']
    bda_times = ['01:44', '02:30']
    nn = n_elements(bda_times)
    ind = intarr(nn)
    for ii = 0, nn-1 do $
        ind[ii] = (where( time eq bda_times[ii] ))[0]


    yrange=plt[0].yrange
    shaded = plot( [ind[0], ind[1]], [yrange[0], yrange[0]], /overplot, $
        /fill_background, fill_color='white smoke', fill_level=yrange[1] )
    shaded.Order, /send_to_back

    ;vert = objarr(nn)
    ;for ii = 0, nn-1 do begin
    ;    vert[ii] = plot( $
    ;        [ind[ii], ind[ii]], $
    ;        plt[0].yrange, $
    ;        /overplot, $
    ;        thick=1.0, $
    ;        color='light gray', $
    ;        ystyle=1 )
    ;    vert[ii].Order, /send_to_back
    ;endfor


file = 'lc'  ;- specific to flare?
save2, file

end
