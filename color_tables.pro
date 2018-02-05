; Filename:         color_tables.pro
; Last modified:    Fri 10 Mar 2017
; Programmer:       Laurel Farris
; Description:      Create custom color tables in a structure
;                       Returns by reference to tag index


function color_tables, desired_colors



    ;; Colors (creation of color tables could go in subroutine...)
    bk = [000,000,000]
    wh = [255,255,255]
    rd = [204,000,000]
    og = [255,128,000]
    ye = [255,255,000]
    gr = [000,153,000]
    lg = [102,255,102]
    cy = [000,153,153]
    bl = [000,000,204]
    pr = [148,000,211]
    in = [075,000,130]


    s = { $
        im_colors    : colortable( [[bk], [wh]]), $
        cc_colors    : colortable( [[wh], [rd], [og], [ye], [gr], [bl], [pr]]), $
        cc_grayscale : colortable( [[wh], [bk]] ), $
        tt_colors    : colortable( [[wh],[rd],[ye],[bl],[wh]], $
                        indices=[0,1,128,254,255], stretch=[0,10,-10,0] ) $
        }

    tags = tag_names(s)
    i = where( tags eq desired_colors )


    return, s.(i)


end
