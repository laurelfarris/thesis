;+
;- LAST MODIFIED:
;-   07 July 2021
;-     copied to plot_lc_20210707.pro to remove ML code that has nothing to do with LCs,
;-     but may be important and needs to be copied to more relevant routines, including:
;-       • ALIGNMENT routines: restoring and saving w/ extra variables (shifts, allshifts,..)
;-       • computes FLUX for each channel (wrote code here for this before modifying struc_aia
;-         to work with multiflare structure / @par2
;-       •
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
;-   [] Generalize variables currently hardcoded:
;-     * filename
;-     * ydata
;-     * xtickinterval
;-   [] Generalize entire routine for ANY lightcurve
;-     (see plot_lc_GENERAL.pro for early attempts)
;-


buffer=1

;@par2
; 18 July 2022 -- now calling, e.g. multiflare = multiflare_struc(), then flare=multiflare.c83 or w/e
;    Already did this in ML of Prep/aia_struc.pro

multiflare=multiflare_struc()

flare = multiflare.c83

aia_lc_filename = class + '_aia_lightcurve'
print, aia_lc_filename

;flare = multiflare.m73
; Set flare at end of par2.pro, after multiflare structure def.
;  ( 07 September 2021 )

;instr = 'aia'
;channel = '1600'
;channel = '1700'
;cc = 0
;cc = 1
;channel = A[cc].channel


;+
;--- create string variables to use in filenames (I guess)
;class = strlowcase(strjoin(strsplit(flare.class, '.', /extract)))
;- flare.class = M1.5 --> class = m15
;date = flare.year + flare.month + flare.day
;- flare.date = 12-Aug-2013 --> date = 20130812
;==>> class and date both defined in par2.pro
;       (07 Sep 2021)
;------


stop

;=
;======================================================================
;= plot light curves for integrated AIA emission (the original)
;=


; 07 September 2021 - use jd instead of integers
loc1 = (where( A[0].jd ge rhessi_xdata[0,0] ))[0]
loc2 = (where( A[0].jd le rhessi_xdata[-1,0] ))[-1]
aia1600ind = [loc1:loc2]

;AND A[0].jd le rhessi_xdata[-1,0] )
;aia1700ind = where( A[1].jd ge rhessi_xdata[0,0] AND A[1].jd le rhessi_xdata[-1,0] )
;  Not same size; 150 and 151... may not play nice. Fix later.
;   Using 1600 jd for both channels... close enough.
;
;ydata = A.flux

aia_ydata = [ $
    [ A[0].flux[aia1600ind] / A[0].exptime ], $
    [ A[1].flux[aia1600ind] / A[1].exptime ] $
]
;
n_obs = (size(aia_ydata, /dimensions))[0]
;xdata = [ [indgen(n_obs)], [indgen(n_obs)] ]
;-  see today.pro (21 Feb 2020)
;
;xdata = [ [A[0].jd[aia1600ind]], [A[0].jd[aia1600ind]]  ]
;aia_xdata = [ [(indgen(n_obs))[aia1600ind]], [(indgen(n_obs))[aia1600ind]] ]
;
aia_xdata = FIX( [ [aia1600ind], [aia1600ind] ] )
;
;
;help, xdata
;help, ydata
;
;xdata = A.jd
;
;;xtickinterval = A[0].jd[75] - A[0].jd[0]
;xtickinterval = 75
;
xtickinterval = 5
;
;- From ../WA/plot_filter.pro, though probably don't need to preserve these values
;xtickinterval = 25
;yticklen=0.010
stairstep=1
;
;xminor = 5
ytitle=A.name + ' (DN s$^{-1}$)'
;
;stop
;



dw
resolve_routine, 'batch_plot_2', /either
plt = BATCH_PLOT_2(  $
    aia_xdata, aia_ydata, $
    ystyle=1, $
    ;xrange=[0,n_obs-1], $
    thick=[0.5, 0.8], $
    ;xtickinterval=xtickinterval, $
    ;xminor=xminor, $
    ;yticklen=yticklen, $
    stairstep=stairstep, $
    color=A.color, $
    name=A.name, $
    buffer=buffer )
