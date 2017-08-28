;; Last modified:   25 August 2017 10:51:39

;; Subroutines:     fourier2 --> returns "Array containing power and phase
;;                                              at each frequency"

;; Purpose:         Run fourier2 through time on each pair of 2D pixel coordinates
;;                  and return 2D power image


;; Inputs:          cube = data cube time series (i.e. same dt between each image).
;;                  delt = time between each image, in seconds.



pro plot_fft, flux, cad, props, i, zoomin=zoomin


    result = fourier2( flux, cad, /norm )
    frequency = result[0,*]
    power_spectrum = result[1,*]

    ;; Entire thing
    x = frequency
    y = power_spectrum
    period = 1./frequency
    period_min = (1./60.)/x  ;; minutes

    my_ytitle = "log power (normalized)"

    ;; Zoom in
    if keyword_set( zoomin ) then begin
        T = 210.
        dT = 120.
        zi = where( period ge T-dT AND period le T+dT )
        x = x[zi]
        y = y[zi]
        props.ylog = 0
        props.yrange = [0.0, 1.0]
        ;props.yrange = [0.0003, 6.1]
        my_ytitle = "power (normalized)"
    endif

    ;; Add axis labels where necessary
    if (i ge 7) then props.xtitle = "frequency [Hz]" else props.xtitle = ""
    if (i eq 1) OR (i eq 4) OR (i eq 7) then props.ytitle = my_ytitle else props.ytitle = ""

    ;; Make plots
    p = plot( x, y, /current, $
        layout=[3,3,i], margin=0.10, $
        _EXTRA=props )

    ;; Shift position of panels
    p.position = p.position + [0.05, +0.03, 0.03, -0.03]


    ;; Add vertical line at 3-min
    f3 = 1./180.
    v1 = props.yrange[0]
    v2 = props.yrange[1]
    vert = plot( [f3, f3], [v1,v2], linestyle=2, /overplot ) 


    ;; Add axis to show period
    if zoomin eq 1 then begin
        tvalues = (1./60.)/[2.0, 3.0, 4.0, 5.0]  ;; Hz
        nmaj = n_elements(tvalues)
        ax = p.axes
        ax[2].major = nmaj
        ax[2].minor = 5
        ax[2].showtext = 1
        ax[2].tickvalues = tvalues
        if (i le 3) then ax[2].title = "period [min]" else ax[2].title = ""
        ax[2].tickname = reverse( string( (1./tvalues)/60., format='(F6.1)' ) )
        ;period_label = GET_LABELS( period_min, nmaj )
        ;ax[2].tickname = string( period_label, format='(F6.1)' )
    endif

end

@main

wx = 800
wy = 650
w = window( dimensions=[wx,wy] )

props = { $
    xtickfont_name : fontname, ytickfont_name : fontname, $
    xtickfont_size : fontsize-1, ytickfont_size : fontsize-1, $
    font_name : fontname, $
    color : "dark blue", $
    xticklen : wx/30000.,  yticklen : wy/30000., $
    xminor : 5, $
    xstyle : 1, $
    ;xrange : [0.003, 0.011], $
    ;yrange : alog10( [0.00001,130.0] ), $
    yrange : [0.00001,130.0], $
    ylog : 1, $
    title : "", $
    xtitle : "", $
    ytitle : "" $
    ;xtickformat : '(F6.3)' $
    }

zoomin=1


plot_fft, hmi_flux[0:ht1-1], hmi_cad, props, 1, zoomin=zoomin
plot_fft, hmi_flux[ht1:ht2], hmi_cad, props, 4, zoomin=zoomin
plot_fft, hmi_flux[ht2+1:*], hmi_cad, props, 7, zoomin=zoomin

plot_fft, a6_flux[0:a6t1-1], aia_cad, props, 2, zoomin=zoomin
plot_fft, a6_flux[a6t1:a6t2], aia_cad, props, 5, zoomin=zoomin
plot_fft, a6_flux[a6t2+1:*], aia_cad, props, 8, zoomin=zoomin

plot_fft, a7_flux[0:a7t1-1], aia_cad, props, 3, zoomin=zoomin
plot_fft, a7_flux[a7t1:a7t2], aia_cad, props, 6, zoomin=zoomin
plot_fft, a7_flux[a7t2+1:*], aia_cad, props, 9, zoomin=zoomin

ty = 0.98
titles = ["HMI","AIA 1600$\AA$","AIA 1700$\AA$"]
t = text( 0.18, ty, titles[0], font_size=fontsize )
t = text( 0.49, ty, titles[1], font_size=fontsize )
t = text( 0.82, ty, titles[2], font_size=fontsize )

;save_figs, "fa_spec"
;save_figs, "fa_spec_zoom"
;dw
end
