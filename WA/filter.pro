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
;-
;- TO DO:
;-
;-   [] replace hardcoded cutoff for filter (in function "filter")
;-      used to create mask, and make new kw option, or something...
;- -- (2/12/2020)
;-
;-   [] Rename "filter.pro" function? Called in "main_filter.pro" with the form
;-         > FILTER( flux, cadence, cutoff_period )
;-      looks like a canned IDL routine, haven't looked at my own codes in a long time,
;-      searched around the internet for source material
;-      before realizing I wrote this function myself.. located in current directory.
;- -- (2/19/2024)
;-
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