;
;-
;-  30 August 2019
;yoffset = 0.10
;plt[1].position = plt[1].position + [0, yoffset, 0, yoffset]
;-  Trying to shift plots slightly in y relative to each other so
;-   they look nicer, like Milligan2017's LCs for AIA 1600 and 1700...
;-   Did not work.
;-
;- One more attempt
;print, plt[1].yrange
;-
dy = plt[0].yrange[1] - plt[0].yrange[0]
;print, dy, format=format
plt[0].yrange = [ $
    plt[0].yrange[0], $
    ( plt[0].yrange[1] + (dy*0.2) )  $
]
;-
dy = plt[1].yrange[1] - plt[1].yrange[0]
;print, dy, format=format
;-
plt[1].yrange = [ $
    ( plt[1].yrange[0] - (dy*0.2) ), $
    plt[1].yrange[1]  $
]
;-
;- 14 March 2020
;-  hardcoding padding for yrange, for now..
;plt[0].yrange = plt[0].yrange + [-0.2e7, 0.0]
;plt[1].yrange = plt[1].yrange + [0.0, 0.05e8]
;-
dy1600 = plt[0].yrange[1] - plt[0].yrange[0]
dy1700 = plt[1].yrange[1] - plt[1].yrange[0]
;-
;-
;-
;plt[0].yrange = [ plt[0].yrange[0]-0.2e7, plt[0].yrange[1]        ]
;plt[1].yrange = [ plt[1].yrange[0],       plt[1].yrange[1]+0.05e8 ]
;-
;plt[0].yrange = plt[0].yrange + [-0.2e7, 0.0]
;plt[1].yrange = plt[1].yrange + [0.0, 0.05e8]
;-  same function as previous two lines, but looks cleaner.
;
plt[0].yrange = plt[0].yrange + [-(dy1600*0.05), 0.0]
plt[1].yrange = plt[1].yrange + [0.0, dy1700*0.05]
;
;
;-
;-
;-----------------------------------------------------
;- Add top and right axes for plt2 (excluded when axis_style=1)
;-
resolve_routine, 'axis2', /is_function
ax2 = axis2( 'X', $
    location='top', $
    ;target=plt[0], $
    target=plt[1], $
    tickinterval=plt[0].xtickinterval, $
    minor=plt[0].xminor, $
    showtext=0 $
)
;-
ax3 = axis2( 'Y', $
    location='right', $
    target = plt[1], $
    ;text_color = color[1], $
    text_color = A[1].color, $  ;- = ['green','purple'] in plot_pt.pro ...
    ;title = plt[1].name + ' 3-minute power', $
    showtext=1 $
)
;-----------------------------------------------------
;-
;increment = (max(ydata1)-min(ydata1))/ymajor
;-
;ax = plt[0].axes
;-
;ax[1].tickname = string( [ min(A[0].flux) : max(A[0].flux) : increment ] )
;ax[3].tickname = string( [ min(A[1].flux) : max(A[1].flux) : increment ] )
;ax[1].tickname = [ '2.78$\times10^{7}$' , '2.94$\times10^{7}$' ]
;ax[3].tickname = [ '4.96$\times10^{8}$' , '9.08$\times10^{8}$' ]
;-
;dy = ytickinterval * (max(A[0].flux)-min(A[0].flux))
;ax[1].tickname = string( [ min(A[0].flux) : max(A[0].flux) : dy ] )
;ax[1].tickname = strarr( plot[0].ymajor )
;-
;ax[3].showtext = 1
;-
;ax = plt[0].axes
    ;- plt[0].axes only consists of 3 axes, not 4...
ax = [ plt[0].axes, plt[1].axes ]
;-
time = strmid( A[0].time, 0, 5 )
;
ax[0].tickname = time[ax[0].tickvalues]
;
;ax[0].title = 'Start time (' + date + ' ' + ts_start + ')'
    ;-  date is defined in @parameters
;ax[0].title = 'Start time (' + flare.date + ' ' + A[0].time[0] + ')'
    ;- ==>> need better way to do this!
