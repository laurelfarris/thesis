;+ 
;- LAST MODIFIED:
;-
;-
;---------------------------------------------------------------------------------------------------------------         
;-   09 July 2024 --
;-     Copied the following from CRAFT notes (formerly Evernote) "FFT filter | detrending":
;-         
;-         
;-        ;
;-        ffTransform = FFT( data, /CENTER )
;-        powerSpectrum = ABS(ffTransform)^2
;-        scaledPowerSpect = ALOG10(powerSpectrum)
;-        ;
;-        ; Scale the power spectrum to make its maximum value equal to 0.
;-        scaledPS0 = scaledPowerSpect - MAX(scaledPowerSpect)
;-        ;
;-        ; Apply a mask to remove values less than -7, just below the peak of the power spectrum. 
;-        ; The data type of the array returned by the FFT function is complex, 
;-        ;   which contains real and imaginary parts.
;-        ; In image processing, we are more concerned with the 
;-        ; amplitude, which is the real part. 
;-        ; The amplitude is the only part represented in the surface and 
;-        ;   displays the results of the transformation.
;-        ;
;-        mask = REAL_PART(scaledPS0) GT -7
;-        ;
;-        ; Apply the mask to the transform to exclude the noise.
;-        maskedTransform = ffTransform * mask
;-        ;
;-        ; Perform an inverse FFT to the masked transform, to transform it back to the spatial domain.
;-        inverseTransform = REAL_PART( FFT( maskedTransform, /INVERSE, /CENTER) )
;-        ;
;-         
;-         
;---------------------------------------------------------------------------------------------------------------         
;-
;-   31 May 2024
;-     • re-named file to "applyFourierFilter.pro" instead of "filter.pro"
;-         (seems more descriptive, less ambiguous)
;-
;-   15 May 2020
;-     • Added arg "cutoff_period" to function call.
;-
;- ROUTINE:
;-   applyFourierFilter.pro
;-
;- EXTERNAL SUBROUTINES:
;-
;-
;- PURPOSE:
;-   specify cutoff period and input signal for FFT below at ML
;-    then define InverseTranform variable by passing
;-    cutoff period and flux in call to FILTER function (defined in "filter.pro")

;-     1. Perform FFT to transform flux from time domain to frequency domain.
;-        "Compute a power spectrum and determine threshold to filter out noise"
;-         --> this should probably be determined independently, then set
;-             arg "cutoff_period" in call to filter.pro
;-     2. Apply mask to the FFT-transformed image
;-        --> removes variations with periods shorter than the cutoff.
;-     3. Perform inverse FFT to transform flux back to time domain.
;-
;-   ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★
;-     => FFT( array, -1)
;-         where -1 argument means ... ??
;-   ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★
;-
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
;-
;- 09 July 2024
;-   [] Add kw to specify HIGH or LOW pass filter in addition to threshold/cutoff period (frequency?)
;-
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


function applyFourierFilter, flux, cadence, cutoff_period


    ;- 1) Apply FFT to input signal (flux) at specified threshold (cutoff_period)


    ;- ★ ★ ★ ★ ★ ★  IMPORTANT!!! ★ ★ ★ ★ ★ ★
    ;-    Separate variable "newflux" defined b/c modifying variables passed to subroutine
    ;- to avoid changing original value of 
    ;-     "flux" variable at ML when modified value is passed back to caller.
    ;newflux = flux-(moment(flux))[0]
    newflux = flux


    ;== Generate frequency array

    NN = n_elements(newflux)
    ;frequency = findgen( NN    )      / (NN*cadence)
    frequency  = findgen( (NN/2 ) +1 ) / (NN*cadence)
    ;    where NN x cadence = total duration of input signal (seconds)
    ; 
    ; 09 July 2024 --
    ;   Why is frequency array computed like this? Should automatically be generated,
    ;     at least when using fourier2.pro
    ; ==>> After reviewing fourier2.pro, the frequency array is generated the same way...
    ;   IDL's FFT function just returns a single complex array for power (I think)
    ;


    ;== Compute FFT

    ; FFT syntax from geospatial reference page (https://www.nv5geospatialsoftware.com/docs/FFT.html):
    ;   Result = FFT( Array [, Direction] [, /CENTER] [, DIMENSION=scalar] [, /DOUBLE] [, /INVERSE] [, /OVERWRITE] )
    ;    • direction of transform = NEGATIVE scaler for the FORWARD transform (default)
    ;                              = POSITIVE scaler for the INVERSE transform

    vv = FFT(newflux, -1) ; --> COMPLEX
    ;   -1 arg indicates FORWARD transform as opposed to inverse... I think, based on FFT syntax copied above
    ;
    ; fourier2.pro:
    ;   V = FFT(newflux, -1) ; -1 arg set to "ensure a forward fft"
    ;  Returns 4xN array for frequency array w/ N elements


    power = ABS(vv)^2     ; --> FLOAT
    ;power = 2*(ABS(vv)^2); "factor of 2 corrects the power"...???

    freq = reform(frequency[1:*])
    freq = [ freq, reverse(freq) ]

    ;freq = [ frequency, reverse(frequency) ]
    ;freq = reform(freq[1:*])

    ;power = reform(power[1:*])

    ;logPower = alog10(power)
    ;shiftedPower = logPower - max(logPower)


    ;== Generate mask to use as filter
    ;
    mask = freq LT (1./float(cutoff_period)) ; LOW-pass filter
    ; mask = freq GT (1./float(cutoff_period)) ; HIGH-pass filter
    ;
    ;    1./float(cutoff_period) = 1/period ==> frequency
    ; => no kw to specify high or low pass filter in call to function...
    ;
    ; Array LT <value>
    ;    ==>> returns same size array with values = 0 or 1 to reflect if corresponding value
    ;          in Array is less than <value> (1) or NOT less than <value> (0).
    ;        Result is type INT by default, hence conversion to FLOAT above.
    ;   This explains multplying mask by arrays below, tho still have a bunch of 0's ...
    ;       maybe the READ_PART does something with this... I dunno.
    ;


    ;mask = REAL_PART(shiftedPower) gt -4


    ; mutliply transformed data, where vv = FFT(flux, ...)
    ; by MASK to extract only portions of each array that correspond to filtered frequencies
    maskedTransform = vv * mask
    ; 09 June 2024 --
    ;    could also do the following, without defined variable for vv:
    ;maskedTransform = FFT(newflux, -1) * mask
    ;    ... tho sometimes redundant variable definitions improve readability and clarity.. so whatev.
    

    ; compute INVERSE Fourier transform of extraction portion of the power spectrum ('maskedTransform')
    ;    by setting kw '/INVERSE' in call to FFT
    inverseTransform = REAL_PART( $
        FFT( maskedTransform, /inverse) )
        ;FFT( maskedTransform, +1 ) )
        ;  => Direction set to POSITIVE scaler computes INVERSE transform... should do the same thing.

    return, inverseTransform

end
