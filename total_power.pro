;; Last modified:   15 May 2018 21:25:02




; Calculate power across entire time series for integrated flux.
; No maps required.

; Input:    flux
;           cadence

; Harcoded:
;           dz = sample length for fourier2.pro (data units)
;           frequency bandpass:
;             f_min = minimum frequency
;             f_max = maximum frequency
;           z_start = starting indices

; Output:   Returns power as function of time


; To do:    Add test codes
;           Make option/kws to input hardcoded stuff


function TOTAL_POWER, flux, cadence, _EXTRA=e


    dz = 64

    ; Calculate possible frequencies for dz.
    f_min = 0.005
    f_max = 0.006
    frequency = reform( (fourier2( $
        indgen(dz), cadence ))[0,*] )
    ind = where( frequency ge f_min AND frequency le f_max )


    ; start indices
    z_start = [0 : n_elements(power)-dz]

    ; Power at each timestep, from integrated flux
    power = fltarr(n_elements(z_start))

    ; Calculate power for time series between each value of z and z+dz
    foreach z, z_start, i do begin

        result = fourier2( flux[z:z+dz-1], cadence, NORM=1, _EXTRA=e ) 

        ; MEAN power over frequency bandpass
        power[i] = MEAN( (reform(result[1,*]))[ind] )

    endforeach
    return, power
end



power = TOTAL_POWER( A[0].flux, A[0].cadence )
aia1600 = create_struct( aia1600, 'power', power )

power = TOTAL_POWER( A[1].flux, A[1].cadence )
aia1700 = create_struct( aia1700, 'power', power )

A = [ aia1600, aia1700 ]




end
