;; Last modified:   21 September 2017 11:06:41

;; Subroutines:     fourier2 --> returns "Array containing power and phase
;;                                              at each frequency"

;; Purpose:         Run fourier2 through time on each pair of 2D pixel coordinates
;;                  and return 2D power image


;; Inputs:          cube = data cube time series (i.e. same dt between each image).
;;                  delt = time between each image, in seconds.



pro plot_fft, flux, cad, props, i, zoomin=zoomin

    @main

    result = fourier2( flux, cad, /norm )
    frequency = result[0,*]
    power_spectrum = result[1,*]

    ;; Entire thing
    x = frequency
    y = power_spectrum
    period = 1./frequency
    period_min = (1./60.)/x  ;; minutes

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
        props.ytitle = "power (normalized)"
    endif

    b = 0.08
    l = 0.08
    t = 0.1
    r = 0.01
    gap = 0.02
    pos = positions( 3, 3, b=b, l=l, t=t, r=r, gap=gap )
    pos = pos[*,i-1]


    ;; Make plots
    p = plot( x, y, /current, $
        ;layout=[3,3,i], margin=0.10, $
        position=pos, $
        _EXTRA=props )

    ;; Axes
    ax = p.axes
    if pos[0] ne l then ax[1].showtext = 0
    if pos[1] ne b then ax[0].showtext = 0

    ;; Add vertical line at 3-min
    f3 = 1./180.
    v1 = props.yrange[0]
    v2 = props.yrange[1]
    vert = plot( [f3, f3], [v1,v2], linestyle=2, /overplot ) 

    ;; Add axis to show period
    if zoomin eq 1 then begin
        tvalues = (1./60.)/[2.0, 3.0, 4.0, 5.0]  ;; Hz
        nmaj = n_elements(tvalues)
        ax[2].major = nmaj
        ax[2].minor = 5
        ax[2].tickvalues = tvalues
        if pos[3] ge (1.0-t) then begin
            ax[2].showtext = 1
            ax[2].title = "period [min]"
            ax[2].tickname = reverse( string( (1./tvalues)/60., format='(F6.1)' ) )
        endif
        ;if (i le 3) then ax[2].title = "period [min]" else ax[2].title = ""
        ;period_label = GET_LABELS( period_min, nmaj )
        ;ax[2].tickname = string( period_label, format='(F6.1)' )
    endif

    ty = 1.0 - t/3.0
    tx = pos[0] + (pos[2]-pos[0])/2
    titles = ["HMI","AIA 1600$\AA$","AIA 1700$\AA$"]
    text_props = { $
         font_size:fontsize+1, $
         font_name:fontname, $
         font_style:2, $
         alignment:0.5 }
    if i eq 1 then t = text( tx, ty, titles[0], _EXTRA=text_props )
    if i eq 2 then t = text( tx, ty, titles[1], _EXTRA=text_props )
    if i eq 3 then t = text( tx, ty, titles[2], _EXTRA=text_props )


end

@main

wx = 800
wy = 650
w = window( dimensions=[wx,wy] )

props = { $
    ;font_props, $
    ;xtickfont_name : fontname, ytickfont_name : fontname, $
    ;xtickfont_size : fontsize, ytickfont_size : fontsize, $
    ;font_size : fontsize, $
    ;font_name : fontname, $
    ;font_style : 1, $
    color : "dark blue", $
    xticklen : wx/30000.,  yticklen : wy/30000., $
    xminor : 5, $
    xstyle : 1, $
    ;xrange : [0.003, 0.011], $
    ;yrange : alog10( [0.00001,130.0] ), $
    yrange : [0.00001,130.0], $
    ylog : 1, $
    title : "", $
    xthick : 1.5, $
    ythick : 1.5, $
    xtitle : "frequency [Hz]", $
    ytitle : "log power (normalized)" $
    ;xtickformat : '(F6.3)' $
    }


props = create_struct( font_props, props )

zoomin=1


plot_fft, hmi_flux[0:ht1-1], hmi_cad, props, 7, zoomin=zoomin
plot_fft, hmi_flux[ht1:ht2], hmi_cad, props, 4, zoomin=zoomin
plot_fft, hmi_flux[ht2+1:*], hmi_cad, props, 1, zoomin=zoomin

plot_fft, a6_flux[0:a6t1-1], aia_cad, props, 8, zoomin=zoomin
plot_fft, a6_flux[a6t1:a6t2], aia_cad, props, 5, zoomin=zoomin
plot_fft, a6_flux[a6t2+1:*], aia_cad, props, 2, zoomin=zoomin

plot_fft, a7_flux[0:a7t1-1], aia_cad, props, 9, zoomin=zoomin
plot_fft, a7_flux[a7t1:a7t2], aia_cad, props, 6, zoomin=zoomin
plot_fft, a7_flux[a7t2+1:*], aia_cad, props, 3, zoomin=zoomin

;save_figs, "fa_spec"
;save_figs, "fa_spec_zoom"
;dw
end
