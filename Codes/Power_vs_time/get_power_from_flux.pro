

; LAST MODIFIED:
;-   16 December 2018
;-
;- PURPOSE:
;-   Get power as function of time, P(t), from total flux (integrated emission)
;- INPUT:
;-   flux, cadence
;- KEYWORDS:
;-   dz (sample length for fourier2.pro in data units)
;-   fmin, fmax (frequency_bandwidth)
;- OUTPUT:
;-   Returns 1D array of power as function of time.
;- TO DO:
;-   Create new saturation routine (this currently addresses
;-      saturation and calculation of total power with time.



function GET_POWER_FROM_FLUX, $
    flux, $
    cadence, $
    n_pix=n_pix, $
    dz=dz, $
    fmin=fmin, $
    fmax=fmax, $
    norm=norm


    ; This first bit is exactly like power_maps.pro....
    N = n_elements(flux)
    z_start = indgen(N-dz)
    power_from_flux = fltarr(N-dz)  ; initialize power array



    ;   23 July 2018
    ;     - changed this to divide flux by n_pixels before calculating FT
    ;   25 November 2018
    ;     - probably a good idea: flux*10^n increases power by factor of 10^2n.

    if keyword_set(n_pix) then new_flux = flux/n_pix $
        else new_flux=flux


    resolve_routine, 'calc_fourier2', /either
    foreach zz, z_start, ii do begin

        CALC_FOURIER2, new_flux[zz:zz+dz-1], cadence, $
            frequency, power, fmax=fmax, fmin=fmin

        power_from_flux[ii] = mean(power)
    endforeach

    return, power_from_flux
end


goto, start


;- Calculate power from flux (per pixel).

start:;----------------------------------------------------------------------------------------
dz = 64
power = fltarr(685, 2)


;- NOTE: A[*].flux = exposure-time corrected, TOTAL flux over AR.
for cc = 0, 1 do begin
    power[*,cc] = GET_POWER_FROM_FLUX( $
        A[cc].flux, $
        A[cc].cadence, $
        n_pix = 500.*330., $
        dz=dz, $
        fmin=0.005, $
        fmax=0.006, $
        norm=0 )
endfor

;stat1 = stats(power, /display)
;stat2 = stats(power/n_pix, /display)

;- FT(flux)
;yrange=[1.0e7, 1.0e15] 
;ytickvalues = 10.^[8:14]


;- FT(flux per pixel)
yrange = [1.e-4, 1.e5]  
ytickvalues = [1.e-4, 1.e-2, 1.e0, 1.e2, 1.e4]
;ytickvalues = 10.^[-4:2:2]

props = { $
    ylog : 1, $
    yrange : yrange, $
    ytickvalues : ytickvalues, $
    yminor : 9, $
    ;symbol : 'circle', $
    ;sym_filled : 0, $
    ;sym_size : 0, $  ;; = 0.1 up to... not sure how big.
    name : A.name }

file = 'time-3minpower_flux'

resolve_routine, 'plot_pt';, /either
PLOT_PT, power, dz, A[0].time, _EXTRA = props



save2, file


end
