;; Last modified:   01 August 2017 23:16:36
; Programmer:       Laurel Farris


; Calling sequence: e = GRAPHIC_CONFIGS, n
;   n = 0  colorbar
;   n = 1  image
;   n = 2  plot
;   n = 3  scatterplot
; 
; graphic = IDLFUNC( data, _EXTRA=e )


;function GRAPHIC_CONFIGS

;; Cute coding to arrange multiple windows, according to location of the ones already generated.
;w = window( dimensions=scale*[500, 500], location=[800,100.0] )

fontsize = 9
fontname = "Helvetica"
fontstyle = 0 ; 0=normal, 1=bold, 2=italic, 3=bold italic

;; All properties
all_props = { $

    ;buffer : 1, $
    ;current    : 1, $
    ;device     : 0, $
    ;dimensions : , $
    ;layout : , $
    ;location : , $
    ;margin : , $
    ;no_toolbar
    ;nodata : , $
    ;overplot : , $
    ;widgets : , $


    ;rgb_table  : intarr(256,3), $
    ;rgb_table  : colortable( [[255,255,255],[000,000,000] ] ), $
    ;font_color
    ;background_color
    ;xcolor : 'black', $
    ;ycolor : 'black', $
    ;xtext_color : 'black', $
    ;ytext_color : 'black', $
    xtickfont_name : fontname, $
    ytickfont_name : fontname, $
    xtickfont_size : fontsize, $
    ytickfont_size : fontsize, $
    ;xtickfont_style : fontstyle, $
    ;ytickfont_style : fontstyle, $
    xshowtext : 1, $
    yshowtext : 1, $
    ;xtext_orientation : , $ ; angle of tick labels [degrees]
    ;ytext_orientation : , $
    ;xtextpos : 0, $ ; 1 = above axis, 0 = below axis (default)
    ;ytextpos : 0, $
    ;xtitle     : , $
    ;ytitle     : , $
    ;xtickname     : , $
    ;ytickname     : , $
    ;xtickformat  : "" $
    ;ytickformat: '(E5.0)', $
    axis_style : 2, $   ; 0=No axes & decreased margins, 1=single, 2=box, 3=crosshair, 4=1, but margins stay the same
    ;xticklen : 0.03, $ ; length of major tick marks, relative to graphic
    ;yticklen : 0.03, $
    xsubticklen : 0.5, $ ; ratio of minor to major tick length (default = 0.5)
    ysubticklen : 0.5, $ ; ratio of minor to major tick length (default = 0.5)
    ;xthick : 1, $ ; 0.0 --> 10.0
    ;ythick : 1, $
    ;xtickdir : 0, $ ; 0=inwards (default), 1=outwards
    ;ytickdir : 0, $
    ;xticklayout : , $  ; 1=suppress, 2=boxed
    ;yticklayout : , $
    ;xmajor : -1, $  ; Number of major tick marks (-1 --> auto-compute,  0 --> suppress)
    ;ymajor : -1, $
    ;xminor : 5, $  ; Number of minor tick marks (between each pair of major? Or total?)
    ;yminor : 5, $
    ;xtickinterval : ;; interval BETWEEN major tick marks
    ;ytickinterval : ;; interval BETWEEN major tick marks
    ;xlog : 0, $
    ;ylog : 0, $
    ;xstyle : , $  ; (0=nice, 1=exact, 2=>nice, 3=>exact)
    ;ystyle : , $
    ;xtickunits     : , $
    ;ytickunits     : , $
    ;xtickvalues     : , $
    ;ytickvalues     : , $
    ;xtransparency     : , $
    ;ytransparency     : , $
    ;xgridstyle
    ;ygridstyle
    ;xsubgridstyle
    ;ysubgridstyle


    ;; Properties
    ;aspect_ratio : , $  ; 0=not fixed (default)
    ;axes ;(get only)
    ;background_transparency
    ;clip
    ;crosshair ;(get only, see documentation for properties)
    font_name : fontname, $
    font_size : fontsize+1, $
    ;font_style : fontstyle, $
    ;hide
    ;mapgrid (get only)
    ;mapprojection (get only)
    ;map_projection
    ;max_value : 0.0, $
    ;min_value : 0.0, $
    ;name
    ;position
    ;title      : "", $
    ;transparency
    ;uvalue
    ;window (get only)
    ;window_title
    ;xrange
    ;yrange
    ;zvalue
}

;; Plot properties
plot_props = { $
    ;; Properties
    ;antialias
    ;eqn_samples
    ;eqn_userdata
    ;equation
    ;fill_background
    ;fill_color
    ;fill_level
    ;fill_transparency
    ;histogram
    ;linestyle
    ;stairstep
    ;sym_color
    ;sym_filled
    ;sym_fill_color
    ;sym_increment
    ;sym_object
    ;sym_size
    ;sym_thick
    ;sym_transparency
    ;symbol
    ;vert_colors
}

;; Images
image_props = { $
    ;; Keywords
    ;geotiff : , $
    ;image_dimensions : , $
    ;image_location : , $
    ;irregular : , $
    ;order : , $

    ;; Properties
    ;grid_units
    ;interpolate
    ;scale_center
    ;scale_factor
    }

; im = image( Data [, X, Y] [, Keywords=value] [, Properties=value] )
;   X = [ x coords of Data ]



;; Colorbar properties
cbar_props = { $
    ;name        : "Color Bar", $
    orientation : 1, $
    device      : 0, $
    ;title       : "", $
    ;position    : [0.0, 0.0, 0.0, 0.0], $
    font_name   : fontname, $
    font_size   : fontsize+1, $
    font_style  : "italic", $
    textpos     : 1, $
    border      : 1, $
    ticklen     : 0.3, $
    subticklen  : 0.5, $
    major       : 11, $
    minor       : 5, $
    ;range       : [0.0, 0.0], $
    tickformat  : "" $
    }


    ;txt = text( x, y, filename, font_size=fontsize-2, font_name=fontname)
