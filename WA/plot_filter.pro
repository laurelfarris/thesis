;+
;- LAST MODIFIED:
;-   05 June 2020
;-
;- ROUTINE:
;-   plot_filter.pro
;-
;- EXTERNAL SUBROUTINES:
;-
;- PURPOSE:
;-   Plots raw LCs overlaid with smoothed LCs
;-   (and maybe pre-flare bg? That should be part of general plotting routines
;-    since this is specifically for showing filtered data...)
;-  Smoothed/filtered LCs are obtained from call to the FILTER function.
;-  Detrended LCs are obtined by subtracting the smoothed LC from the raw LC
;-     (or do you divide? I dunno...)
;-
;- USEAGE:
;-
;- TO DO:
;-   []
;-
;- AUTHOR:
;-   Laurel Farris
;-

;=============================================================================================================
;=====
;=


buffer = 1


;+
;--- Plot original (raw) light curves
;-


;-  Can plot_lc.pro be used for this? No sense in having duplicate code...
;-   I'm thinking yes...

;- .RUN plot_lc
;- .RUN plot_background (maybe)



;time = strmid(A[0].time,0,5)
;xdata = indgen( size(A.flux, /dimensions) )
;-  Defined at ML in plot_lc.pro

;- window dimensions
;-   NOTE: batch_plot_2.pro defaults are wx=8.0 and wy=3.0
wx = 8.0
wy = 3.0


;-
;offset = -1.e7
offset = 0.0
    ;- --> HARDCODING!!

delt = [ min(flux[*,0]), (min(flux[*,1]) + offset) ]
    ;- delt = 2-element array
resolve_routine, 'shift_ydata', /either
SHIFT_YDATA, plt, delt=delt
save2, "raw_LCs_shifted"


;+
;- new plot window with detrended light curves
;-   (2nd window, even though variable is plt3... confusing at first b/c
;-    assumed there should be 3 windows... )
;-

;+
;-
;- SUBTRACT inverse transfrom
detrended = flux[2:*,*] - inverseTransform[1:*,*]
title = 'Detrended (flux - inverseTransform)'
fname = 'lc_detrended_SUBRACTED'
;-
;- DIVIDE inverse transfrom
;detrended = flux[2:*,*] / inverseTransform[1:*,*]
;title = 'Detrended (flux / inverseTransform)'
;fname = 'lc_detrended_DIVIDED'
;-
;-
dw
plt3 = BATCH_PLOT( $
    ;ind, $
    ;xdata[2:*,*], $   ;- xdata defined above as [ [ind], [ind] ] so dimensions match ydata.
    xdata[10:*,*], $
    detrended[8:*,*], $
    stairstep=1, $
    ;ytickvalues=[-1.e6, 0, 1e6], $
    ;ytickvalues=[0.0], $
    ;overplot = 1<cc, $
    title = title, $
    ;color=['dark orange', 'blue'], $
    color=A.color, $
    wx=wx, wy=wy, $
    left = 0.75, right=0.25, $
    ;thick = 2.0, $
    buffer=buffer $
)
;-
save2, fname

end
