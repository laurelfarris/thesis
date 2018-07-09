;; Last modified:   02 February 2018 20:36:19

;; Subroutines:     fourier2 --> returns "Array containing power and phase
;;                                              at each frequency"

;; Purpose:         Run fourier2 through time on each pair of 2D pixel coordinates
;;                  and return 2D power image


;; Inputs:          cube = data cube time series (i.e. same dt between each image).
;;                  delt = time between each image, in seconds.



pro plot_fft, flux, cad, Trange, 


    ;; Set up plot properties
    @main
    wx = 1200
    wy = 900
    w = window( dimensions=[wx,wy] )
    props = { $
        color : "dark blue", $
        xticklen : wx/30000.,  yticklen : wy/30000., $
        xminor : 5, $
        xstyle : 1, $
        ;xrange : [0.003, 0.011], $
        ;yrange : alog10( [0.00001,130.0] ), $
        ;yrange : [0.00001,130.0], $
        ylog : 1, $
        ytitle : "log power (normalized)", $
        title : "", $
        xthick : 1.5, $
        ythick : 1.5, $
        xtitle : "frequency [Hz]", $
        ;ytickformat :  , $
        ytext_orientation : 45 $
        ;xtickformat : '(F6.3)' $
        }
    props = create_struct( font_props, props )

    ;; Calculate FFT
    result = fourier2( flux, cad, /norm )
    fr = result[0,*]
    pow = result[1,*]
    per = 1./fr
    per_min = per/60.
    
    ;; Zoom in
    if keyword_set( Trange ) then begin
        i = where( per_min ge Trange[0] AND per_min le Trange[1] )
        fr = fr[i]
        pow = pow[i]
        props.ylog = 0
        props.yrange = [0.0, 1.0]
        ;props.yrange = [0.0003, 6.1]
        props.ytitle = "power (normalized)"
        tvalues = (1./60.)/[2.0, 3.0, 4.0, 5.0]
    endif

    tvalues = (1./60.)/[2.0, 3.0, 4.0, 5.0]


    ;; Set up position of each panel
    b = 0.08
    l = 0.10
    t = 0.1
    r = 0.01
    gap = 0.02
    pos = positions( 3, 3, b=b, l=l, t=t, r=r, gap=gap )
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



cube = hmi
sz = size(cube, /dimensions)


uflux = []
pflux = []
qflux = []

upix = []
ppix = []
qpix = []

for i = 0, sz[2]-1 do begin

    d = cube[*,*,i]
    quiet_sun = mean( cube[ 350:-1,0:120,i] )
    umbra = quiet_sun * 0.6
    penumbra = quiet_sun * 0.9

    ulocs = array_indices(d, where(d le umbra))
    plocs = array_indices(d, where(d gt umbra AND d lt penumbra))
    qlocs = array_indices(d, where(d ge penumbra))

    uflux = [ uflux, total( d[ ulocs[0,*], ulocs[1,*] ]) ] 
    pflux = [ pflux, total( d[ plocs[0,*], plocs[1,*] ]) ] 
    qflux = [ qflux, total( d[ qlocs[0,*], qlocs[1,*] ]) ] 
    
    upix = [upix, n_elements( d[ ulocs[0,*], ulocs[1,*] ]) ]
    ppix = [ppix, n_elements( d[ plocs[0,*], plocs[1,*] ]) ]
    qpix = [qpix, n_elements( d[ qlocs[0,*], qlocs[1,*] ]) ]

endfor


n = 3
arr = fltarr( n, sz[2] )
arr[0,*] = uflux
arr[1,*] = pflux
arr[2,*] = qflux

titles = [ "umbra lightcurve", "penumbra lightcurve", $
    "quiet sun lightcurve", "integrated lightcurve" , "hmi_flux"]
w = window( dimensions=[1000,1100] )
p = objarr(n)
for i=0,n-1 do begin
    p[i] = plot( arr[i,*], /current, layout=[1,n,i+1], margin=0.10, $
    title = titles[i])
endfor

;; Plot total flux for all 3 components
w = window( dimensions = [1000,1100] )
p = plot( uflux, layout=[1,3,1], margin=0.1, /current, $
    title = "Umbral flux" )
