; Last modified:   05 June 2018

; Always give input in frequencies (Hz), e.g. vert = 1./[180,300]

; 29 June 2018
; comparing norm vs. not norm?

pro compare_power_time
    ; May 15, 2018
    ; /NORM vs. no norm
    ; Plotting P(t)

    ; This gives power 749 elements, but will only have values for 749 - 64.
    ; The rest will = 0.0
    ;power = fltarr(n_elements(A[0].flux))
    ;aia1600 = create_struct( aia1600, 'power', power )
    ;aia1700 = create_struct( aia1700, 'power', power )
    ;A = [ aia1600, aia1700 ]

    y1 = A[0].flux
    y2 = A[0].flux_norm
    struc = { $
        xdata : A[0].time, $
        ydata : [ [y1], [y1], [y2], [y2] ], $
        norm : [0,1,0,1], $
        title : [ $
            'flux; NORM=0', $
            'flux, NORM=1', $
            'flux_norm; NORM=0', $
            'flux_norm, NORM=1'] }

    ; Calculate possible frequencies for dz.
    frequency = (reform( fourier2( $
        indgen(dz), A[0].cadence, NORM=NORM )))[0,*]
    ind = where( frequency ge fmin AND frequency le fmax )

    ; Calculate power for time series between each value of z and z+dz
    dz = 64
    fmin = 0.005
    fmax = 0.006

    ; ydata
    power_total = fltarr( 4, n_elements(A[0].flux) )
    z_start = [0 : n_elements(power_total)-dz]

    ; Should have subroutine that does this...
    for j = 0, 3 do begin
        foreach z, z_start, i do begin
            input = struc.ydata[*,j]
            result = fourier2( input[z:z+dz-1], NORM=struc.norm[i], 24 )
            frequency = reform(result[0,*])

            ; MEAN power over frequency[ind] (freq. bandpass)
            ind = where( frequency ge fmin AND frequency le fmax )
            power = reform( result[1,*] )
            power_total[j,i] = MEAN( power[ind] )
        endforeach
    endfor
    p = objarr(4)
    for i = 0, 3 do $
        p[i] = plot2( struc.xdata, power_total[i,*], title=struc.title[i])
end