ax[0].title = 'Start time (' + ANYTIM( aia1600index[0].t_obs, /stime ) + ')'
;
;-
;resolve_routine, 'label_time', /either
;LABEL_TIME, plt, time=A.time;, jd=A.jd
;-
;resolve_routine, 'shift_ydata', /either
;SHIFT_YDATA, plt
;-
;resolve_routine, 'oplot_flare_lines', /is_function
;vert = OPLOT_FLARE_LINES( $
;    plt, t_obs=A[0].time, send_to_back=1 )
;-
;
;
;fill_color=['yellow', 'green', 'indigo']
;fill_color=['pale goldenrod', 'pale green', 'light sky blue']
;fill_color=['white smoke', 'light yellow', 'light blue']
;fill_color=['eeeeee'X, 'e4e4e4'X, 'dadada'X]
;fill_color=['ffffdf'X, 'dfffdf'X, 'afffff'X]
color=['ffaf5f'X, '87d7af'X, '5f5fd7'X]
name = ['impulsive', 'peak', 'decay']
;
x_vertices=[ $
    [ $
        (where( strmid(A[0].time,0,5) eq strmid(impulsive[0],0,5)))[0], $
        (where( strmid(A[0].time,0,5) eq strmid(impulsive[1],0,5)))[0] $
    ], [ $
        (where( strmid(A[0].time,0,5) eq strmid(peak[0],0,5)))[0], $
        (where( strmid(A[0].time,0,5) eq strmid(peak[1],0,5)))[0] $
    ], [ $
        (where( strmid(A[0].time,0,5) eq strmid(decay[0],0,5)))[0], $
        (where( strmid(A[0].time,0,5) eq strmid(decay[1],0,5)))[0] $
    ] $
]
;
print, x_vertices
;
y2 = max( [plt[0].yrange, plt[1].yrange])
y1 = min( [plt[0].yrange, plt[1].yrange])
;
shaded = objarr(3)
for ii = 0, n_elements(shaded)-1 do begin
    x1 = x_vertices[0,ii]
    x2 = x_vertices[1,ii]
    shaded[ii] = POLYGON( $
        [x1,x2,x2,x1], $
        [y1,y1,y2,y2], $
        target=plt, $
        /data, $
        thick=0.5, $
        linestyle=[1,'5555'X], $
        color=color[ii], $
        /fill_background, $
        ;fill_color=fill_color[ii], $
        fill_color='eeeeee'X, $
        ;fill_transparency=50, $
        name = name[ii] $
    )
    shaded[ii].Order, /SEND_TO_BACK
endfor
;
resolve_routine, 'legend2', /either
leg = LEGEND2( $
    target=plt, $
    ;/upperleft, $
    /upperright, $
    sample_width=0.25 )
;
;-
;- NO point in defining these twice (ax[1] and ax[3]) -- 17 January 2020
;ymajor = -1
;yminor = -1
;-
;-
;- --> Y-major/minor aren't necessarily the same for both y-axes!
;-       1600A y-range is different from 1700A.
;- ...except the following values should work for both.. appear to be
;-   what original axes are set to.
;-     (14 March 2020)
ymajor = 4
yminor = 3
;-
;-
;-
;
ax[1].title = ytitle[0]
;ax[1].tickvalues = [2:8:2]*10.^7 ; -- hardcoded, 2011 flare
;-----ax[1].tickvalues = [2:6:1]*10.^7 ; -- hardcoded, 2011 flare
;ax[1].tickname = scinot( ax[1].tickvalues )
;ax[1].major = ymajor
ax[1].minor = yminor
;
;-
;ax = plt[1].axes
ax[3].title = ytitle[1]
;----ax[3].tickvalues = [2.2:2.8:0.2]*10.^8 ; -- hardcoded, 2011 flare
;ax[3].tickname = scinot( ax[3].tickvalues )
;ax[3].tickinterval = 1e7
ax[3].major = ymajor
ax[3].minor = yminor
;-
ax[3].title = ytitle[1]
;ax3.title = ytitle[1]
;-
;- Color axes to match data
ax[1].text_color = A[0].color
;ax[3].color = A[1].color
ax[3].text_color = A[1].color
;-
save2, aia_lc_filename
;
stop


