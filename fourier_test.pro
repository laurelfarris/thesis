


; Test all kinds of FT scenerios
;   dz
;   constant vs. changing signal
;   damping
;   normalizing

; Real data:
;   quiet vs. flaring region (subregion)
;   central frequency/period
;   bandpass


; 22 August 2018
; Test to see how variability in 3-minute power with time, P(t),
;   changes for different time segment lengths (dz)


; (dz*cadence)/180 = # cycles in dz = 8.53 for dz=64
; 1 full 3-min cycle --> dz = 7.5

j = 1
dz_values = [0:9] + 60
cadence = 24
;cycles =

fmin = 0.005
fmax = 0.006

colors = [ $
    'black', $
    'blue', 'red', 'green', $
    'deep sky blue', 'dark orange', 'dark cyan', $
    'purple', 'saddle brown', 'deep pink' ]

p = objarr(n_elements(dz_values))
N = n_elements(A[j].flux)

win = window2( buffer=1 )
foreach dz, dz_values, i do begin

    z_start = indgen(N-dz)
    power = fltarr(N-dz)

    foreach z, z_start, k do begin
        struc = CALC_FT( flux[z:z+dz-1], cadence, fmin=fmin, fmax=fmax )
        power[k] = struc.mean_power
    endforeach

    power = NORMALIZE(power) + 0.1*i

    p[i] = plot2( $
        power, $
        current = 1, $
        overplot = i<1, $
        color = colors[i]
        name = 'dz = ' + strtrim(dz,1) )

endforeach

save2, 'fourier_test.pdf', /add_timestamp

end
