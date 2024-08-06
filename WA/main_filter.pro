;+
;-
;- LAST MODIFIED:
;-
;-   31 May 2024
;-     • changed from ML to subroutine
;-     • re-named file to "applyFourierFilter.pro" (also name of function created today)
;-          (Call to function FILTER( ... ) looks like a canned IDL routine.
;-            Took a prolonged internet search for some source material 
;-            before I remembered this is a function I wrote myself, located under WA/ in "work" dir.)
;-
;-   05 June 2020
;-     • ?
;-
;- ROUTINE:
;-   main_filter.pro
;-
;- PURPOSE:
;-    compute detrended time series data array
;-
;- EXTERNAL SUBROUTINES:
;-   applyFourierFilter.pro (function)
;-
;- USEAGE:
;-   1) define/specify cutoff period & input signal array at ML
;-   2) define InverseTranform variable by
;-      passing cutoff & flux in call to applyFourierFilter function (defined in "applyFourierFilter.pro")
;-      which applies Fourier filter at specified cutoff period
;-      to extract desired frequency range, and then inverse tranform back to time domain.
;-
;- OUTPUT:
;-   detrended time series array
;-    = transformed back to time domain after filtering at specified cutoff
;-    
;- TO DO:
;-   [] Remove "GOTO" & START: statements (above WA plotting code);
;-        replace w/ something more sophisticated
;-
;- AUTHOR:
;-   Laurel Farris
;-
;-     See notes in:
;-       • @coding (2020--2024), p. 126, ...
;-       • UL comp #1, p. 103-109
;-       • Enotes "Detrending | FFT filter", "light curves - detrended"
;-


;- IDL> @main

;+
;- Keep period > 400 sec (freq < 2.5 mHz) & pass to FILTER function below
cutoff_period = 400.


;+
;- Define flux
flux = A.flux
;-   NOTE: input variable may not always take the form of "A.flux", e.g. if I
;-    wanted to test by directly running read_sdo and bypassing struc_aia.pro.
;-    Structure "A" would not exist. Or maybe structure is called "H" because it's
;-    HMI data..
;-  Using codes entirely at ML to "hardcode" values that often change, and call
;-   external routines that are NOT hardcoded. Any code that stays the same for
;-   all types of data, or all flares, etc. should be in an external subroutine.


;+
;- Compute inverse transform

resolve_routine, 'applyFourierFilter', /IS_FUNCTION

inverseTransform = []

for cc = 0, 1 do begin
    inverseTransform = [ $
        [ inverseTransform ], $
        [ applyFourierFilter( $
            flux[*,cc], $
            A[cc].cadence, $
            cutoff_period $
        ) ] $
    ]
endfor


;+
;- Generate wavelet plots

;- • Pass detrended LCs (inverse transform computed above) to sdbwave2.pro


;======================================================================================================
;=
;= 29 May 2024:
;=   merged with "my_wavelet.pro", another ML code written to create WA plots
;=    by passing detrended data computed above in call to sdbwave2.pro
;=       (calls sdbwave.pro first, probably to compare plots and make sure my
;=          IDL graphic modifications still produce correct figures).
;=



;goto, start
;start:;-------------------------------------------------------------------------------

;- NOTE: need to run filter.pro first ( IDL> .run filter )
;-   to get detrended signal.
;-  Variable "detrended" is input curve for sdbwave2.pro

cc = 0


;- 29 May 2024
detrended = InverseTransform
;-    .... I guess?


;- Call ORIGINAL procedure... I guess to compare outputu plots??
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
    ;sigg=0.99 ;- desired confience level (default = 99%)  -- 05 August 2024
    ;          ;-  sigg is input to wavelet.pro
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

;end

;=
;======================================================================================================


end
