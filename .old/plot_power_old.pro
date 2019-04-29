; Last modified:   05 June 2018

; Always give input in frequencies (Hz), e.g. vert = 1./[180,300]


function POWER_VS_TIME, flux, cadence, frequency_bandwidth, $
    dz=dz, z_start=z_start, norm=norm

    ; Input:        flux, cadence, frequency_bandwidth = [fmin,fmax]
    ; Keywords:     dz = sample length for fourier2.pro (data units)
    ; Output:       Returns 1D array of power as function of time.
    ; To do:        Add test codes
    ;               Preserve date_obs that goes with each z_start
    ;               maybe return a structure with both, or something


    ; This first bit is exactly like power_maps.pro....
    sz = n_elements(flux)

    ; z_end? No idea why I would set z to this...
    ;if n_elements(z) eq 0 then z = indgen(n-dz)

    if n_elements(z_start) eq 0 then z_start = [0]
    if n_elements(dz) eq 0 then dz = sz

    ; Calculate possible frequencies for dz.
    result = fourier2( indgen(dz), cadence )
    frequency = reform( result[0,*] )
    fmin = frequency_bandwidth[0]
    fmax = frequency_bandwidth[1]
    bandpass = where( frequency ge fmin AND frequency le fmax )

    ; initialize power array
    power_time = fltarr(sz)

    ; Calculate power for time series between each value of z and z+dz
    foreach z, z_start, i do begin

        result = fourier2( flux[z:z+dz-1], cadence, norm=norm )
        power = reform( result[1,*] )
        power_time[i] = MEAN( power[bandpass] )

    endforeach
    return, power_time
end

goto, start

; Structure of user-input values. Mostly just examples.
; Bandwidth is either xrange for power spectra, or frequency bandwidth
;  for calculating total (mean) power to represent "3-min power".
; Probably only use one or the other, never both.
; Use short variable/tag names to just feed individual values into routines,
; E.G. plot, ft.flux, xrange=ft.xrange...
FT = {$
    flux: A[0].flux, $
    norm: 1, $
    cadence: 24, $
    fcenter: 1./180, $
    fwidth: 1./(170) - 1./(190), $
    fmin: 0.004, $
    fmax: 0.006, $
    ;fmin: 1./50, $
    ;fmax: 1./400, $
    z_start: [0:200:5], $
    dz: 64, $
    time: ['01:30','02:30'], $
    periods: [120, 180, 200, 300] $
}
; NOTE: regarding fwidth,
 ; period width not constant as frequency resolution,
 ; but this is based on specific central period, so others don't matter.

dz = 64
df = [0.005,0.006]
flux = A[i].flux
power = POWER_VS_TIME( flux, cadence, df, dz )
help, power

; plot power vs. time

;aia1600 = create_struct( aia1600, 'power', power )
;aia1700 = create_struct( aia1700, 'power', power )

end
