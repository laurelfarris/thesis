;; Last modified:   21 September 2017 00:26:48
; Programmer:       Laurel Farris

all_props = { $
    ;buffer : 1, $
    ;current    : 1, $
    ;overplot : , $
    ;device     : 0, $
    ;dimensions : , $   ; of window
    ;location : , $     ; of window
    ;layout : , $
    ;margin : , $
    ;no_toolbar
    ;nodata : , $
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
    ;xtext_orientation : , $ ; angle of tick labels [degrees]
    ;ytext_orientation : , $
    ;xtextpos : 0, $ ; 1 = above axis, 0 = below axis (default)
    ;ytextpos : 0, $ ; 1 = to right of axis, 0 = to the left (?? didn't actually say...)
    ;xtitle     : , $
    ;ytitle     : , $

    xshowtext : 1, $
    yshowtext : 1, $
    ;xtickname     : , $
    ;ytickname     : , $
    ;xtickunits     : , $
    ;ytickunits     : , $
    ;xtickvalues     : , $
    ;ytickvalues     : , $
    ;xtickformat  : "" $
    ;ytickformat: '(E5.0)', $
    ;xticklayout : , $  ; 1=suppress (show labels, not tick marks or axis), 2=boxed
    ;yticklayout : , $

    axis_style : 2, $   ; 0=No axes & decreased margins, 1=single, 2=box, 3=crosshair, 4=1, but margins stay the same
    ;xticklen : 0.03, $ ; length of major tick marks, relative to graphic
    ;yticklen : 0.03, $
    xsubticklen : 0.5, $ ; ratio of minor to major tick length (default = 0.5)
    ysubticklen : 0.5, $
    ;xthick : 1, $ ; 0.0 --> 10.0
    ;ythick : 1, $
    ;xtickdir : 0, $ ; 0=inwards (default), 1=outwards
    ;ytickdir : 0, $
    ;xmajor : -1, $  ; Number of major tick marks (-1 --> auto-compute,  0 --> suppress)
    ;ymajor : -1, $
    ;xminor : 5, $  ; Number of minor tick marks between each pair of major ticks
    ;yminor : 5, $
    ;xtickinterval : ;; interval BETWEEN major tick marks [data units?]
    ;ytickinterval :
    ;xlog : 0, $
    ;ylog : 0, $
    ;xstyle : , $  ; (0=nice, 1=exact, 2=>nice, 3=>exact)
    ;ystyle : , $
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
    ;xrange
    ;yrange
    ;zvalue  ; = height of z plane (=0 by default)
    ;max_value : 0.0, $   ; max/min values can be thought of as "zrange"
    ;min_value : 0.0, $
    ;name
    ;position
    ;title      : "", $
    ;transparency
    ;uvalue
    ;window (get only)
    ;window_title
}


; 
; graphic = IDLFUNC( data, _EXTRA=e )
; --> running properties as keywords seems to be a lot faster


fontsize = 9
fontname = "Helvetica"
fontstyle = 0 ; 0=normal, 1=bold, 2=italic, 3=bold italic


;; Window
;w = WINDOW( $
;   location = [x-offset, y-offset] )  ; on computer screen
;   dimensions = [w,h], $  pixels
;   /buffer, $
;   title = "", $

; scale = [1,1]  ;; default
;w = window( dimensions=scale*[500, 500], location=[800,100.0] )


;; Graphic object array
;graphic = OBJARR(N)  ; for N objects
;for i = 0, N-1 ... graphic[i] = IMAGE(...)


;; Graphic methods

;; Axes - can retrieve array of AXIS objects
;p = PLOT(...)
;ax = p.AXES
;ax[0].title = "..."
;ax[2].hide = 1

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

;; Images----------------------------------------------------------------------------------------
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
    ;scale_center  ; moves relative to image axes, not entire window
    ;scale_factor  ;  ditto
    }

; im = image( Data [, X, Y] [, Keywords=value] [, Properties=value] )
;   X = [ x coords of Data ]



;; Colorbar----------------------------------------------------------------------------------------

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

; orientation BEFORE position! Otherwise colors will change in the wrong direction
; Set position according to graphics layout somehow?

    ;txt = text( x, y, filename, font_size=fontsize-2, font_name=fontname)




;; Contours----------------------------------------------------------------------------------------
;graphic = contour( data, x, y, ... )
