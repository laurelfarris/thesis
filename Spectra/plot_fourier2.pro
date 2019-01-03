;; Last modified:   04 October 2017 16:05:13

;; Subroutines:     fourier2 --> returns "Array containing power and phase
;;                                              at each frequency"

;; Purpose:         Run fourier2 through time on each pair of 2D pixel coordinates
;;                  and return 2D power image


;; Inputs:          cube = data cube time series (i.e. same dt between each image).
;;                  delt = time between each image, in seconds.



pro plot_fourier2, flux, delt, $
    frequency, power_spectrum, period, $
    seconds=seconds, minutes=minutes, $
    make_plot=make_plot


    ;; "Array containing power and phase at each frequency"
    result = Fourier2( flux, delt, /norm )

    frequency = result[0,*]
    power_spectrum = result[1,*]
    phase = result[2,*]
    amplitude = result[3,*]

    if keyword_set( minutes ) then period = (1./frequency)/60.
    if keyword_set( seconds ) then period = 1./frequency

    if keyword_set( make_plot ) then begin
        ytitle=["frequency", "power spectrum", "phase", "amplitude"]

        w = window( dimensions=[700, 700] )

        for i = 0, 3 do begin
            p = plot( $
                result[i,*], layout=[2,2,i+1], /current, $
                ytitle=ytitle[i], xtitle="index of frequencies")
        endfor
    endif


end
