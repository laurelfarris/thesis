;+
;- LAST MODIFIED:
;-   18 February 2020
;-     Attempting to create light curves for ROIs ...
;-
;-   03 August 2019
;-     Bare Min: needs to produce lc figures for ANY flare.
;-     (see plot_lc_2.pro for early attempts at a nice subroutine)
;-
;- PURPOSE:
;-   Plot light curves.
;-
;- INPUT:
;-
;- KEYWORDS:
;-
;- OUTPUT:
;-
;- TO DO:
;-   Generalize variables currently hardcoded:
;-     * filename
;-     * ydata
;-     * xtickinterval
;-
;-


@parameters
;- uncomment the flare to plot LCs for.


;IDL .run struc_aia


;filename = 'lc_C30'
;filename = 'lc_' + class    ;- 'class' defined in @parameters (30 August 2019)

;+
;- 18 February 2020
filename = 'lc_ROI'
;-
;-

;ydata = A.flux

;- sloppy normalizing...
;ydata1 = A[0].flux
;ydata2 = A[1].flux
;ydata1 = ( ydata1 - min(ydata1) )/(max(ydata1)-min(ydata1))
;ydata2 = ( ydata2 - min(ydata2) )/(max(ydata2)-min(ydata2)); + 0.1
;ydata = [ [ydata1], [ydata2] ]

;ydata = A.flux
ydata = [ $
    [ A[0].flux / A[0].exptime ], $
    [ A[1].flux / A[1].exptime ] $
]


;+
;- 18 February 2020
ydata = roi_flux
;-
;-

;help, ydata
;format = '(e0.2)'
;print, max(ydata[*,0]), format=format
;print, max(ydata[*,1]), format=format

n_obs = (size(ydata, /dimensions))[0]
;xdata = A.jd
xdata = [ [indgen(n_obs)], [indgen(n_obs)] ]
;xtickinterval = A[0].jd[75] - A[0].jd[0]
xtickinterval = 75
ytitle=A.name + ' (DN s$^{-1}$)'


