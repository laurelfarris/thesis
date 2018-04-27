; Last modified:   26 April 2018



pro plt, A, ind=ind, lightcurve=lightcurve, power=power

    ;; ind = indices of ydata to plot.

    common defaults
    dpi = 96
    p = objarr(2)


    ; separate subroutine for stuff like this
    values = [74, 149, 224, 299, 374, 449, 524, 599, 674]

    ; Put time in nice format for labeling plot
    time = strmid(A[0].time, 0, 5)

    if keyword_set(lightcurve) then begin
        ; A.flux is a 749x2 array... includes both channels!
        ydata = A.flux
        y1600 = ydata[*,0]
        y1600 = y1600 - min(y1600)
        y1600 = y1600/max(y1600)
        y1700 = ydata[*,1]
        y1700 = y1700 - min(y1700)
        y1700 = y1700/max(y1700)
        ydata = [ [y1600], [y1700] ]
        ytitle = 'Flux (DN s$^{-1}$)'
    endif
    if keyword_set(power) then begin
        ydata = A.power
        ytitle='3-minute power'
    endif
    sz = size( ydata, /dimensions )
    xdata = indgen(sz[0])
    if keyword_set(ind) then begin
        xdata = xdata[ind]
        ydata = ydata[ind,*]
    endif

    for i = 0, 1 do begin
        p[i] = plot2( $
            xdata, ydata[*,i], $
            /current, /overplot, /device,  $
            position=[0.90,0.4,8.3,2.6]*dpi, $
            ;xtickvalues=values, $
            stairstep=0, $
            xshowtext=0, $
            xticklen=0.02, $
            yticklen=0.02, $
            xtitle='Middle time (2011-February-15)', $
            ytitle=ytitle, $
            name=A[i].name, $
            color=A[i].color $
        )
    endfor
    leg = legend2( target=[p[0],p[1]], position=[0.85,0.7], /relative )
    return

    ax = p[0].axes
    ax[2].title = 'image #'
    ax[2].showtext=1
    ;ax[0].tickname=time[values]
    ax[0].tickname=time[ax[0].tickvalues]

    x = [227:347]
    y = fltarr(n_elements(x))
    y[ 0] = (p[0].yrange)[0]
    y[-1] = (p[0].yrange)[0]
    y[1:-2] = (p[0].yrange)[1]
    ;new = plot( x, y, /overplot, ystyle=1, $
    ;    linestyle=6, fill_background=1, fill_transparency=90 )


    ; These are hardcoded times... don't work with only a portion of lc.
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
start:;--------------------------------------------------------------------

; Need correct times/indices for lc to line up with power.
; This should not be this complicated...

;z = [0:680:5]
z = [0:748-dz]
dz = 64
xdata = z+(dz/2)

ind = [0:200] 

wx = 8.5
wy = 3.0

w = window( dimensions=[wx,wy]*dpi, name='lightcurve_2' )
plt, A, ind=ind, /lightcurve
save2, 'lightcurve_3.pdf'

w = window( dimensions=[wx,wy]*dpi, name='power_time_2' )
plt, A, ind=[0:40], /power
save2, 'power_time_3.pdf'




stop



; This needs to be logged somwhere, and removed from here.
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

w1.save, '~/lightcurve_2.pdf', border=0, page_size=[wx,wy], width=wx, height=wy
w2.save, '~/power_time_2.pdf', border=0, page_size=[wx,wy], width=wx, height=wy


end
