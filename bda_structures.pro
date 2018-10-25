

;- 01 October 2018


function BDA_structures, flux, cadence, obs_time
;- only input is what changed from one inst to the next

    ;--------------------------------------
    ;- Separate subroutine?
    start_times = [ '00:30', '01:00', '01:30', '02:00', '02:30', '03:00', '03:30' ]
    description = [ 'before', 'during', 'after' ]

    start_times = [ '00:30', '01:30', '02:30' ]
    description = [ 'before', 'during', 'after' ]

    ;  Can set a single dz or dT value? E.g. 30 minutes or 64 frames.
    ;  Would still need to set start times...

    time = strmid( obs_time, 0, 5 )

    ; Make sure this works, and returns array as expected:
    z_start = where( time eq start_times )

    dz = z_start[1] - z_start[0]
    n_freqs = 64 ; cheating - already figured this out
    ;--------------------------------------

    ;frequency = fltarr(n_freqs, 3)
    ;power = fltarr(n_freqs, 3)
    frequency = []
    power = []
    names = []

    for ii = 0, n_elements(start_times)-2 do begin

        ;z_start = (where( time eq start_times[ii]   ))[1]
        ;z_end =   (where( time eq start_times[ii+1] ))[0]
        z_start = z_start[ii]
        z_end = z_start + dz - 1
        result = CALC_FT( $
            flux[z_start:z_end], $
            cadence, $
            ;fmin=fmin, fmax=fmax, $
            norm=0 )

        frequency = [ [frequency], [result.frequency] ]
        power = [ [power], [result.power] ]
        ;frequency[*,ii] = result.frequency
        ;power[*,ii] = result.power

        ;- Use original observation times, NOT the desired times entered manually
        ;    into string array. Too easy for errors.
        names = [ [names], $
            [ time[z_start] + '-' + time[z_end] + ' (' + description[ii] + ')' ] $
            ]
    endfor


    struc = { $
        frequency : frequency, $
        power : power, $
        names : names }

    return, struc
end

cc = 0
aia1600 = BDA_structures( A[cc].flux, A[cc].cadence, A[cc].time )

cc = 1
aia1700 = BDA_structures( A[cc].flux, A[cc].cadence, A[cc].time )

struc = { aia1600:aia1600, aia1700:aia1700 }



end
