; Last modified:   09 April 2018


pro total_power, struc, z, dz, frequency, power

    ; Which routine should break flux down? Should sub-array be
    ; the input here? Or feed the indices and have this routine
    ; break flux into sub-array?
    ; Also to need to get sub-array of frequency and power.



    
    result = fourier2( indgen(dz), struc.cadence ) 
    frequency = reform( result[0,*] )
    period = 1./frequency

    ; Initialize power array
    x = n_elements( frequency )
    y = n_elements( z )
    power = fltarr(x,y)

    ; Calculate power starting at each frequency

    flux = struc.flux

    foreach i, z do begin

        result = fourier2( flux[i:i+dz-1], 24. ) 
        power[0,i] = reform( result[1,*] )

    endforeach

end