;resolve_routine, 'batch_plot', /either
;plt = BATCH_PLOT(  $
dw
resolve_routine, 'batch_plot_2', /either
plt = BATCH_PLOT_2(  $
    xdata, ydata, $
    ystyle=1, $
    xrange=[0,n_obs-1], $
    thick=[0.5, 0.8], $
    xtickinterval=xtickinterval, $
    ;ytickinterval=ytickinterval, $
    ;ylog = 1, $
    color=A.color, $
    name=A.name, $
    buffer=0 )


;-
;-  30 August 2019
;-
;yoffset = 0.10
;plt[1].position = plt[1].position + [0, yoffset, 0, yoffset]
;-  Trying to shift plots slightly in y relative to each other so
;-   they look nicer, like Milligan2017's LCs for AIA 1600 and 1700...
;-   Did not work.
;- 
;- One more attempt
;print, plt[1].yrange



dy = plt[0].yrange[1] - plt[0].yrange[0]
;print, dy, format=format
plt[0].yrange = [ $
    plt[0].yrange[0], $
    ( plt[0].yrange[1] + (dy*0.2) )  $
]




dy = plt[1].yrange[1] - plt[1].yrange[0]
print, dy, format=format

plt[1].yrange = [ $
    ( plt[1].yrange[0] - (dy*0.2) ), $
    plt[1].yrange[1]  $
]

;- 
;- 
;- 
;- 



;-----------------------------------------------------
;- Add top and right axes for plt2 (excluded when axis_style=1)

resolve_routine, 'axis2', /is_function
ax2 = axis2( 'X', $
    location='top', $
    ;target=plt[0], $
    target=plt[1], $
    showtext=0 $
)

ax3 = axis2( 'Y', $
    location='right', $
    target = plt[1], $
    ;text_color = color[1], $
    text_color = A[1].color, $  ;- = ['green','purple'] in plot_pt.pro ...
    ;title = plt[1].name + ' 3-minute power', $
    showtext=1 $
)
;-----------------------------------------------------


;increment = (max(ydata1)-min(ydata1))/ymajor

;ax = plt[0].axes

;ax[1].tickname = string( [ min(A[0].flux) : max(A[0].flux) : increment ] )
;ax[3].tickname = string( [ min(A[1].flux) : max(A[1].flux) : increment ] )
;ax[1].tickname = [ '2.78$\times10^{7}$' , '2.94$\times10^{7}$' ]
;ax[3].tickname = [ '4.96$\times10^{8}$' , '9.08$\times10^{8}$' ]

;dy = ytickinterval * (max(A[0].flux)-min(A[0].flux))
;ax[1].tickname = string( [ min(A[0].flux) : max(A[0].flux) : dy ] )
;ax[1].tickname = strarr( plot[0].ymajor )

;ax[3].showtext = 1




;ax = plt[0].axes
    ;- plt[0].axes only consists of 3 axes, not 4...
ax = [ plt[0].axes, plt[1].axes ]

time = strmid( A[0].time, 0, 5 )
ax[0].tickname = time[ax[0].tickvalues]
ax[0].title = 'Start time (' + date + ' ' + ts_start + ')'
    ;-  date is defined in @parameters

;resolve_routine, 'label_time', /either
;LABEL_TIME, plt, time=A.time;, jd=A.jd

;resolve_routine, 'shift_ydata', /either
;SHIFT_YDATA, plt

resolve_routine, 'oplot_flare_lines', /is_function
vert = OPLOT_FLARE_LINES( $
    plt, $
    ;color='magenta', $
      ;- confirming that kw value set when calling subroutine
      ;-  overrides the value set when subroutine calls PLOT. 
    t_obs=A[0].time, $
    send_to_back=1 )

resolve_routine, 'legend2', /either
leg = LEGEND2( target=plt, /upperleft, sample_width=0.25 )

;- NO point in defining these twice (ax[1] and ax[3]) -- 17 January 2020
ymajor = -1
yminor = -1

ax[1].title = ytitle[0]
;ax[1].tickvalues = [2:8:2]*10.^7 ; -- hardcoded, 2011 flare
;ax[1].tickname = scinot( ax[1].tickvalues )
ax[1].major = ymajor
ax[1].minor = yminor


;ax = plt[1].axes
ax[3].title = ytitle[1]
;ax[3].tickvalues = [2.2:2.8:0.2]*10.^8 ; -- hardcoded, 2011 flare
;ax[3].tickname = scinot( ax[3].tickvalues )
;ax[3].tickinterval = 1e7
ax[3].major = ymajor
ax[3].minor = yminor

ax[3].title = ytitle[1]
;ax3.title = ytitle[1]


;- Color axes to match data
ax[1].text_color = A[0].color
;ax[3].color = A[1].color
ax[3].text_color = A[1].color



; Single lines creating each object that can easily be commented.
; Then just erase and re-draw.

;- --> Put ML stuff into a subroutine that calls all the other subroutines?

;----------------------------------------------------------------

;- 02 December 2018
;- Mark BDA times on LC.

;- aka, indices of x-axis where shading goes (should cover "During").

;time = strmid(A[0].time,0,5) --> defined earlier, right after LC plot is produced.
;bda_times = ['01:00', '01:45', '02:30', '03:15']
;bda_times = ['01:44', '02:30']
;nn = n_elements(bda_times)
;ind = intarr(nn)
;for ii = 0, nn-1 do $
;    ind[ii] = (where( time eq bda_times[ii] ))[0]

;- Attempt at generalizing for multiple flares:
;ind = [ $
;    (where(time eq strmid(gstart,0,5)))[0], $
;    (where(time eq strmid(  gend,0,5)))[0] ]
;- Seems to work, but goes start/end times do NOT define the boundaries
;-  of the shaded region... I defnined this myself as the "During" phase

;ind = [375, 525] ;- flare[1], I think. (17 January 2020)

ind = [(where(time eq my_start))[0],(where(time eq my_end))[0]]

;print, ind
;print, time[ind]

;----------------------------------------------------------------

;yrange=[ [plt[0].yrange], [plt[1].yrange] ]
;yrange = [ $
;    min( [plt[0].yrange[0], plt[1].yrange[0] ] ), $
;    max( [plt[0].yrange[1], plt[1].yrange[1] ] ) ]
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

;- BDA lines, before I figured out how to do shading?
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

print, ''
print, 'ATTENTION USER!!'
print, ' ... --> Type .c to save file: ', filename
stop

save2, filename

end
