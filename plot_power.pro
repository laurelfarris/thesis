; Last modified:   05 June 2018


function CALC_POWER_TIME, flux, cadence, $
    fmin=fmin, fmax=fmax, $
    dz=dz, z_start=z_start, norm=norm

    ; Input:        flux, cadence
    ; Keywords:     dz (sample length for fourier2.pro in data units)
    ;               fmin, fmax (frequency_bandwidth)
    ; Output:       Returns 1D array of power as function of time.
    ; To do:        Add test codes
    ;               Preserve date_obs that goes with each z_start
    ;               maybe return a structure with both, or something


    ; This first bit is exactly like power_maps.pro....
    N = n_elements(flux)

    ;if n_elements(z) eq 0 then z = indgen(n-dz)
    if n_elements(z_start) eq 0 then z_start = [0]
    if n_elements(dz) eq 0 then dz = N

    ; initialize power array
    power_time = fltarr(sz)

    ; Calculate power for time series between each value of z and z+dz
    foreach z, z_start, i do begin

        struc = CALC_FT( flux[z:z+dz-1], cadence, fmin=fmin, fmax=fmax, norm=norm )
        power_time[i] = struc.mean_power

    endforeach
    return, power_time
end