p = plot( upix, layout=[1,3,2], margin=0.1, /current, $
    title = "Number of pixels making up umbra")
p = plot( uavg, layout=[1,3,3], margin=0.1, /current, $
    title = "Average flux per pixel in umbra")

;; Plot total number of pixels in each component
w = window( dimensions = [1000,1100] )
p = plot( upix, layout=[1,3,1], margin=0.10, /current )
p = plot( ppix, layout=[1,3,2], margin=0.10, /current )
p = plot( qpix, layout=[1,3,3], margin=0.10, /current )

;; Plot total square arcseconds in each component
w = window( dimensions = [1000,1100] )
p = plot( upix*hmi_res^2, layout=[1,3,1], margin=0.10, /current )
p = plot( ppix*hmi_res^2, layout=[1,3,2], margin=0.10, /current )
p = plot( qpix*hmi_res^2, layout=[1,3,3], margin=0.10, /current )

;; Plot average flux per pixel
w = window( dimensions = [1000,1100] )
p = plot( uavg/upix, layout=[1,3,1], margin=0.10, /current )
p = plot( pavg/ppix, layout=[1,3,2], margin=0.10, /current )
p = plot( qavg/qpix, layout=[1,3,3], margin=0.10, /current )


STOP


;; Calculate FFT
result = fourier2( flux, cad, /norm )
fr = result[0,*]
pow = result[1,*]
per = 1./fr
per_min = per/60.

plot_fft, hmi_flux[0:ht1-1], hmi_cad, props, 7, zoomin=zoomin
plot_fft, hmi_flux[ht1:ht2], hmi_cad, props, 4, zoomin=zoomin
plot_fft, hmi_flux[ht2+1:*], hmi_cad, props, 1, zoomin=zoomin

;save_figs, "fa_spec"
;save_figs, "fa_spec_zoom"
;dw
end




;-----------------------------------------------------------------------------
;; Last modified:   25 October 2017 16:41:59

;+
; ROUTINE:      main.pro
;
; PURPOSE:      Reads fits headers and restores data from .sav files.
;               Creates arrays of total flux, and calls routine for power spectrum images,
;                   using time information from the headers for "during" and "all".
;
; USEAGE:       @main.pro
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




function HMI_COMPONENTS, hmi_data
    ;; Individual data (this will go in its own file eventually... with "resolve_routine..." )

    sz = size(hmi_data, /dimensions)
    hmi = create_struct( $
        "Umbra",    fltarr(2,sz[2]), $
        "Penumbra", fltarr(2,sz[2]), $
        "Quiet",    fltarr(2,sz[2]) )

    for i = 0, sz[2]-1 do begin

        d = hmi_data[*,*,i]
        quiet = mean( d[ sz[0]-100:-1, 0:100 ] )
        cu = 0.6 * quiet
        cp = 0.9 * quiet

        ulocs = array_indices(d, where(d le cu))
        plocs = array_indices(d, where(d gt cu AND d lt cp))
        qlocs = array_indices(d, where(d ge cp))

        hmi.Umbra[0,i]    = total( d[ ulocs[0,*], ulocs[1,*] ])
        hmi.Penumbra[0,i] = total( d[ plocs[0,*], plocs[1,*] ])
        hmi.Quiet[0,i]    = total( d[ qlocs[0,*], qlocs[1,*] ])
        
        hmi.Umbra[1,i]    = n_elements( d[ ulocs[0,*], ulocs[1,*] ])
        hmi.Penumbra[1,i] = n_elements( d[ plocs[0,*], plocs[1,*] ])
        hmi.Quiet[1,i]    = n_elements( d[ qlocs[0,*], qlocs[1,*] ])
    endfor
    return, hmi
end



