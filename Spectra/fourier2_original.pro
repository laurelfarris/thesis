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
;KNOWN BUGS     Be v. careful if passing a time series which is B times aslong
;               as the original time series( possibly to help filtering in
;               digifilt.pro). For normalised power spectra this means the power
;               has to be devided by B. For unnormalised power spectra this
;               means the significance level has to be multiplied by B.
;               As with all Fourier analysis, be carefful with spectral leakags and
;               the picket fence effect.
;-


FUNCTION Fourier2, Flux, Delt, $
         rad=rad, pad=pad, norm=norm, signif=signif, display=display

    ;subtract the mean
    newflux=flux-(moment(flux))(0)
    N = N_ELEMENTS(newflux)

    ;start padding
    ;don't like this padding, as it affects the freuquency value
    ;(because the frequency resolution has now changed)
    ;Padding to the nearest power of 2 speeds up the FFT
    ;but has an effect on the fourier spectrum
    ;always check fourier spectrum of non-padded spectrum and compare

    IF NOT KEYWORD_SET(pad) THEN GOTO, skip_pad
    base2 = FIX(ALOG(N)/ALOG(2)) +1   ; power of 2 nearest to N
    IF (N EQ 2.^(base2-1)) THEN GOTO, skip_pad
    ;pad with extra zeroes, up to power of 2
    newflux = [newflux, FLTARR(2L^(base2) - N)]
    PRINT,'Padded '+ARR2STR(N,/trim)+ $
        ' data points with '+$
        ARR2STR((2L^(base2) - N),/trim)+' zeros.'
    PRINT,'**RECOMMEND checking against fourier spectrum of non padded time series**'

    ;end of padding
    skip_pad:
    N = N_ELEMENTS(newflux)

    ;make the frequency array
    Freq = FINDGEN(N/2+1) / (N*Delt)


    ;the -1 ensures a forward FFT
    ;the fourier transform is the of the form a(w) + ib(w)
    V = FFT(newflux,-1)

    ;To convert your FFT to power, take the absolute value (i.e. sqrt(a^2 plus
    ;b^2)) of your FFT and square it. Also, since we are taking the FFT of a
    ;real timeseries (not complex), then the second half of the FFT is just a
    ;duplicate (in reverse order) of the first half. Throw away the duplicate
    ;portion.The factor of 2 corrects the power. Strictly speaking the 2nd half
    ;of the FFT should be folded back onto the first half

    ;NB IDL has a quirky way or calculating FFT. The resulting power spectrum
    ;actually goes (in terms of frequency) from 0 to +Nq, then from -Ny back up
    ;to zero.

    Power = 2*(ABS(V)^2)

    ;calculate amplitude
    Amplitude = 2*(ABS(v))


    ;do not use the zero-eth element -it will just be equal to the mean
    ;which has been set to zero anyway
    Freq = reform(freq(1:*))
    Power = reform(Power(1:n/2))
    Amplitude = reform(Amplitude(1:n/2))

    ;By Parseval's Theorem, the variance of a time series should be equal to the
    ;total of its power spectrum (this is just conservation of energy). Check
    ;that you have the correct normalization for your Power Spectrum by
    ;comparing the total of your spectrum (with N/2 points) with the variance
    ;print,'Variance of time series = '+ARR2STR((moment(newflux))(1),/trim)
    ;print,'Total of Power Spectrum = '+ARR2STR(Total(Power),/trim)

    ;Calculate the the phase for each frequeny. In simple terms this is just
    ;arctan( b(w)/a(w) )
    imag = IMAGINARY(V)
    amp  = DOUBLE(V)
    imag = imag(1:n/2)
    amp  = amp(1:n/2)

    ;this is very important stuff so pay attention
    ;the atan function returns two different ranges of values
    ;for res=atan(x,y) , values in the range of +pi to -pi
    ;for res=atan(x/y) , values in the range of +pi/2 to -pi/2
    ;can also use using arctan (/usr/local/ssw/gen/idl/util/arctan.pro) copied
    ;to /idl/vtt/jma
    ;arctan(y,x,res,res_deg) ,res in range of 0 to 2pi
    ;                    ,res_deg in range of 0 to 360 degrees
    ;from inspection of the source code it is obvious that arctan calculates
    ;which value to take by using the quadrant CAST idea.
    ;atan will do the same for atan(x,y) mode

    Phase = ATAN(imag,amp)
    ;gives phase between -pi and pi
    ;convert to degrees by default
    IF NOT KEYWORD_SET(rad) THEN phase=phase * (180./!pi )

    sig_lvl=0.
    IF KEYWORD_SET(signif) THEN conf = signif ELSE conf=0.95
        sig_lvl=signif_conf(newflux,conf)

    IF KEYWORD_SET(norm) THEN BEGIN
        var=(MOMENT(newflux))(1)
    power=power * N / var
        sig_lvl = sig_lvl * N / var
    ;PRINT,'White noise has an expectation value of 1'
    ENDIF

    IF sig_lvl NE 0 AND KEYWORD_SET(display) THEN $
      PRINT,'Confidence level at '+ $
        ARR2STR(FIX(conf*100),/trim)+'% is: '+ARR2STR(sig_lvl,/trim)

    IF KEYWORD_SET(display) THEN BEGIN
        PLOT,freq,power,psym=2
        OPLOT,freq,power,line=2
        horline,sig_lvl
    ENDIF

    ;the final output is then an array containing the power and phase at each
    ;frequency
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
