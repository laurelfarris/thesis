;- Thu Nov 29 08:12:03 MST 2018
;-
;-
;- To Do:
;-   [] replace hardcoded cutoff for filter (in function "filter")
;-      used to create mask, and make new kw option, or something...
;-    (2/12/2020)
;-

pro CALC_FOURIER2, flux, cadence, frequency, power, fmax=fmax, fmin=fmin

;- This is mostly for power maps, not spectra:
;fcenter = 1./180
;bandwidth = 0.001
;fmin = fcenter - (bandwidth/2.)
;fmax = fcenter + (bandwidth/2.)


    sz = size( flux, /dimensions )
    if n_elements(sz) eq 1 then sz = reform(sz, sz[0], 1, /overwrite)

    result = fourier2( indgen(sz[0]), 24 )

    frequency = reform(result[0,*])
    if not keyword_set(fmin) then fmin = min(frequency)
    if not keyword_set(fmax) then fmax = max(frequency)

    ind = where(frequency ge fmin and frequency le fmax)
    frequency = frequency[ind]

    power = fltarr( n_elements(frequency), sz[1] )
    for ii = 0, sz[1]-1 do begin
        result = fourier2( flux[*,ii], 24 )
        power[*,ii] = (reform(result[1,*]))[ind]

        ;frequency = frequency[ind]
        ;power = power[ind]

    endfor
end

;- 21 May 2019
;- The function "calc_fourier2" defined above was copied from a
;-  routine also called filter.pro, but not the same as function
;-  defined below... no idea where the above code came from.

;- ML code:
;CALC_FOURIER2, A[0].flux, 24, frequency, power
;threshold = 400 ;- Remove variations on timescales less than this? Or greater?


;----------------------------------------------------------------------------------


;- See comp book p. 99-103
;-  and Enotes -- "Detrending | FFT filter", "light curves - detrended"

;- Thu Nov 29 08:12:03 MST 2018

;The Fast Fourier Transform (FFT) is used to transform an image from the
;spatial domain to the frequency domain, most commonly to reduce background
;noise from the image...
;* Perform a forward FFT to transform the image to the frequency domain
;* Compute a power spectrum and determine threshold to filter out noise
;* Apply a mask to the FFT-transformed image
;* Perform an inverse FFT to transform the image back to the spatial domain

;And in normal mode this is the same (insert date at current position):
;"=strftime("%F")<CR>P
;2018-11-29

function FILTER, flux, cadence


    ;- NOTE: if flux is changed here, it will be changed at ML!

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

    ;- Want to keep period GT 400 seconds
    ;-  aka, frequency LT 1./400 seconds (0.0025 Hz = 2.5 mHz)

    mask = freq lt 0.0025
    ;mask = REAL_PART(shiftedPower) gt -4

    maskedTransform = vv * mask
    inverseTransform = REAL_PART( $
        FFT( maskedTransform, /inverse) )

    return, inverseTransform

end

goto, start
start:;---------------------------------------------------------------------------------


;- 30 August 2019
;- 1-hour time segment (hardcoded...)
;t1_string = '01:30'
;t2_string = '02:30'
;t1_string = '12:30'
;t2_string = '13:30'
t1_string = '12:15'
t2_string = '13:15'

wx = 8.0
wy = 3.0


;------------------------------------------------------------------------------------


time = strmid(A[0].time,0,5)
    ; to keep consistent array sizes, plus already know that
    ; the same indices are returned for both channels :)
t1 = (where(time eq t1_string))[-1]
t2 = (where(time eq t2_string))[0]
ind = [t1:t2]
flux = A.flux[ind]

;flux = [ [flux], [A[cc].flux[ind] - min(A[cc].flux[ind])] ]

;- Plot original light curves
xdata = [ [ind], [ind] ]
;dw
resolve_routine, 'batch_plot', /either
plt = BATCH_PLOT( $
    xdata, flux, $
    xtickinterval=25, $
    ;color=[A[0].color, A[1].color], $
    color=A.color, $
    ;name=[A[0].name, A[1].name], $
    name=A.name, $
    wx=wx, wy=wy, $
    yticklen=0.010, $
    stairstep=1, $
    buffer=0 )


delt = [ min(flux[*,0]), (min(flux[*,1])-1.e7) ]
resolve_routine, 'shift_ydata', /either
SHIFT_YDATA, plt, delt=delt

;- Overplot pre-flare background
background = mean(A.flux[120:259], dim=1) - delt