pro MY_PLOT, d, cols, rows, props

    
    a0 = d.(0)[0,*] + d.(1)[0,*] + d.(2)[0,*]
    a1 = d.(0)[0,*]
    a2 = d.(1)[0,*]
    a3 = d.(2)[0,*]
    a4 = d.(0)[1,*]
    a5 = d.(1)[1,*]
    a6 = d.(2)[1,*]

    a4 = a1/a4
    a5 = a2/a5
    a6 = a3/a6

    
    x0 = (a0-min(a0))/(max(a0)-min(a0)) + 4.0 
    x1 = (a1-min(a1))/(max(a1)-min(a1)) + 3.0 
    x2 = (a2-min(a2))/(max(a2)-min(a2)) + 2.0 
    x3 = (a3-min(a3))/(max(a3)-min(a3)) + 1.0 
    x4 = (a4-min(a4))/(max(a4)-min(a4)) + 3.0
    x5 = (a5-min(a5))/(max(a5)-min(a5)) + 2.0
    x6 = (a6-min(a6))/(max(a6)-min(a6)) + 1.0
    
;    fx0 = a0/a0
;    fx1 = a1/a0
;    fx2 = a2/a0
;    fx3 = a3/a0

;    x0 = alog10( (a0-min(a0)+0.1)*fx0 )
;    x1 = alog10( (a1-min(a1)+0.1)*fx1 )
;    x2 = alog10( (a2-min(a2)+0.1)*fx2 )
;    x3 = alog10( (a3-min(a3)+0.1)*fx3 )

;    x0 = a0/max(a0)
;    x1 = a1/max(a0)
;    x2 = a2/max(a0)
;    x3 = a3/max(a0)

;    x0 = 10^fx0
;    x1 = 10^fx1
;    x2 = 10^fx2
;    x3 = 10^fx3

    p = objarr(7)



    p[0] = plot( x0, color='black', /current, $
        name = "Total", $
        position=[0.1,0.5,0.95,0.95], $
        xshowtext=0, $
        ;ytitle="DN s$^{-1}$", $
        ytitle="Intensity (arbitrary units)", $
        _EXTRA=props )

    p[1] = plot( x1, color='dark green', /overplot, name="Umbra" )
    p[2] = plot( x2, color='orange red', /overplot, name="Penumbra" )
    p[3] = plot( x3, color='medium blue' , /overplot, name="Quiet sun" )


    p[4] = plot( x4, color='dark green', /current, $
        position=[0.1,0.1,0.95,0.5], $
        xtitle="time (UT)", $
        ytitle="flux per pixel", $
        _EXTRA=props )
    p[5] = plot( x5, color='orange red', /overplot )
    p[6] = plot( x6, color='medium blue', /overplot )



    leg = legend( /normal, $
        position=[0.15,0.92], $
        horizontal_alignment='LEFT', $
        ;vertical_spacing=0.03, $
        linestyle='none', $
        shadow=0, $
        font_name="Helvetica", $
        font_size=10 )

end



pro WRAPPER, d, layout=layout, _EXTRA=ex
    ;; wrapper for images, plots, or scatterplot

    cols = layout[0]
    rows = layout[1]

    wx = 1000
    wy = (wx/2.8)*rows
    w = window(dimensions=[wx,wy] )

    fontname = "Helvetica"
    fontname = "DejaVuSans"
    fontsize = 10
    fontstyle = 0
    props = { $
        font_name : fontname, $
        font_size : fontsize, $
        font_style : fontstyle, $
        xtickfont_name : fontname, $
        ytickfont_name : fontname, $
        xtickfont_size : fontsize, $
        ytickfont_size : fontsize, $
        xtickfont_style : fontstyle, $
        ytickfont_style : fontstyle, $
        xticklen : wx/40000., $
        yticklen : wy/40000., $
        xsubticklen : 0.5, $
        ysubticklen : 0.5, $
        xmajor : 5, $
        xminor : 4, $
        yminor : 4, $
        xstyle : 1 $
    }

    if (n_elements(ex) ne 0) $
        then props = create_struct( props, ex ); $
        ;else props = defaults

    MY_PLOT, d, cols, rows, props

end


dw
xlabels = get_labels( strmid( hmi_index.date_obs, 11, 5 ), 4 )
WRAPPER, hmi, layout=[1,2], xtickname=xlabels




;title = "Umbral flux"
;title = "Number of pixels making up umbra"
;title = "Average flux per pixel in umbra"


end
