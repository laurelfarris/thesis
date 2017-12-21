;; Last modified:   04 October 2017 17:37:13
;; Make structure with x and y values for plotting

pro STUFF, flux, cad, ind, tags, str

    
    ind = [0, ind, -1]
    for i = 1, n_elements(ind)-1 do begin

        arr = flux[ ind[i-1]:ind[i] ]

        result = fourier2( arr, cad, /norm )
        frequency = result[0,*]
        power = result[1,*]
        period = 1./frequency
        period_min = period/60.

        x = frequency
        y = power

        str = create_struct( str, tags[i-1], [x, y] )

        
    endfor
        
end

str = {}

STUFF, hmi_flux, 45.0, [ht1,ht2], ["HMI_before", "HMI_during", "HMI_after"], str
STUFF, aia_1600_flux, 24.0, [a6t1,a6t2], ["AIA_1600_before", "AIA_1600_during", "AIA_1600_after"], str
STUFF, aia_1700_flux, 24.0, [a7t1,a7t2], ["AIA_1700_before", "AIA_1700_during", "AIA_1700_after"], str


end
