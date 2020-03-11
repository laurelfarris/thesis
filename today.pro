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


title = "Light curve for 6x6 pix area in center of AR 11158"

x0 = center[0]
y0 = center[1]

roi = A.data[ $
    x0-(rr/2) : x0+(rr/2)-1, $
    y0-(rr/2) : y0+(rr/2)-1, $
    * ]

;- Sum over area? Or take average?
;-  Same as computations from 2020-02-18.pro
roi_flux = mean( mean( roi, dimension=1 ), dimension=1 )
;roi_flux = total( total( roi, 1 ), 1 )
help, roi_flux



;- Plot ROI flux
dw
win = window( dimensions=[8.5,11.0]*dpi )
plt = objarr(n_elements(A))
for cc = 0, 1 do begin
    plt[cc] = plot2( $
        ;A[cc].time, $
        roi_flux[*,cc], $
        /current, /device, $
        overplot=cc<1, $
        ;layout=[1,2,cc+1], $
        ;margin=1.75*dpi, $
        color=A[cc].color, $
        title=title $
    )
endfor


filename = 'ROI_flare_center'
save2, filename, /timestamp

end
