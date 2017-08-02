;; Last modified:   19 July 2017 13:39:46




pro MAKE_IMAGE, _EXTRA=ex

end




pro image, _EXTRA=ex

    fontsize = 9
    fontname = "Helvetica"

    ;; Image properties
    image_props = { $
        ;name       : "Image", $
        ;current    : 1, $
        device     : 0, $
        ;title      : "", $
        ;xtitle     : "", $
        ;ytitle     : "", $
        ;rgb_table  : intarr(256,3), $
        ;rgb_table  : colortable( [[255,255,255],[000,000,000] ] ), $
        font_name : fontname, font_size : fontsize+1, $
        xtickfont_size : fontsize,  ytickfont_size : fontsize, $
        xtickdir : 0, ytickdir : 0, $
        xticklen : 0.03, $
        yticklen : 0.03, $
        ;min_value : 0.0, $
        ;max_value : 0.0, $
        ;xtickinterval : ;; interval BETWEEN major tick marks
        ;ytickinterval : ;; interval BETWEEN major tick marks
        ;xtickformat  : "" $
        ;ytickformat: '(E5.0)', $
        ;xminor : 5, $
        ;yminor : 5, $
        axis_style : 2 $
        }

    if n_elements(ex) ne 0 then $
        ex = create_struct( 'property', value, ex ) $
    else $
        ex = { property : value }


    ;; Call 
    MAKE_IMAGE, _EXTRA=ex

end
