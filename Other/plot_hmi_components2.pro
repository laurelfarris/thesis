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