print, class
format = '(e0.2)'
for cc = 0, 1 do begin
;    print, min(A[cc].flux), format=format
;    print, max(A[cc].flux), format=format
    print, max(A[cc].flux)/min(A[cc].flux), format=format
endfor


;==============================================================================================

;- Shade "During portion of light curve


; Single lines creating each object that can easily be commented.
; Then just erase and re-draw.
;- --> Put ML stuff into a subroutine that calls all the other subroutines?
;----------------------------------------------------------------
;- 02 December 2018
;- Mark BDA times on LC.
;-
;- aka, indices of x-axis where shading goes (should cover "During").
;-
;time = strmid(A[0].time,0,5) --> defined earlier, right after LC plot is produced.
;bda_times = ['01:00', '01:45', '02:30', '03:15']
;bda_times = ['01:44', '02:30']
;nn = n_elements(bda_times)
;ind = intarr(nn)
;for ii = 0, nn-1 do $
;    ind[ii] = (where( time eq bda_times[ii] ))[0]
;-
;- Attempt at generalizing for multiple flares:
;ind = [ $
;    (where(time eq strmid(gstart,0,5)))[0], $
;    (where(time eq strmid(  gend,0,5)))[0] ]
;- Seems to work, but goes start/end times do NOT define the boundaries
;-  of the shaded region... I defnined this myself as the "During" phase
;-
;ind = [375, 525] ;- flare[1], I think. (17 January 2020)
;-
;-
ind = [(where(time eq my_start))[0],(where(time eq my_end))[0]]
;-
;print, ind
;print, time[ind]
;-
;----------------------------------------------------------------
;-
;yrange=[ [plt[0].yrange], [plt[1].yrange] ]

yrange = [ $
    min( [plt[0].yrange[0], plt[1].yrange[0] ] ), $
    max( [plt[0].yrange[1], plt[1].yrange[1] ] ) $
]


stop ; ==> use same shading as RHESSI lightcurves instead of this

;-
shaded = plot( $
    [ind[0], ind[1]], $
    [yrange[0], yrange[0]], $
    /overplot, $
    /fill_background, $
    fill_color='white smoke', $
    fill_level=yrange[1] $
)
shaded.Order, /send_to_back
;-
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
;-
;-
;-
;- 14 March 2020 -- seems unnecessary, since no harm in saving a figure
;-  unless already exists and danger of overwriting, but save2.pro
;-   will prompt for confirmation to overwrite if this is the case.
;print, ''
;print, 'ATTENTION USER!!'
;print, ' ... --> Type .c to save file: ', filename
;stop
;-
;-
save2, aia_lc_filename


;===============================================================================

;IDL> .RUN struc_aia

;-----------------------------------------------------------
;+
;- ROI LCs ... sorta hijacked this code, now having a hard time
;-   re-creating original LCs over entire AR.. (14 March 2020)
;-
;-
;- 18 February 2020
;filename = 'lc_ROI'
;ydata = roi_flux
;-   NOTE: roi_flux already divided by exptime in today.pro
;-    (or whatever code it's defined in the future).
;+
;-
;- 21 February 2020
;filename = 'lc_ROI_running_avg'
;ydata = roi_flux/lc_avg
;- --> See today.pro for def of ydata
;-
;-----------------------------------------------------------

;----
;- sloppy normalizing... can probably delete these lines
;ydata1 = A[0].flux
;ydata2 = A[1].flux
;ydata1 = ( ydata1 - min(ydata1) )/(max(ydata1)-min(ydata1))
;ydata2 = ( ydata2 - min(ydata2) )/(max(ydata2)-min(ydata2)); + 0.1
;ydata = [ [ydata1], [ydata2] ]
;----

;help, ydata
;format = '(e0.2)'
;-
;print, max(ydata[*,0]), format=format
;print, max(ydata[*,1]), format=format
;-
;print, max(ydata[*,0]) - min(ydata[*,0]), format=format
;print, max(ydata[*,1]) - min(ydata[*,1]), format=format


end
