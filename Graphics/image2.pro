;- Last modified
;-   22 April 2019
;-    Added xthick and ythick kws.


function image2, data, x, y,  _EXTRA=e
;function image2, data, x, y, _EXTRA=e
    ; Can this be called without x and y args?
    ; Does _EXTRA only take keywords (kw=kw, not just kw)?

    graphics
    common defaults

    sz = size(data, /dimensions)
    ;if n_elements(sz) eq 2 then $
    ;    data = reform( data, sz[0], sz[1], 1, /overwrite)

    if n_elements(x) eq 0 AND n_elements(y) eq 0 then begin
        x = indgen( sz[0] )
        y = indgen( sz[1] )
    endif
        


    im = image( $
        data, X, Y, $
        font_size = fontsize, $
        ytickfont_size = fontsize, $
        xtickfont_size = fontsize, $
        axis_style = 2, $
           ; = 0 (no axes) DEFAULT for images
           ; = 1 (single x and y axes)
           ; = 2 (box axes) DEFAULT for PLOT ...
           ;-     not what this code does, why did I feel the need to specify this?
           ;-          --08 July 2020
           ; = 3 (crosshair axes)
           ; = 4 (No axes, but margins as if there were axes)
        xtickdir = 0, $
        ytickdir = 0, $
        xticklen = 0.02, $
        yticklen = 0.02, $
        xsubticklen = 0.5, $
        ysubticklen = 0.5, $
        ;xminor = 5, $
        ;yminor = 5,  $
        xthick = 0.5, $  ; default = 1
        ythick = 0.5, $
        _EXTRA = e )

    return, im
end
