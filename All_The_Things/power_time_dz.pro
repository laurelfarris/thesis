


;- Plotting P(t) for several central periods:
;- 2-minute power, 3-minute power, and 5-minute power.

cc = 0
cadence = A[cc].cadence

norm = 0
color = ['black', 'red', 'blue', 'green']
T_center = [120, 180, 300 ]
name = strtrim(T_center,1) + ' min'
;name = ['2-min', '3-min', '5-min', '0.8-sec']

fcenter = 1./T_center


N = n_elements(fcenter)

dw
win = window(dimensions=[8.0,4.0]*dpi, /buffer)
plt = objarr(N)

; 10 minutes
dz = 25
bandpass = 0.002

time = strmid(A[cc].time,0,5)
z_start = (where(time eq '01:30'))[0]
z_end = (where(time eq '02:30'))[0]

power = []

for ii = 0, N-1 do begin
    fmin = fcenter[ii] - bandpass/2.
    fmax = fcenter[ii] + bandpass/2.

    ;for zz = 0, 686-1 do begin
    for zz = z_start, z_end, 1 do begin
    
        ;flux = A[cc].flux[zz:zz+dz-1]
        flux = A[cc].data[370,215,zz:zz+dz-1]

        result = fourier2( flux, cadence, norm=norm )
        frequency = reform(result[0,*])
        ind = where(frequency ge fmin and frequency le fmax)
        p = reform(result[1,*])
        power = [ power, mean(p[ind]) ]

    endfor

    plt[ii] = plot2( $
        indgen(n_elements(power)), power, $
        /current, /device, overplot=ii<1, $
        layout = [1,1,1], margin=0.75*dpi, $
        ;ylog=1, $
        xtitle = 'index', ytitle = 'power', $
        sym_size=0.2, $
        symbol='circle', $
        color = color[ii], $
        name = name[ii] )
endfor
leg = legend2( target=plt, position=[0.9, 0.95] )

save2, 'power_time_2min.pdf'

end
