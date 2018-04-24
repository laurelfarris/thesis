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

pro plt, A, xdata, lightcurve=lightcurve, power=power

    common defaults
    dpi = 96
    p = objarr(2)
    values = [74, 149, 224, 299, 374, 449, 524, 599, 674]
    time = strmid(A[0].time, 0, 5)

    if keyword_set(lightcurve) then begin
        ydata = A.flux[xdata,*]
        ytitle = 'Flux (DN s$^{-1}$)'
    endif
    if keyword_set(power) then begin
        ydata = A.power
        ytitle='3-minute power'
    endif

    for i = 0, 1 do begin
        p[i] = plot2( $
            xdata, ydata[*,i], $ ;A[i].power, $
            /current, /overplot, /device,  $
            position=[0.90,0.4,8.3,2.6]*dpi, $
            xtickvalues=values, $
            xticklen=0.02, $
            yticklen=0.02, $
            xtitle='Start time (2011-February-15)', $
            ytitle=ytitle, $
            name=A[i].name, $
            color=A[i].color $
        )
    endfor

    ax = p[0].axes
    ax[0].tickname=time[values]
    ax[2].title = 'image #'
    ax[2].showtext=1

    x = [227:347]
    y = fltarr(n_elements(x))
    y[ 0] = (p[0].yrange)[0]
    y[-1] = (p[0].yrange)[0]
    y[1:-2] = (p[0].yrange)[1]
    ;new = plot( x, y, /overplot, ystyle=1, $
    ;    linestyle=6, fill_background=1, fill_transparency=90 )

    leg = legend2( target=[p[0],p[1]], position=[0.75,0.5], /relative )
    i1 = ( where( time eq '01:44' ) )[ 0]
    i2 = ( where( time eq '01:56' ) )[ 0]
    i3 = ( where( time eq '02:06' ) )[-1]
    ind = [i1,i2,i3]
    yr = p[0].yrange
    foreach i, ind do $
        v = plot( [i,i], p[0].yrange, $
            /overplot, linestyle='-.', ystyle=1)
end

goto, start

dz = 64
z = [0:748-dz]
frequency = reform( (fourier2( indgen(dz), 24 ))[0,*] )
ind = where( frequency ge 0.0048 AND frequency le 0.0060 )
frequency = frequency[ind]
period = 1./frequency

; Initialize power array
power = fltarr(n_elements(z))

; Calculate power starting at each frequency
flux = A[0].flux
aia1600 = create_struct( aia1600, 'power', power )
flux = A[1].flux
; This is pretty quick, so no need to save variables.
foreach i, z do begin
    result = fourier2( flux[i:i+dz-1], 24. ) 
    power[i] = TOTAL( (reform( result[1,*] )) [ind])
endforeach
aia1700 = create_struct( aia1700, 'power', power )

stop
z = [0:748-dz]
dz = 64
xdata = z+(dz/2)

start:;--------------------------------------------------------------------

wx = 8.5
wy = 3.0

w1 = window( dimensions=[wx,wy]*dpi, name='lightcurve_2' )
plt, A, xdata, /lightcurve

w2 = window( dimensions=[wx,wy]*dpi, name='power_time_2' )
plt, A, xdata, /power


stop
w1.save, '~/lightcurve_2.pdf', border=0, page_size=[wx,wy], width=wx, height=wy
w2.save, '~/power_time_2.pdf', border=0, page_size=[wx,wy], width=wx, height=wy


end
