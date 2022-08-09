;+
;- LAST MODIFIED:
;-     29 June 2018
;-
;-     05 June 2020
;-       Copied code from plot_filter.pro, since computing and plotting
;-       background levels is unrelated to filtering.
;-
;- ROUTINE:
;-   oplot_background.pro
;-

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

;goto, start
;start:

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

;+
;--- Overplot pre-flare background
;-

;- --> HARDCODING!! BAD CODER!
;zind = [120:259]
zind = [0:150]
;- zind = z-indices of pre-flare data from which to extract pre-flare background level
;-    (doesn't start at zero because of the C-flare that took place in the middle
;-      of my pre-flare time period before the X2.2 flare on 15 February 2011... rude).
;-
;-
;background = MEAN(A.flux[zind], dim=1) - delt
;- 15 May 2020
;-  NOTE: "flux" is a subset extracted from A.flux (z-dimension), so in order to get pre-flare background level,
;-    have to go back to full time series: A.flux to get the pre-flare flux,
;-    which was cropped out when defining "flux"...
;-    (was initially confused as to why using A.flux here instead of flux... )
;background = MEAN(A.flux[zind], dim=1)
background = MEAN(A.flux[zind], dim=1)
for jj = 0, 1 do begin
    hor = plot2( $
        plt[0].xrange, $
        [ background[jj], background[jj] ], $
        /overplot, $
        linestyle=[1, '1111'X], $
        name = 'Background' )
endfor
;save2, filename

end
