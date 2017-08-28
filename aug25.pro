;; Last modified:   25 August 2017 11:02:06



@main

props = { $
    font_name : fontname, $
    xtickfont_name : fontname, $
    ytickfont_name : fontname, $
    font_size : fontsize, $
    xtickfont_size : fontsize, $
    ytickfont_size : fontsize, $
    ;xtitle     : , $
    ;ytitle     : , $
    ;xshowtext : 1, $
    ;yshowtext : 1, $
    axis_style : 0, $   ; 0=No axes & decreased margins, 1=single, 2=box, 3=crosshair, 4=1, but margins stay the same
    ;xticklen : 0.03, $ ; length of major tick marks, relative to graphic
    ;yticklen : 0.03, $
    xsubticklen : 0.5, $ ; ratio of minor to major tick length (default = 0.5)
    ysubticklen : 0.5 $
    ;xtickdir : 0, $ ; 0=inwards (default), 1=outwards
    ;ytickdir : 0, $
    ;xmajor : -1, $  ; Number of major tick marks (-1 --> auto-compute,  0 --> suppress)
    ;ymajor : -1, $
    ;xminor : 5, $  ; Number of minor tick marks between each pair of major ticks
    ;yminor : 5, $
    ;xtickinterval : ;; interval BETWEEN major tick marks [data units?]
    ;ytickinterval :
    ;xstyle : , $  ; (0=nice, 1=exact, 2=>nice, 3=>exact)
    ;ystyle : , $
    ;title      : "", $
    ;image_dimensions : , $
    ;image_location : , $
    }

im = objarr(3)
w = window( dimensions=[800,300] )

;; Custom properties
titles = [ $
    "HMI at UT " + date[0], $
    "AIA 1600$\AA$ at UT " + date[1], $
    "AIA 1700$\AA$ at UT " + date[2] $
]

im[0] = image( hmi[*,*,0], /current, layout=[3,1,1], title=titles[0], _EXTRA=props)
im[1] = image( (a6[*,*,0])^0.5, /current, layout=[3,1,2], title=titles[1], _EXTRA=props)
im[2] = image( (a7[*,*,0])^0.5, /current, layout=[3,1,3], title=titles[2], _EXTRA=props)



end
