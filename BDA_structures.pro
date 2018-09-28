

;- 27 September 2018


function BDA_structures, flux, cadence, time
;- only input is what cahnged from one inst to the next

    fmin = 1./400
    fmax = 1./50

    boundary_times = [ '00:30', '01:30', '02:30', '03:30' ]
    n_freqs = 64 ; cheating - already figured this out

    freq = fltarr(n_freqs, 3)
    power = fltarr(n_freqs, 3)

    for ii = 0, n_elements(boundary_times)-2 do begin
        time = strmid( time, 0, 5 )
        z_start = (where( time eq boundary_times[ii]   ))[1]
        z_end =   (where( time eq boundary_times[ii+1] ))[0]
        result = calc_ft( $
            flux[z_start:z_end], $
            cadence, $
            fmin=fmin, fmax=fmax, norm=0 )
        freq[*,ii] = result.frequency
        power[*,ii] = result.power
    endfor

    struc = { $
        freq : { $
            before : freq[*,0], $
            during : freq[*,1], $
            after : freq[*,2] }, $
        power : { $
            before : power[*,0], $
            during : power[*,1], $
            after : power[*,2] } $
            }

    return, struc

end
