; Filename:         color_tables.pro
; Last modified:    Fri 10 Mar 2017
; Programmer:       Laurel Farris
; Description:      Create custom color tables in a structure
;                       Returns by reference to tag index**
;
;   27 December 2023        
;         **current version appears to return entire structure
;     Looks like the type of routine where user modifies function content directly
;       rather than calling from elsewhere with a few input args & kws..
;     Seems simple and straighforward tho (not to mention SHORT)
;       


function color_tables;, desired_colors



    ;; Colors (creation of color tables could go in subroutine...)
    black  = [000,000,000]
    white  = [255,255,255]
    red    = [204,000,000]
    orange = [255,128,000]
    yellow = [255,255,000]
    green  = [000,153,000]
    lgreen = [102,255,102]
    cyan   = [000,153,153]
    blue   = [000,000,204]
    purple = [148,000,211]
    indigo = [075,000,130]

    ;my_colortable = COLORTABLE( [[wh], [rd], [og], [ye], [gr], [bl], [pr]])

    my_colortable = COLORTABLE( [$
        [black], $
        [cyan], $
        [orange], $
        [red] $
    ] )

    return, my_colortable

    ;s = { $
    ;    im_colors    : colortable( [[bk], [wh]]), $
    ;    cc_colors    : colortable( [[wh], [rd], [og], [ye], [gr], [bl], [pr]]), $
    ;    cc_grayscale : colortable( [[wh], [bk]] ), $
    ;    tt_colors    : colortable( [[wh],[rd],[ye],[bl],[wh]], $
    ;                    indices=[0,1,128,254,255], stretch=[0,10,-10,0] ) $
    ;    }
    ;tags = tag_names(s)
    ;i = where( tags eq desired_colors )
    ;return, s.(i)

    ; 2018 April 19
    ;return,  colortable( [[wh], [rd], [og], [ye], [gr], [bl], [pr]])

end
