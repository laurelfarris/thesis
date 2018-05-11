
; Editing this to add my own comments/questions and fix the indentation,
; change parens to brackets when used with array indices, and any other little
; things that make my eye twitch.
; -Laurel (2018-05-08)


;+
; ROUTINE:      Fourier2
;
; PURPOSE:      To calculate the phase and power spectrum
;
; USEAGE:       result = Fourier (y1,delt)
;
; INPUT:
;               Y1          Input time series
;               delt        time seperation (cadence)
;
; KEYWORDs:     rad         stops the phase defaulting to degrees
;               pad         pads the time series with zeros, up to the nearest power of 2
;               norm        normalises the power spectrum
;               signif      calculates significance level
;               display     displays the power spectrum
;
; OUTPUT:
;               result     The power and phase spectrum
;
; TO DO:        i)could introduce a keyword, which inputs a frequency, then
;               calculates the longest
;               portion of the original flux to use to have a frequency exactly
;               at this frequency.
;               this would just be (Nyquist/(length /2) EQ chosen frequency) and
;               then maximise length
;               ii) fisher significance test
;               iii)a shut up keyword would be handy
;
; AUTHOR:       V1.0 Based on pgfft by Peter T. Gallagher, Mar. '99, which was
;               furthur altered by R.T. James McAteer & David R. Williams
;               according to
;               http://cires.colorado.edu/geo_data_anal/assign/assign4.html
;               Oct' 01
;
;               V2.0 R.T.James McAteer & David R. Williams , QUB, Jan '02
;               fourier.pro which also calculates the phase and creates a 3
;               column array of frequency, power and phase
;
;               V3.0 Fourier2.pro R.T.James McAteer, QUB, Nov '02
;               introduced ,/pad,/norm,/display and ,/signif keywords
;
;KNOWN BUGS     Be v. careful if passing a time series which is B times as long
;               as the original time series (possibly to help filtering in
;               digifilt.pro). For normalised power spectra this means the power
;               has to be devided by B. For unnormalised power spectra this
;               means the significance level has to be multiplied by B.
;               As with all Fourier analysis, be careful with spectral leakage and
;               the picket fence effect.

;               WTF is B??? Is this meant for the user or the writer?
;-