for jj = 0, 1 do begin
    hor = plot2( $
        plt[0].xrange, $
        [ background[jj], background[jj] ], $
        /overplot, $
        linestyle=[1, '1111'X], $
        name = 'Background' )
endfor

inverseTransform = []
for cc = 0, 1 do begin
    inverseTransform = [ [inverseTransform], $
        [FILTER(flux[*,cc], A[cc].cadence)] ]
endfor


;----
;- overplot smoothed LC on top of raw data (plt)

;inverseTransform[*,0] = inverseTransform[*,0] + bg[0]
;inverseTransform[*,1] = inverseTransform[*,1] + bg[1]
for ii = 0, 1 do begin
plt2 = plot2( $
    xdata[*,ii], $
    inverseTransform[*,ii] - delt[ii], $
    ;thick=1.0, $
    /overplot, $
    yticklen=0.010, $
    yminor=3, $
    linestyle=[1,'07FF'X], $
    name = 'FFT filter (400s)', $
    color='black' )
endfor

resolve_routine, 'legend2', /either
leg = LEGEND2( $
    target=[plt, plt2, hor], $
    ;sample_width=0.13*wy, $
    /upperleft )


ax = plt2[0].axes
ax[0].tickname = time[ax[0].tickvalues]
ax[3].showtext=1

;ax[1].tickinterval = 2.e7
ax[1].major = 5
ax[1].title = A[0].name + ' (DN s$^{-1}$)'
;ax[3].tickinterval = 0.2e8
ax[3].major = 5
ax[3].title = A[1].name + ' (DN s$^{-1}$)'

;save2, 'detrendedLC'
;- bad file name... should START with "lc",
;-  plus curves aren't actually detrended yet... (10 May 2019)

;save2, 'lc_filter'
;-  Better file name


;dw

;----
;- new plot window with detrended light curves
;-   (2nd window, even though variable is plt3... confusing at first b/c
;-    assumed there should be 3 windows... )
;-

detrended = flux[2:*,*] - inverseTransform[1:*,*]
;help, xdata
;help, detrended

plt3 = BATCH_PLOT( $
    ;ind, $
    xdata[2:*,*], $   ;- xdata defined above as [ [ind], [ind] ] so dimensions match ydata.
    detrended, $
    stairstep=1, $
    ;ytickvalues=[-1.e6, 0, 1e6], $
    ;ytickvalues=[0.0], $
    ;overplot = 1<cc, $
    title = 'Detrended', $
    ;color=['dark orange', 'blue'], $
    color=A.color, $
    wx=wx, wy=wy, $
    left = 0.75, right=0.25, $
    ;thick = 2.0, $
    buffer=0)

;save2, 'lc_detrended'

;plt3 = plot2( xdata[*,0], detrended[*,0], buffer=0 )
;plt3 = plot2( xdata[*,1], detrended[*,1], /overplot, color='red' )


;hor = plot2( $
;    plt3[0].xrange, [0.0, 0.0], /overplot, linestyle=[1, '5555'X] )

;- Compare results from fourier2 (calc_fourier2) to
;-  final forms of freq and power above.



;threshold = 400 ;- Remove variations on timescales less than this? Or greater?
;- --> less... aka removing frequencies greater than this: setting fmax.



;power_filtered = fltarr(n_elements([z1:z2]))
;help, power_filtered

;flux_filtered = real_part( FFT( power_filtered, /inverse, /center ) )

;resolve_routine, 'batch_plot', /either
;dw
;plt = BATCH_PLOT( indgen(374), flux_filtered, buffer=1)
;save2, 'test'




;- Power spectra

;resolve_routine, 'calc_fourier2', /either
;CALC_FOURIER2, flux, 24, frequency, power
;CALC_FOURIER2, detrended, 24, frequency2, power2

;resolve_routine, 'plot_spectra', /either
;plt = PLOT_SPECTRA( $
    ;frequency, shiftedPower[0:(NN/2)], $
;    [ [frequency], [frequency2] ], $
;    [ [power], [power2] ], $
;    wx=8.0, wy=3.0, $
;    ylog=1, yminor=4, $
;    color=['dark orange', 'blue'], $
;    thick = [3.0, 2.0], $
;    linestyle=[0, 5], $
    ;thick=2.0, $
    ;ytickinterval=1.0, $
    ;ytickformat='(F0.1)', $
;    name=['FFT(flux) power', 'FFT(detrended) power'], $
;    buffer=1 )

end
