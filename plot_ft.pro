;; Last modified:   06 February 2018 13:32:26

GOTO, START
START:

;; Fourier transforms

props = { $
    font_size      : 12, $
    xtickfont_size : 10, $
    ytickfont_size : 10, $
    thick          : 1.5, $
    xstyle         : 1, $
    ystyle         : 1, $
    axis_style     : 2, $
    title  : "SDO/AIA  1700$\AA$", $
    xtitle : "Period [seconds]", $
    ytitle : "Power" $
}


wx = 1200
wy = 500
w = window( dimensions=[wx,wy] )

p = objarr(2)

int = [120,180,200]
for i=0,1 do begin

    result = fourier2( S.(i).flux, 24.0 )

    frequency = result[0,*]
    power     = reverse( result[1,*], 2 )
    period    = reverse( (1./(frequency)), 2 )

    locs = where( period gt 110 AND period lt 210 )
    period = period[locs]
    power = power[locs]

    p[i] = plot( period, smooth(power,1), /current, $
        layout=[1,2,i+1], $
        margin=[0.15, 0.2, 0.04, 0.1], $
        ;xlog=1, $
        _EXTRA=props)

    for j=0,n_elements(int)-1 do begin
        v = plot( $
            [int[j],int[j]], $
            p[i].yrange, $
            /overplot, $
            linestyle=j+1 )
    endfor
endfor


;lc[0] = plot( hx, hy, /current, margin=0.08,  color='sea green', _EXTRA=props)
;lc[1] = plot( ax, a6y, /overplot, color='deep sky blue', _EXTRA=props )
;lc[2] = plot( ax, a7y, /overplot, color='firebrick', _EXTRA=props )


;t = text( 0.7, 0.28, "HMI", font_size=fontsize-1, font_name=fontname)
;t = text( 0.7, 0.44, "AIA 1600$\AA$", font_size=fontsize-1, font_name=fontname )
;t = text( 0.7, 0.69, "AIA 1700$\AA$", font_size=fontsize-1, font_name=fontname)
;ax = lc[0].axes
;ax[3].showtext = 1
;ax[3].title="inst"
;ax[3].tickname = [ "", "hmi", "", "aia1600", "", "", "", "aia1700", "", "" ]


;txt = text( x, y, filename, font_size=fontsize-2, font_name=fontname)

STOP

;--------------------------------------------------------------------------------------

;; Last modified:   04 October 2017 18:54:23

;; Subroutines:     fourier2 --> returns "Array containing power and phase
;;                                              at each frequency"

;; Purpose:         Run fourier2 through time on each pair of 2D pixel coordinates
;;                  and return 2D power image


;; Inputs:          cube = data cube time series (i.e. same dt between each image).
;;                  delt = time between each image, in seconds.



pro plot_fft, flux, cad, props, i, zoomin=zoomin


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
        tvalues = (1./60.)/[2.0, 3.0, 4.0, 5.0]
    endif else begin
        props.ytitle = "log power (normalized)"
        tvalues = (1./60.)/[2.0, 3.0, 4.0, 5.0]
    endelse

    b = 0.08
    l = 0.10
    t = 0.1
    r = 0.01
    gap = 0.02
    pos = positions( 3, 3, b, l, t, r, gap )
    pos = pos[*,i-1]


    ;; Make plots
    p = plot( x, y, /current, $
        position=pos, $
        _EXTRA=props )

    ;; Axes
    ax = p.axes
    if pos[0] ne l then ax[1].showtext = 0
    if pos[1] ne b then ax[0].showtext = 0

    ;; Add vertical line at 3-min
    f3 = 1./180.
    f5 = 1./300.
    v1 = props.yrange[0]
    v2 = props.yrange[1]
    vert = plot( [f3, f3], [v1,v2], linestyle=2, /overplot ) 
    vert2 = plot( [f5, f5], [v1,v2], linestyle=2, /overplot ) 

    ;; Add axis to show period
    ; convert desired periods (min) to Hz to find locs on x-axis
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

    
    ;; Column lables (HMI, AIA 1600, AIA 1700)
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


    ;; Better way, except IDL thinks the titles should go right on
    ;; top of the axis labels... also not using the same font :(
    ;;     29 Sep 2017
    ;if i eq 7 then p.title="HMI"
    ;if i eq 8 then p.title="AIA 1600"
    ;if i eq 9 then p.title="AIA 1700"


end

@main

wx = 1200
wy = 900
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
    ;ytickformat :  , $
    ytext_orientation : 45, $
    ytitle : "" $
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


end
