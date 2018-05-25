;; Last modified:   08 May 2018 09:20:30



f_min = 0.004
f_max = 0.0085

; open file to write output
openw, lun, 'frequencies.txt', /get_lun, /append

for dz = 10, 250, 1 do begin
    ; dz = # images, with cadence = 24 seconds between each one

    dt = (dz*24)/60.
    ; dt = time covered by dz (minutes)

    result = fourier2( indgen(dz), 24 )
    frequencies = reform(result[0,*])
    periods = 1./frequencies

    printf, lun, ''

    ;print, format='("dz = ", I-0)', dz
    printf, lun, format='("dz = ", I-0)', dz

    ;print, format='("dt = ", F-0.2)', dt
    printf, lun, format='("dt = ", F-0.2)', dt

    foreach f, frequencies, i do begin
        if (f ge f_min AND f le f_max) then begin
            ;print, 1000 * f, periods[i], format='(2(F9.2))'
            printf, lun, 1000 * f, periods[i], format='(2(F9.2))'
        endif
    endforeach
endfor

free_lun, lun, exit_status=ex

end
