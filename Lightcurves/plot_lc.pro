;+
;- LAST MODIFIED:
;-
;-  01/07/2024:
;-    This is a Main Level (ML) routine that
;-      • Calls script @main:  Codes/main.pro, which
;-             calls script @path_temp (backup loc when SolarStorm went kaput),
;-             sets a bunch of standard default variables like buffer, instr, cadence, etc.
;-                    ("standard" for this project anyway),
;-               calls MULTIFLARE_STRUC function according to flare_id of choice, set by variable 'class':
;-                  IDL> class = 'x22' or class = 'c30',
;-               with all lowercase, no period beteen class # and subclass #
;-           AND
;-              checks for existance of .sav files (if yes, restore struc, if not, prints error)
;-      • defines filename to save pdf of figure
;-      • 
;-      • 


;-   12/27/2023:
;-     File 'batch_plot_2.pro' no longer exists --> merged with 'batch_plot.pro'
;-     tho still defined as its own function within  'batch_plot.pro', should be able to call
;-     function BATCH_PLOT_2( ... ) for 'filename.pro' after running
;-       IDL> RESOLVE_ROUTINE, <filename>
;-  
;-   07 July 2021
;-     copied to plot_lc_20210707.pro to remove ML code that has nothing to do with LCs,
;-     but may be important and needs to be copied to more relevant routines, including:
;-       • ALIGNMENT routines: restoring and saving w/ extra variables (shifts, allshifts,..)
;-       • computes FLUX for each channel (wrote code here for this before modifying struc_aia
;-           to work with multiflare structure / @par2

;- EXTERNAL SUBROUTINES:
;-     batch_plot.pro

;- PURPOSE:
;-   General Lightcurve (LC) plotting routine

;- TO DO:
;-   [] Generalize variables currently hardcoded:
;-       • filename  • ydata  • xtickinterval
;-   [] See older versions of similar code (plot_lc*.pro) for LOTS of comments.. 
;-           (maybe helpful, maybe time waster)
;-   [] See Lightcurves/MAKE_PLOTS.pro
;-   [] Generalize entire routine for ANY lightcurve
;-       => merge this code w/ plot_lc_GENERAL.pro:
;-            procedure + ML code,
;-         (early attempts at generalizing.. apparently didn't take.)


@main

;restore, path + 'flares/' + class + '/' + class + '_' + 'struc.sav'
;help, A[0]
;help, A[1]
; ==>> main.pro takes care of this now (13 Dec 2022)

aia_lc_filename = class + '_' + strlowcase(instr) + '_lightcurve'
print, aia_lc_filename

;+
;--- create string variables to use in filenames (I guess)
;class = strlowcase(strjoin(strsplit(flare.class, '.', /extract)))
;- flare.class = M1.5 --> class = m15
;date = flare.year + flare.month + flare.day
;- flare.date = 12-Aug-2013 --> date = 20130812
;==>> class and date both defined in par2.pro  (07 Sep 2021)

;=
;======================================================================
;= Plot light curves for AIA emission (integrated; the original)
;=

; NOTE: code below refers to variable "rhessi_xdata",
;   a 2D array defined in "plot_rhessi.pro"

;------------------------------------------------------------------------------------------------------
;- 07 January 2024 -- Stab at what variables are for..
;-    aia1600ind, aia1700ind:
;-       both = 2-element array of INDICES corresponding to observation time
;-          .. used to select 𝝙t window spanned by x-axis in LCs.
;
; 07 September 2021 -- use jd instead of integers ... to do hwut, exactly? (07 January 2024)
loc1 = (where( A[0].jd ge rhessi_xdata[0,0] ))[0]
loc2 = (where( A[0].jd le rhessi_xdata[-1,0] ))[-1]
aia1600ind = [loc1:loc2]
;- 07 Jan. 2024:
;-   loc1 & loc2 only used to define aia1600ind...
;-     redundant, but perhaps too messy to define aia1600ind directly.)
;-  The following should work;  => run in simple test code first..
;
;        aia1600ind = [ $
;            (where(A[0].jd ge rhessi_xdata[0,0]))[0] : (where(A[0].jd le rhessi_xdata[-1,0]))[-1] $
;            ]
; 
;- aia1700ind defined below using a different approach ?
; 
;AND A[0].jd le rhessi_xdata[-1,0] )
;-    ... ??
;
;aia1700ind = where( A[1].jd ge rhessi_xdata[0,0] AND A[1].jd le rhessi_xdata[-1,0] )
;  Not same size; 150 and 151... may not play nice. Fix later.
;   Using 1600 jd for both channels... close enough.
;
;
;- Appears that TIME array for LCs is the same for both 1600 and 1700 data, even though times
;-   should be slightly offset.
;- Maybe not huge deal.. but this should be a simple thing to plot..
;-   ==>> look up some documentation on x

;------------------------------------------------------------------------------------------------------

