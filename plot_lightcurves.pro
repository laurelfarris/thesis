;; Last modified:   18 August 2017 12:17:10

@main

lc = objarr(3)

hy = hmi_flux - min(hmi_flux)
a6y = a6_flux - min(a6_flux)
a7y = a7_flux - min(a7_flux)

hy = hy/max(hy)
a6y = a6y/max(a6y) + 1.2
a7y = a7y/max(a7y) + 2.3

ax = findgen(n_elements(a6y))
hx = findgen(n_elements(hy))

const = max(ax)/max(hx)
hx = hx*const


;; Difference plots (August 18)
hy = hy - shift(hy, 1)
a6y = a6y - shift(a6y, 1)
a7y = a7y - shift(a7y, 1)
;;----------------------


;; Make labels for x axis (time)
label_1 = strmid( aia_1600_index.date_obs, 11, 5 )
label_2 = GET_LABELS( label_1, 5 )



wx = 700
wy = 400
w = window( dimensions=[wx,wy] )


fontstyle = 0 ; 0=normal, 1=bold, 2=italic, 3=bold italic
props = { $
    xtickfont_name : fontname,  ytickfont_name : fontname, $
    xtickfont_size : fontsize,  ytickfont_size : fontsize, $
    font_name : fontname, $
    font_size : fontsize+1, $
    ;font_color
    ;xcolor : 'black', $
    ;ycolor : 'black', $
    ;xtext_color : 'black', $
    ;ytext_color : 'black', $
    xtitle     : "UT time (15 February 2011)", $
    ytitle     : "Intensity [arbit. units]", $
    xtickname : label_2 , $
    ;ytickname     : , $
    ;xtickunits     : , $
    ;ytickunits     : , $
    ;xtickvalues     : , $
    ;ytickvalues     : , $
    ;xtickformat  : "" $
    ;ytickformat: '(E5.0)', $
    xticklen : wx/20000., $ ; length of major tick marks, relative to graphic
    yticklen : wy/20000., $
    ;xsubticklen : 0.5, $ ; ratio of minor to major tick length (default = 0.5)
    ;ysubticklen : 0.5, $
    ;xthick : 1, $ ; 0.0 --> 10.0
    ;ythick : 1, $
    thick : 1.5, $
    ;xmajor : -1, $  ; Number of major tick marks (-1 --> auto-compute,  0 --> suppress)
    xminor : 10, $  ; Number of minor tick marks (between each pair of major? Or total?)
    ;xtickinterval : ;; interval BETWEEN major tick marks [data units?]
    ;ytickinterval :
    ;xlog : 0, $
    ;ylog : 0, $
    xrange : [min(hx), max(hx)], $
    yrange : [min(hy)-0.1, max(a7y)+0.1], $
    ;position
    ;linestyle
    axis_style : 2 $   ; 0=No axes & decreased margins, 1=single, 2=box, 3=crosshair, 4=1, but margins stay the same
}

lc[0] = plot( hx, hy, /current, margin=0.08,  color='sea green', _EXTRA=props)
lc[1] = plot( ax, a6y, /overplot, color='deep sky blue', _EXTRA=props )
lc[2] = plot( ax, a7y, /overplot, color='firebrick', _EXTRA=props )


;t = text( 0.7, 0.28, "HMI", font_size=fontsize-1, font_name=fontname)
;t = text( 0.7, 0.44, "AIA 1600$\AA$", font_size=fontsize-1, font_name=fontname )
;t = text( 0.7, 0.69, "AIA 1700$\AA$", font_size=fontsize-1, font_name=fontname)
;ax = lc[0].axes
;ax[3].showtext = 1
;ax[3].title="inst"
;ax[3].tickname = [ "", "hmi", "", "aia1600", "", "", "", "aia1700", "", "" ]


;txt = text( x, y, filename, font_size=fontsize-2, font_name=fontname)

end
