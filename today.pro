;+
;- 11 March 2020
;-
;- Today's project: LCs of ROIs with saturation... see if oscillations at
;-   periods ~ few minutes are visible (better not be...)
;-  Copied code from 2020-03-05.pro
;-


buffer=1

dz = 64

;- center coords and dimesions of (square) area around ROI.
center = [250,165]
rr = 6

;-
;---
;-

title = "Light curve for " + $
    strcompress(rr, /remove_all) + "x" + $
    strcompress(rr, /remove_all) + $
    " pixel area in center of AR 11158"

x0 = center[0]
y0 = center[1]

roi = A.data[ $
    x0-(rr/2) : x0+(rr/2)-1, $
    y0-(rr/2) : y0+(rr/2)-1, $
    * ]
help, roi

;- Sum over area? Or take average?
;-  Same as computations from 2020-02-18.pro
roi_flux = mean( mean( roi, dimension=1 ), dimension=1 )
;roi_flux = total( total( roi, 1 ), 1 )
help, roi_flux


help, A[0].time
help, roi_flux[*,0]

;xdata = indgen( n_elements(roi_flux[*,0]) )
xdata = [271:295]
ydata = roi_flux[xdata,*]

result = fourier2( ydata[*,0], 24)
help, result

dw
plt = plot2( result[0,*], result[1,*], buffer=1 )
save2, 'testFT'

;-
;- Plot ROI flux
dw
win = window( dimensions=[8.5,4.0]*dpi, buffer=buffer )
plt = objarr(n_elements(A))
;plt = plot2( roi_flux[*,0], buffer=1)
;save2, 'test'
for cc = 0, 1 do begin
    plt[cc] = plot2( $
        xdata, $
        ydata, $
        /current, $
        overplot=cc<1, $
        color=A[cc].color, $
        symbol='circle', $
        buffer=buffer $
    )
endfor
plt[0].title=title
;-
;-
filename = 'ROI_flare_center'
save2, filename, /timestamp

end