;ydata = A.flux
aia_ydata = [ $
    [ A[0].flux[aia1600ind] / A[0].exptime ], $
    [ A[1].flux[aia1600ind] / A[1].exptime ] $
]

n_obs = (size(aia_ydata, /dimensions))[0]
;xdata = [ [indgen(n_obs)], [indgen(n_obs)] ]
; => see today.pro (21 Feb 2020)
;xdata = [ [A[0].jd[aia1600ind]], [A[0].jd[aia1600ind]]  ]
;aia_xdata = [ [(indgen(n_obs))[aia1600ind]], [(indgen(n_obs))[aia1600ind]] ]
aia_xdata = FIX( [ [aia1600ind], [aia1600ind] ] )
;xdata = A.jd

;=== HARDCODED! Make this better!
;;xtickinterval = A[0].jd[75] - A[0].jd[0]
;xtickinterval = 75
xtickinterval = 5

;- From ../WA/plot_filter.pro, though probably don't need to preserve these values
;xtickinterval = 25
;yticklen=0.010
stairstep=1

;xminor = 5
ytitle=A.name + ' (DN s$^{-1}$)'

dw
resolve_routine, 'batch_plot', /either

plt = BATCH_PLOT(  $
    aia_xdata, aia_ydata, $
;    ystyle=1, $
    ystyle=2, $
    ;xrange=[0,n_obs-1], $
    thick=[0.5, 0.8], $
    ;xtickinterval=xtickinterval, $
    ;xminor=xminor, $
    ;yticklen=yticklen, $
    stairstep=stairstep, $
    color=A.color, $
    name=A.name, $
    buffer=buffer $
)

; 14 March 2020 -- padding for yrange
dy = plt[0].yrange[1] - plt[0].yrange[0]
plt[0].yrange = [ $
    plt[0].yrange[0], $
    ( plt[0].yrange[1] + (dy*0.2) )  ]

dy = plt[1].yrange[1] - plt[1].yrange[0]
plt[1].yrange = [ $
    ( plt[1].yrange[0] - (dy*0.2) ), $
    plt[1].yrange[1]  ]

dy1600 = plt[0].yrange[1] - plt[0].yrange[0]
dy1700 = plt[1].yrange[1] - plt[1].yrange[0]
plt[0].yrange = plt[0].yrange + [-(dy1600*0.05), 0.0]
plt[1].yrange = plt[1].yrange + [0.0, dy1700*0.05]

;- Add top and right axes for plt2 (excluded when axis_style=1)
resolve_routine, 'axis2', /is_function
ax2 = axis2( 'X', $
    location='top', $
    target=plt[1], $
    tickinterval=plt[0].xtickinterval, $
    minor=plt[0].xminor, $
    showtext=0 $
)
ax3 = axis2( 'Y', $
    location='right', $
    target = plt[1], $
    text_color = A[1].color, $
    showtext=1 $
)

ax = [ plt[0].axes, plt[1].axes ]


time = strmid( A[0].time, 0, 5 )

ax[0].tickname = time[ax[0].tickvalues]
;restore, path + 'flares/' + class + '/' + class + '_aia1600header.sav'
;aia1600index = index
;ax[0].title = 'Start time (' + ANYTIM( aia1600index[0].t_obs, /stime ) + ')'
ax[0].title = 'Start time (' + flare.date + ' ' + A[0].time[aia1600ind[0]] + ')'
;print, ax[0].title
;resolve_routine, 'label_time', /either
;LABEL_TIME, plt, time=A.time;, jd=A.jd
;resolve_routine, 'shift_ydata', /either
;SHIFT_YDATA, plt

save2, aia_lc_filename
stop

;==>> Problem w/ oplot_flare_lines... aia 1700 data is being pushed halfway across the plot..
;print, plt[1].xrange
resolve_routine, 'oplot_flare_lines', /is_function
vert = OPLOT_FLARE_LINES( plt, flare=flare, t_obs=A[0].time[aia1600ind], send_to_back=1 )

print, plt[0].xrange
print, plt[1].xrange
;

save2, aia_lc_filename

stop
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
;print, x_vertices
;
shaded = OPLOT_SHADED( x_vertices, plt )
;
resolve_routine, 'legend2', /either
leg = LEGEND2( target=plt, sample_width=0.25, $
    ;/upperleft )
    /upperright )
;
;- --> Y-major/minor aren't necessarily the same for both y-axes!
;-       1600A y-range is different from 1700A.
ymajor = 4
yminor = 3
;
ax[1].title = ytitle[0]
ax[1].minor = yminor
;
ax[3].title = ytitle[1]
ax[3].major = ymajor
ax[3].minor = yminor
;-
ax[3].title = ytitle[1]
;
;- Color axes to match data
ax[1].text_color = A[0].color
ax[3].text_color = A[1].color
;-
save2, aia_lc_filename


end
