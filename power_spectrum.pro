;; Last modified:   14 July 2017 12:43:24

;+
; ROUTINE:      power_spectrum.pro
;
; PURPOSE:      Describe steps in project
;
; USEAGE:       
;
; INPUT:        N/A
;
; KEYWORDs:     N/A
;
; OUTPUT:       N/A
;
; TO DO:        
;
; AUTHOR:       Laurel Farris
;
;KNOWN BUGS:
;-


pro power_spectrum, cube3, flux

    ;; Scale window coordinates relative to 500x500
    scale = [2.0,1.5]

    ;; Call script with all configurations (image_props, plot_props, cbar_props)
    ;; Set individual properties as needed (e.g. image_props.xtitle = "bleh")
    @graphic_configs  

    ;; Create graphics
    n = 4
    im = objarr(n) ;; n = number of graphics in window

    im[0] = image( cube3[*,*,0], layout=[2,2,2], /current, $
        title = "hmi continuum", xtitle = "x[pixels]", ytitle="y[pixels]", $
        _EXTRA=image_props)
    
    im[1] = plot( flux, layout=[2,2,1], margin=0.2, /current, $
        title = "Total flux from midnight to 5:00 (ish)", $
        _EXTRA=plot_props)


    delt = 45
    result = fourier2( flux, delt, /norm )
    fr = result[0,*]
    period = 1./fr
    ps = result[1,*]

    im[2] = plot( ps, period, layout=[2,2,3], /current, $
        xtitle="power", ytitle="period [seconds]", $
        xrange=[0.0,0.1], $
        yrange=[min(period),200], $
        _EXTRA=plot_props)
    ;im[3] = plot( ps, period, layout=[2,2,4], /current, $ xtitle="power", ytitle="period [seconds]", $ _EXTRA=plot_props)

    wavelet = fltarr( n_elements(ps), n_elements(period))
    wavelet[*,*]=1.0
    wavelet[0,0]=0.0
    im[3] = image( wavelet, layout=[2,2,4], /current, $
        title="wavelet analysis", $
        xtitle="time [image number]", ytitle="period [seconds]", $
        _EXTRA=image_props)
   
    txt2 = text(0.01, 0.01, systime(), font_size=9, font_name=font_name)

end

;; Don't need this anymore...
;cube3 = cube2[200:650, 200:500, *]
;sz = size(cube3, /dimensions)
;flux = []
;for i = 0, sz[2]-1 do begin
;    flux = [flux, total(cube3[*,*,i]) ]
;endfor

power_spectrum, cube3, flux





end
