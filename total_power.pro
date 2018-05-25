;; Last modified:   15 May 2018 21:25:02




; Initialize power array, to be calculated across entire time series
; for integrated flux.
; No maps required.


; Harcoded: frequency bandpass (f_min, f_max)
;           sample length (dz = 64)
;           starting indices (z_start = [ 0 : N-1 ])


; Still needs a lot of work.


function total_power, flux, cadence, norm=norm


    dz = 64
    z_start = [0 : n_elements(A[0].power)-dz]

    if not keyword_set(norm) then 

    ; Calculate possible frequencies for dz.
    f_min = 0.005
    f_max = 0.006
    frequency = (reform( fourier2( $
        indgen(dz), cadence, NORM=NORM )))[0,*] 
    ind = where( frequency ge f_min AND frequency le f_max )

    ; Calculate power for time series between each value of z and z+dz
    foreach z, z_start, i do begin

        result = fourier2( A[j].flux[z:z+dz-1], A[j].cadence, /NORM ) 
        power = reform( result[1,*] )

        ; MEAN power over frequency bandpass
        power[i] = MEAN( power[ind] )

    endforeach


    ; Return power (as function of time)
    return, power


end


pro blah, A
    ; Calculate power for time series between each value of z and z+dz
    dz = 64
    ;z = [0:680:5]
    z = [0:748-dz]
    for j = 0, 1 do begin
        foreach i, z do begin
            result = fourier2( A[j].flux[i:i+dz-1], 24. ) 
            ; TOTAL power over dz for frequency[ind]
            ; should be normalized (e.g. power/sec)
            A[j].power[i] = TOTAL( (reform( result[1,*] )) [ind])
        endforeach
    endfor
end



power = fltarr(n_elements(A[0].flux))
aia1600 = create_struct( aia1600, 'power', power )
aia1700 = create_struct( aia1700, 'power', power )
A = [ aia1600, aia1700 ]

end
