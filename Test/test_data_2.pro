
; email from Prof. James (22 June)

pro CALC_DATA, lc, cadence, dz, $
    ;fmin, fmax, $
    fcenter, $
    std, power, power_norm, $
    log=log

    ; Calculate power for time series between each value of z and z+dz

    fmin = fcenter - 0.0005
    fmax = fcenter + 0.0005

    N = n_elements(lc)
    result = fourier2( indgen(N), cadence )
    frequency = reform( result[0,*] )
    ind = where( frequency ge fmin AND frequency le fmax )
    frequency = frequency[ind]

    ;; Initialize power array
    power = fltarr(N-dz)
    power_norm = fltarr(N-dz)
    var = fltarr(N-dz)

    for i = 0, (N-dz)-1 do begin
        flux = lc[i:i+dz-1]
        var[i] = (MOMENT(flux))[1]
        struc = CALC_FT( flux, cadence, fmin=fmin, fmax=fmax, norm=0 )
        power[i] = struc.mean_power
        struc = CALC_FT( flux, cadence, fmin=fmin, fmax=fmax, norm=1 )
        power_norm[i] = struc.mean_power
    endfor
    std = sqrt(var)

    if keyword_set(log) then begin
        power = alog10(power)
        power_norm = alog10(power_norm)
    end
end


function PLOT_DATA, xdata, ydata, _EXTRA=e

    common defaults

    left = 0.5
    right = 0.5
    top = 2.0
    bottom = 1.0

    margin = [left,bottom,right,top]*dpi

    p = plot2( xdata, ydata, $
        /current, /device, $
        margin = margin, $
        xmajor = 7, $
        _EXTRA = e )
    return, p
end

goto, start
START:

restore, '../test_data.sav'
N = n_elements(lc1)
cadence = time[1] - time[0]
dz = 64

common defaults
colors = [ 'blue', 'red', 'green', 'dark orange', 'purple', 'deep sky blue' ]
dw
wx = 8.5
wy = 11.0
win = window( dimensions=[wx,wy]*dpi, buffer=1 )

rows = 4
cols = 1
p = objarr(8)

;period = fix( (1./fcenter)*60. )
;power_name = strtrim(period,1) + '-minute power'

fcenter = 1./180
CALC_DATA, lc1, cadence, dz, fcenter, std, power_3, power_norm_3, log=1

fcenter = 1./300
CALC_DATA, lc1, cadence, dz, fcenter, std, power_5, power_norm_5, log=1

fcenter = 1./120
CALC_DATA, lc1, cadence, dz, fcenter, std, power_2, power_norm_2, log=1

power = [[power_3],[power_5],[power_2]]
power_norm = [[power_norm_3],[power_norm_5],[power_norm_2]]

xdata = indgen(N)
p[0] = PLOT_DATA( xdata, lc1, layout=[cols,rows,1], name='intensity' )
xrange = p[0].xrange

;time2 = time[dz/2:N-(dz/2)-1]
xdata2 = xdata[dz/2:N-(dz/2)-1]
p[1] = PLOT_DATA( xdata2, std, overplot=1, color='green', name='standard deviation' )

ax = p[0].axes
ind = ax[0].tickvalues
ax[0].tickname = strtrim( fix((time[ind])/60.), 1 )
ax[0].title = 'time (minutes)'
ax[0].showtext=1


ax[2].title = 'index'
ax[2].showtext=1


yrange = [-4.41,2.95]
power_prop = { color:'blue', xrange:xrange, yrange:yrange, name:'log power', xshowtext:0 }
power_norm_prop = { overplot:1, color:'red', name:'log power (normalized)' }


p[2] = PLOT_DATA( xdata2, power_3, layout=[cols,rows,2], title='3-minute period', _EXTRA=power_prop )
p[3] = PLOT_DATA( xdata2, power_norm_3, _EXTRA=power_norm_prop )
p[4] = PLOT_DATA( xdata2, power_5, layout=[cols,rows,3], title='5-minute period', _EXTRA=power_prop )
p[5] = PLOT_DATA( xdata2, power_norm_5, _EXTRA=power_norm_prop )
p[4] = PLOT_DATA( xdata2, power_2, layout=[cols,rows,4], title='2-minute period', _EXTRA=power_prop )
p[5] = PLOT_DATA( xdata2, power_norm_2, _EXTRA=power_norm_prop )

; This is why it helps to make graphics into object arrays...
leg = legend2( target=[p[0],p[1],p[2],p[3]], position=[0.85,0.92] )

print, ax[2].showtext
stop

file = 'test_data_3.pdf'
save2, file

end
