;- LAST MODIFIED:
;-
;- ROUTINE:
;-
;- EXTERNAL SUBROUTINES:
;-
;- PURPOSE:
;-   
;- USEAGE:
;-
;- INPUT ARGS:
;-
;- KEYWORDS (optional):
;-
;- OUTPUT:
;-
;- TO DO:
;-
;- KNOWN BUGS:
;-   Possible errors, harcoded variables, etc.
;-
;- AUTHOR:
;-   Laurel Farris
;-
;-


;- Keep period > 400 sec (freq < 2.5 mHz)

buffer = 1

;-------------------

time = strmid(A[0].time,0,5)
flux = A.flux

;+
;--- Plot original (raw) light curves
;-
wx = 8.0
wy = 3.0

dw

stop

;-
;- 15 May 2020
;- IDL> .RUN plot_lc
;-   create LC of raw flux since the following is an old and uncoooperative mess.
;- Skip to second long horizonal line of "=" signs, and pick up code again.
;-

;=============================================================================================================
;=====
;=

;xdata = [ [ind], [ind] ]
xdata = indgen( size(A.flux, /dimensions) )

resolve_routine, 'batch_plot_2', /either
plt = BATCH_PLOT_2( $
    xdata, flux, $
    xtickinterval=25, $    ;- depends on TOTAL duration of time series.
    color=A.color, $
    name=A.name, $
    wx=wx, wy=wy, $
    yticklen=0.010, $
    stairstep=1, $
    buffer=buffer )
;-
save2, "raw_LCs"


;-
;offset = -1.e7
offset = 0.0
    ;- --> HARDCODING!!

delt = [ min(flux[*,0]), (min(flux[*,1]) + offset) ]
    ;- delt = 2-element array
resolve_routine, 'shift_ydata', /either
SHIFT_YDATA, plt, delt=delt
save2, "raw_LCs_shifted"


STOP

;+
;--- Overplot pre-flare background
;-

;- --> HARDCODING!! BAD CODER!
;zind = [120:259]
zind = [0:150]
;- zind = z-indices of pre-flare data from which to extract pre-flare background level
;-    (doesn't start at zero because of the C-flare that took place in the middle
;-      of my pre-flare time period before the X2.2 flare on 15 February 2011... rude).
;-
;-
;background = MEAN(A.flux[zind], dim=1) - delt
;- 15 May 2020
;-  NOTE: "flux" is a subset extracted from A.flux (z-dimension), so in order to get pre-flare background level,
;-    have to go back to full time series: A.flux to get the pre-flare flux, 
;-    which was cropped out when defining "flux"...
;-    (was initially confused as to why using A.flux here instead of flux... )
;background = MEAN(A.flux[zind], dim=1)
background = MEAN(A.flux[zind], dim=1)
for jj = 0, 1 do begin
    hor = plot2( $
        plt[0].xrange, $
        [ background[jj], background[jj] ], $
        /overplot, $
        linestyle=[1, '1111'X], $
        name = 'Background' )
endfor
;save2, filename


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
