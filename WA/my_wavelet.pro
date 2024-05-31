;+
;-
;- LAST MODIFIED:
;-   29 May 2024
;-
;- ROUTINE:
;-   my_wavelet.pro
;-
;- EXTERNAL SUBROUTINES:
;-   SDBWAVE.PRO
;-   SDBWAVE2.PRO
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
;-
;-
;- TO DO:
;-   [] Remove "GOTO" & START: statements at beginning and
;-        replace w/ something more sophisticated
;-   []
;-   []
;-
;- KNOWN BUGS:
;-
;- AUTHOR:
;-   Laurel Farris
;-
;- See notes in:
;-   • @coding (2020--2024), p. 126, ...
;-   • UL comp #1, p. 103-109
;-   • 
;-   • Enotes "Detrending | FFT filter", "light curves - detrended"
;-   • 


;+
;-
;goto, start
;start:;-------------------------------------------------------------------------------

;- NOTE: need to run filter.pro first ( IDL> .run filter )
;-   to get detrended signal.
;-  Variable "detrended" is input curve for sdbwave2.pro

cc = 0



;- 29 May 2024
detrended = InverseTransform
;-    .... I guess?


resolve_routine, 'sdbwave', /either
SDBWAVE, detrended[*,cc], short = 50, long = 2000, $
    ;/fast, $
    /cone, ylog=1, delt=A[cc].cadence
;- Unclear what kw "fast" is for, but skips call to randomwave...

stop

time = strmid(A[cc].time, 0, 5)
;ti = (where( time eq '01:30' ))[0]
;tf = (where( time eq '02:30' ))[0]

dw
;- Calling sequence, with default values commented
resolve_routine, 'axis2', /is_function
resolve_routine, 'sdbwave2', /either

SDBWAVE2, $
    ;A[cc].flux[ti:tf], $
    detrended[*,cc], $
    short = 50, long = 2000, $
    ylog=1, $
    ;xtickname = time[ti:tf], $
    ;rgb_table=4, $
    rgb_table=20, $
    color=A[cc].color, $
    lthick = 0.5, $
    ;line_color='white', $
    line_color='black', $
    /fast, $ ; don't know what this does, but skips call to randomwave...
    /cone, $
    delt=A[cc].cadence, $ ;(1*10.), $
    title='a) ' + A[cc].name + ' time series (detrended)'

;- max value for low-pass filter
;- significance (=0.99)

filename = 'aia' + A[cc].channel + 'wavelet'
print, ''
print, filename + '.pdf'
print, ''
stop
;save2, filename, /stamp

end
