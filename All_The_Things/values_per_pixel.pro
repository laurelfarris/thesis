

; compare results like FTs on integrated emisssion vs. those from
; emission per pixel, and the resulting values of power.

;- 25 April 2019
;- Pretty sure Power goes as Flux^2...
;-  doubt I'll need this again.



pro old_stuff

    ;- 02 November 2018 - comparing output from FT( flux/N ) to FT(flux)/N.
    N = 500.*330.
    result = fourier2( A[0].flux/N, 24 )
    frequency = reform( result[0,*] )
    power1 = reform( result[1,*] )
    result = fourier2( A[0].flux, 24 )
    power2 = (reform( result[1,*] ))/N
    win = window(/buffer)
    p = plot2( frequency, power1, /current, layout=[1,1,1], margin=0.1, ylog=1 )
    p = plot2( frequency, power2, /overplot, color='blue', ylog=1 )


    ; 24 September 2018
    ;- dz = (30 min * 60 sec/min) / cadence
    ;dz = (30. * 60.) / 24.
    times = ['12:30', '01:30', '02:30', '03:30']
    titles = ['Before', 'During', 'After']

    ;- date?
    fmin = 0.0025
    fmax = 0.02
    ;fmin = 1./400 ; 2.5 mHz
    ;fmax = 1./50 ;  20 mHz
    ;f = [ 1000./180, 1000./(2.*180) ]


    ;- From a while ago... apparently already tested div. by n_pix,
    ;-    or something similar:
    for ii = 0, n_elements(times)-2 do begin
        p = objarr(3)
        for cc = 0, n_elements(p)-1 do begin
            t1 = where( A[cc].time eq times[ii] )
            t2 = where( A[cc].time eq times[ii+1] ) - 1
            n_pixels = 330.*500.
            flux = A[cc].flux[t1:t2]
            flux = (A[cc].flux[t1:t2])/n_pixels
            result = fourier2( flux, A[cc].cadence, norm=0 )
            frequency = reform( result[0,*] )
            power = reform( result[1,*] )
            power = (reform( result[1,*] )) / n_pixels
            p[cc] = PLOT_POWER_SPECTRUM_subroutine( $
                frequency, power, $
                fmin=fmin, fmax=fmax, $
                overplot = cc<1, $
                layout = [cols, rows, ii+1], $
                color=A[cc].color, $
                name=A[cc].name )
        endfor
    endfor

end



plt = plot_spectra( frequency, power, period=[180] )



end