FUNCTION Fourier2, Flux, Delt, $
         rad=rad, pad=pad, norm=norm, signif=signif, display=display

    ;subtract the mean
    newflux=flux-(moment(flux))[0]
    N = N_ELEMENTS(newflux)

    ;start padding
    ;don't like this padding, as it affects the frequency value
    ;(because the frequency resolution has now changed)
    ;Padding to the nearest power of 2 speeds up the FFT
    ;but has an effect on the fourier spectrum
    ;always check fourier spectrum of non-padded spectrum and compare

    IF NOT KEYWORD_SET(pad) THEN GOTO, skip_pad

    ; power of 2 nearest to N
    base2 = FIX(ALOG(N)/ALOG(2)) + 1

    ;; if /PAD, but N is already a power of 2, then skip padding.
    IF (N EQ 2.^(base2-1)) THEN GOTO, skip_pad

    ;pad with extra zeroes, up to power of 2
    newflux = [newflux, FLTARR(2L^(base2) - N)]
    PRINT,'Padded ' + ARR2STR(N,/trim) + ' data points with ' + $
        ARR2STR((2L^(base2) - N),/trim)+' zeros.'
    PRINT,'**RECOMMEND checking against fourier spectrum of non padded time series**'

    ;end of padding
    skip_pad:

    ;; This line should probably be before skip_pad:, but whatev
    N = N_ELEMENTS(newflux)

    ;make the frequency array
    freq = FINDGEN( (N/2) + 1 ) / (N*Delt)

    ;the -1 ensures a forward FFT
    ;the fourier transform is the of the form a(w) + ib(w)
    V = FFT(newflux,-1)
    ;; V? Not a fan of this choice of variable name...

    ;To convert your FFT to power, take the absolute value (i.e. sqrt(a^2 plus
    ;b^2)) of your FFT and square it. Also, since we are taking the FFT of a
    ;real timeseries (not complex), then the second half of the FFT is just a
    ;duplicate (in reverse order) of the first half. Throw away the duplicate
    ;portion. The factor of 2 corrects the power. Strictly speaking the 2nd half
    ;of the FFT should be folded back onto the first half

    ;NB IDL has a quirky way or calculating FFT. The resulting power spectrum
    ;actually goes (in terms of frequency) from 0 to +Nq, then from -Ny back up
    ;to zero.
    ;; Are Nq and Ny supposed to be the same thing? Probably both Nyquist freq.

    power = 2*(ABS(V)^2)

    ;calculate amplitude
    amplitude = 2*(ABS(V))

    ;; Just condensing arrays here - not important.
    ; Exclue the 0th element -
    ;  it will just be equal to the mean, which has been set to 0 anyway
    freq = reform(freq[1:*])
    power = reform(power[1:N/2])
    amplitude = reform(amplitude[1:N/2])

    ;By Parseval's Theorem, the variance of a time series should be equal to the
    ;total of its power spectrum (this is just conservation of energy).

    ;Check that you have the correct normalization for your Power Spectrum by
    ;comparing the total of your spectrum (with N/2 points) with the variance.

    ;print,'Variance of time series = '+ARR2STR((moment(newflux))(1),/trim)
    ;print,'Total of Power Spectrum = '+ARR2STR(Total(Power),/trim)

    ;Calculate the the phase for each frequency.
    ;In simple terms this is just arctan( b(w)/a(w) ).
    imag = IMAGINARY(V)
    imag = imag[1:N/2]
    amp  = DOUBLE(V)
    amp  = amp[1:N/2]

    ;this is very important stuff so pay attention
    ;the atan function returns two different ranges of values
    ;for res=atan(x,y), values in the range of +pi to -pi
    ;for res=atan(x/y), values in the range of +pi/2 to -pi/2
    ;can also use using arctan (/usr/local/ssw/gen/idl/util/arctan.pro) copied
    ;to /idl/vtt/jma
    ;arctan(y,x,res,res_deg) ,res in range of 0 to 2pi
    ;                    ,res_deg in range of 0 to 360 degrees
    ;from inspection of the source code it is obvious that arctan calculates
    ;which value to take by using the quadrant CAST idea.
    ;atan will do the same for atan(x,y) mode

    ;; From pdf on Normalization of FTs, phase spectrum is calculated
    ;; using tan^{-1}... so must be a general thing.

    ; phase between -pi and pi
    phase = ATAN(imag,amp)

    ;convert to degrees by default
    IF NOT KEYWORD_SET(rad) THEN phase=phase * (180./!pi )

    sig_lvl=0.

    IF KEYWORD_SET(signif) THEN conf = signif ELSE conf=0.95

    sig_lvl=signif_conf(newflux,conf)

    ;; newflux = flux - (moment(flux))[0] ; At beginning... check for changes.
    ;; MOMENT(x) --> mean, variance, skew, kurtosis
    ;; N = n_elements(newflux)

    IF KEYWORD_SET(norm) THEN BEGIN

        ; variance
        var = (MOMENT(newflux))[1]

        ;; Multiply each element in power array (at each possible frequency)
        ;; by the length of the input time series, then divide by the variance.
        power = power * N / var

        ;; same modification as made to power in previous line
        sig_lvl = sig_lvl * N / var

        ;PRINT,'White noise has an expectation value of 1'

    ENDIF

    IF sig_lvl NE 0 AND KEYWORD_SET(display) THEN $
        PRINT,'Confidence level at ' + $
        ARR2STR(FIX(conf*100),/trim) + '% is: ' + ARR2STR(sig_lvl,/trim)

    ;; Understand everything from this point on.

    IF KEYWORD_SET(display) THEN BEGIN
        PLOT,freq,power,psym=2
        OPLOT,freq,power,line=2
        horline,sig_lvl
    ENDIF

    ; final output is an array containing the power and phase at each frequency
    Result = FLTARR(4,N_ELEMENTS(Power))
    Result(0,*) = Freq
    Result(1,*) = Power
    Result(2,*) = Phase
    Result(3,*) = Amplitude
    PRINT,'Result(0,*) is frequency'
    PRINT,'Result(1,*) is the power spectrum'
    PRINT,'Result(2,*) is the phase'

    RETURN, Result

END
