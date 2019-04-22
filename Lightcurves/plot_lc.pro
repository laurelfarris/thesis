;+
;- LAST MODIFIED:
;-   21 April 2019
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
;-

goto, start

start:;----------------------------------------------------------------------------------

@parameters

file = 'lc'

;ydata = A.flux

;- sloppy normalizing...
ydata1 = A[0].flux
ydata2 = A[1].flux
ydata1 = ( ydata1 - min(ydata1) )/(max(ydata1)-min(ydata1))
ydata2 = ( ydata2 - min(ydata2) )/(max(ydata2)-min(ydata2)); + 0.1

ydata = [ [ydata1], [ydata2] ]

n_obs = (size(ydata, /dimensions))[0]
;xdata = A.jd
xdata = [ [indgen(n_obs)], [indgen(n_obs)] ]
;xtickinterval = A[0].jd[75] - A[0].jd[0]
xtickinterval = 75
ytitle=A.name + ' (DN s$^{-1}$)'

;ytickinterval = 0.2
ymajor = 2

dw
resolve_routine, 'batch_plot', /either
plt = BATCH_PLOT(  $
    xdata, ydata, $
    ystyle=1, $
    xrange=[0,n_obs-1], $
    thick=[0.5, 0.8], $
    xtickinterval=xtickinterval, $
    ;ytickinterval=ytickinterval, $
    ymajor = ymajor, $
    ;ylog = 1, $
    color=A.color, $
    name=A.name, $
    buffer=0 )


increment = (max(ydata1)-min(ydata1))/ymajor

ax = plt[0].axes
;ax[1].tickname = string( [ min(A[0].flux) : max(A[0].flux) : increment ] ) 
;ax[3].tickname = string( [ min(A[1].flux) : max(A[1].flux) : increment ] ) 
ax[1].tickname = [ '2.78$\times10^{7}$' , '2.94$\times10^{7}$' ]
ax[3].tickname = [ '4.96$\times10^{8}$' , '9.08$\times10^{8}$' ]

;dy = ytickinterval * (max(A[0].flux)-min(A[0].flux))
;ax[1].tickname = string( [ min(A[0].flux) : max(A[0].flux) : dy ] )
;ax[1].tickname = strarr( plot[0].ymajor )

ax[3].showtext = 1

time = strmid( A[0].time, 0, 5 )
ax[0].tickname = time[ax[0].tickvalues]
ax[0].title = 'Start time (' + date + ' ' + tstart + ')'

;resolve_routine, 'label_time', /either
;LABEL_TIME, plt, time=A.time;, jd=A.jd

;resolve_routine, 'shift_ydata', /either
;SHIFT_YDATA, plt

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

stop




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

save2, file

end
