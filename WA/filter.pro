;- LAST MODIFIED:
;-   15 May 2020
;-     Added arg "cutoff_period" to function call.
;-
;- ROUTINE:
;-   filter.pro
;-
;- EXTERNAL SUBROUTINES:
;-
;- PURPOSE:
;-   compute SMOOTHED lc:
;-     1. Perform FFT to transform flux from time domain to frequency domain.
;-        "Compute a power spectrum and determine threshold to filter out noise"
;-         --> this should probably be determined independently, then set
;-             arg "cutoff_period" in call to filter.pro
;-     2. Apply mask to the FFT-transformed image
;-        --> removes variations with periods shorter than the cutoff.
;-     3. Perform inverse FFT to transform flux back to time domain.
;-   
;- USEAGE:
;-    inverseTransform = FILTER( flux, cadence, cutoff_period )
;-
;- INPUT ARGS:
;-   flux
;-   cadence
;-   cutoff_period (SECONDS)
;-
;- KEYWORDS (optional):
;-
;- OUTPUT:
;-   inverse transform (smoothed LC)
;-     NOTE: a detrended LC
;-       (where the long-period, large-amplitude variations are removed to
;-         show small-amplitude, rapidly varying oscillations)
;-       is computed from this output by subtracting or dividing 
;-       the smoothed data from the raw data.
;-
;- TO DO:
;-   [] replace hardcoded cutoff for filter (in function "filter")
;-      used to create mask, and make new kw option, or something...
;-    (2/12/2020)
;-
;- KNOWN BUGS:
;-   Possible errors, harcoded variables, etc.
;-
;- AUTHOR:
;-   Laurel Farris
;-
;- See notes in:
;-   • comp book p. 99-103
;-   • Enotes "Detrending | FFT filter", "light curves - detrended"
;-


function FILTER, flux, cadence, cutoff_period

    ;- NOTE: use "newflux" for computations to avoid changing
    ;-   flux value at ML when modified value is passed back to caller.
    ;newflux = flux-(moment(flux))[0]
    newflux = flux

    NN = n_elements(newflux)

    ;- NN*cadence = total TIME covered by input signal (sec).
    frequency = findgen((NN/2)+1) / (NN*cadence)
    ;frequency = findgen(NN) / (NN*cadence)


    vv = FFT(newflux, -1) ; --> COMPLEX
    power = ABS(vv)^2     ; --> FLOAT
    ;power = 2*(ABS(vv)^2); "factor of 2 corrects the power"...???

    freq = reform(frequency[1:*])
    freq = [ freq, reverse(freq) ]

    ;freq = [ frequency, reverse(frequency) ]
    ;freq = reform(freq[1:*])

    ;power = reform(power[1:*])

    ;logPower = alog10(power)
    ;shiftedPower = logPower - max(logPower)

    mask = freq lt (1./float(cutoff_period))

    ;mask = REAL_PART(shiftedPower) gt -4

    maskedTransform = vv * mask
    inverseTransform = REAL_PART( $
        FFT( maskedTransform, /inverse) )

    return, inverseTransform

end

;- Keep period > 400 sec (freq < 2.5 mHz)

buffer = 1

;- pass to filter later...
cutoff_period = 400.

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


;-
;-  15 May 2020
;-  Don't really need to oplot background either, so skip this too.
;-


;+
;--- Overplot pre-flare background
;-
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

;=
;=====
;=============================================================================================================



;-
;- start here:
;-


;+
;--- Compute inverse transform
;-
inverseTransform = []
for cc = 0, 1 do begin
    inverseTransform = [ $
        [ inverseTransform ], $
        [ FILTER( flux[*,cc], A[cc].cadence, cutoff_period ) ] $
    ]
endfor




;=============================================================================================================
;=== Skip this too
;=

;+
;--- Overplot smoothed LC on plot of raw data (plt)
;-

;inverseTransform[*,0] = inverseTransform[*,0] + bg[0]
;inverseTransform[*,1] = inverseTransform[*,1] + bg[1]
for ii = 0, 1 do begin
plt2 = plot2( $
    xdata[*,ii], $
    ;inverseTransform[*,ii] - delt[ii], $
    inverseTransform[*,ii], $
    /overplot, $
    yticklen=0.010, $
    yminor=3, $
    linestyle=[1,'07FF'X], $
    name = 'FFT filter (400s)', $
    color='black' )
endfor

resolve_routine, 'legend2', /either
leg = LEGEND2( target=[plt, plt2, hor], /upperleft )
;-
ax = plt2[0].axes
ax[0].tickname = time[ax[0].tickvalues]
ax[3].showtext=1
;ax[1].tickinterval = 2.e7
ax[1].major = 5
ax[1].title = A[0].name + ' (DN s$^{-1}$)'
;ax[3].tickinterval = 0.2e8
ax[3].major = 5
ax[3].title = A[1].name + ' (DN s$^{-1}$)'
;-

save2, 'lc_filter'

STOP

;=
;=====
;=============================================================================================================



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
