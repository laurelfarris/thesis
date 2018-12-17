
; 29 June 2018
; extra plotting things that I may use eventually, but causing too much
; clutter at the moment

function plot_smooth, x, y
    ; Smoothed lightcurves
    y = smooth( y, 8 )
    sm = plot2( x, y, /overplot, linestyle='--', thick=1.0, $
        name='boxcar smoothed')
    return, sm
end

function plot_background, x,y
    ; Pre-flare background
    y = mean( y[0:200] )
    bg = plot2( x,y, /overplot, linestyle=':', thick=1.0, $
        name='pre-flare background')
    return, bg
end

goto, start

start:

i = 0
x = indgen(749)
y = A[i].flux;[200:399]

win = window2()
cols = 1
rows = 4

lc = plot2( x, y, /current, layout=[cols,rows,1], color=A[i].color, stairstep=1 )

y_smoothed = smooth( y, 8 )
lc_smoothed = plot2( x, y_smoothed, /overplot, linestyle='--' )

lc_diff = y - y_smoothed
p = plot2( x, lc_diff, /current, layout=[cols,rows,2] )


ylog = 1
yrange = [1e6, 1e14]

flux1 = y[150:250]
flux2 = y[250:350]

result = fourier2(flux1, 24)
frequency = reform(result[0,*])
power = reform(result[1,*])
p = plot2( frequency, power, /current, layout=[cols,rows,3], ylog=ylog, $
    yrange=yrange)

result = fourier2(flux2, 24)
frequency = reform(result[0,*])
power = reform(result[1,*])
p = plot2( frequency, power, /overplot, color='red', ylog=ylog )



flux1 = lc_diff[150:250]
flux2 = lc_diff[250:350]

result = fourier2(flux1, 24)
frequency = reform(result[0,*])
power = reform(result[1,*])
p = plot2( frequency, power, /current, layout=[cols,rows,4], ylog=ylog, $
    yrange=yrange)

result = fourier2(flux2, 24)
frequency = reform(result[0,*])
power = reform(result[1,*])
p = plot2( frequency, power, /overplot, color='red', ylog=ylog )


end
