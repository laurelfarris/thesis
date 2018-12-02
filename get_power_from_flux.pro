
; Last modified:   25 November 2018

; Purpose:      Get power as function of time from total flux

; Input:        flux, cadence
; Keywords:     dz (sample length for fourier2.pro in data units)
;               fmin, fmax (frequency_bandwidth)
; Output:       Returns 1D array of power as function of time.
; To do:        Add test codes
;               Create new saturation routine (this currently addresses
;                 saturation and calculation of total power with time.



function GET_POWER_FROM_FLUX, $
    flux, $
    cadence, $
    dz=dz, $
    fmin=fmin, $
    fmax=fmax, $
    norm=norm, $
    data=data

    ; This first bit is exactly like power_maps.pro....
    N = n_elements(flux)
    z_start = indgen(N-dz)
    power_from_flux = fltarr(N-dz)  ; initialize power array

    ; Calculate power per pixel
    ;   23 July 2018
    ;     - changed this to divide flux by n_pixels before calculating FT
    ;   25 November 2018
    ;     - probably a good idea: flux*10^n increases power by factor of 10^2n.

    ; this is sloppy... make it better.
    if keyword_set(data) then begin
        sz = size(data,/dimensions)
        n_pixels = float(sz[0]) * sz[1]
        new_flux = flux / n_pixels
        ;power = power / n_pixels
    endif else new_flux = flux

    ; Calculate power for time series between each value of z and z+dz
    ;resolve_routine, 'calc_ft', /either
    ;foreach z, z_start, i do begin
    ;    struc = CALC_FT( $
    ;        new_flux[z:z+dz-1], cadence, fmin=fmin, fmax=fmax, norm=norm )
    ;    power[i] = struc.mean_power
    ;endforeach

    resolve_routine, 'calc_fourier2', /either
    foreach zz, z_start, ii do begin

        CALC_FOURIER2, new_flux[zz:zz+dz-1], cadence, $
            frequency, power, fmax=fmax, fmin=fmin

        power_from_flux[ii] = mean(power)
    endforeach

    ; Default frequency bandpass = 1 mHz (centered at 3-minute period)
    return, power_from_flux
end

;- 25 November 2018
;- P(t) plots from flux.

goto, start
start:;----------------------------------------------------------------------------------------


dz = 64

; Calculate P(t) from integrated emission

power = fltarr(685, 2)
xdata = [[indgen(685)],[indgen(685)]] + (dz/2)

for cc = 0, 1 do begin
    power[*,cc] = GET_POWER_FROM_FLUX( $
        ;A[cc].flux, $
        A[cc].flux/(500.*330.), $  ;- flux per pixel
        A[cc].cadence, $
        dz=dz, fmin=0.005, fmax=0.006, $
        norm=0 )
endfor


    sz = size(power,/dimensions)
    xdata = [ [indgen(sz[0])], [indgen(sz[0])] ] + (dz/2)

    resolve_routine, 'batch_plot', /either
    dw
    plt = BATCH_PLOT( $
        xdata, power, $
        xrange=[0,748], $
        ytitle='3-minute power', $
        ylog=1, $
        ;yrange=[1.0e7, 1.0e15], $  ;- FT(flux)
        ;ytickvalues = 10.^[8:14], $;- FT(flux)
        ;yrange = [1.e-4, 1.e5], $  ;- FT(flux per pixel)
        ;ytickvalues = 10.^[-4:4:2], $;- FT(flux per pixel)
        yminor=9, $
        wy=3.0, $
        color=A.color, $
        name=A.name, $
        buffer=1 )

    ax = plt[0].axes

    ;- FT( flux )
    ;ax[1].tickvalues = 10.^[8:14]

    ;- FT( flux per pixel )
    ;ax[1].tickvalues = 10.^[-4:4:2]

    ;resolve_routine, 'normalize_ydata', /either
    ;NORMALIZE_YDATA, plt

    resolve_routine, 'label_time', /either
    LABEL_TIME, plt, time=A.time;, jd=A.jd

    resolve_routine, 'oplot_flare_lines', /either
    OPLOT_FLARE_LINES, plt, t_obs=A[0].time;, jd=A.jd

    resolve_routine, 'legend2', /either
    leg = LEGEND2( target=plt, /upperleft )


resolve_routine, 'save2', /either
file = 'time-3minpower_flux'
save2, file

end
