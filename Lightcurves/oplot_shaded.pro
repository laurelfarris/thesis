;+
;- LAST MODIFIED:
;-   27 December 2023
;-     Merged w/ kw opts & other relevant portions of '../Graphics/shade_my_plot.pro' ▶︎▶︎
;-       itself originally under conditional for optional kw in call to
;-       subroutine '/Lightcurves/oplot_flare_lines.pro'
;-       to add shading after primary purpose of oplotting vertical lines if kw set to do so.
;-
;-  ▶︎▶︎ Comments from '../Graphics/shade_my_plot.pro' (deleted 12/27/2023):
;-       kw "shaded" removed from ../Lightcurves/oplot_flare_lines.pro on 17 January 2020
;-         (better to call separate subroutine to do this)
;-
;- PURPOSE:
;-   Shade plot background over full y-range between x-indices [x1:x2] (user-input)
;-     time windows within plots to cover impulsive, peak, and decay flare phases
;-
;- EXTERNAL SUBROUTINES:
;-   XXX plot2.pro XXX
;-     => NOT called in current version of shading subroutine (as of 12/27/2023),
;-         replaced with call to IDL's POLYGON function (a better way to shade).
;-
;- USEAGE:
;-   result = OPLOT_SHADED( x_vertices, plt, kw=kw )
;-
;- INPUT:
;-   x_vertices = 2 x N  array, where N = number of shaded regions to color (3 for phase2)
;-   plt = current active graphic object
;-
;- OUTPUT:
;-   plt = [ plt, shaded ]   ;;  shaded = ??
;-      
;- TO DO:
;-   [] double-check / confirm variable type & dimensions of 'x_vertices' & 'shaded'
;-   [] replace hardcoded values with input args/kws
;-   [] move hardcoded variables specific to RHESSI to main rhessi lc code
;-       
;+


function OPLOT_SHADED, $
    x_vertices, $
    plt, $
    _EXTRA=e


    ;----

    sz = size(x_vertices)
    if sz[0] eq 1 then x_vertices=REFORM(x_vertices, sz[1], 1)
    sz = size(x_vertices)
        ; re-define sz for reformed x_vertices array to pull corrected n_elem for 'shaded'

    ;fill_color=['yellow', 'green', 'indigo']
    ;fill_color=['pale goldenrod', 'pale green', 'light sky blue']
    ;fill_color=['white smoke', 'light yellow', 'light blue']
    fill_color=['eeeeee'X, 'e4e4e4'X, 'dadada'X]
    ;fill_color=['ffffdf'X, 'dfffdf'X, 'afffff'X]
    color=['ffaf5f'X, '87d7af'X, '5f5fd7'X]
    name = ['impulsive', 'peak', 'decay']

    y2 = max( [plt[0].yrange, plt[1].yrange])
    y1 = min( [plt[0].yrange, plt[1].yrange])
    ; what if plt has more than two plots?? How to find min/max over all of them?

    ;shaded = objarr(3)
    shaded = objarr(sz[2])
    ;   8/6/2024
    ;     ==> use number of separate x-ranges WITHIN x_vertices array passed by caller
    ;         instead of hardcoding :)
    ;
    
    ; From "../Graphics/shade_my_plot.pro" (not needed...):
    ;     yrange = ( shaded[ii] ).yrange
    ;     v_shaded = PLOT2( $
    ;         [ vx[0]-32, vx[0]-32, vx[-1]+32-1, vx[-1]+32-1 ], $
    ;         [ yrange[0], yrange[1], yrange[1], yrange[0] ], $
    ;     )

    for ii = 0, n_elements(shaded)-1 do begin

        x1 = x_vertices[0,ii]
        x2 = x_vertices[1,ii]

        shaded[ii] = POLYGON( $
            [x1,x2,x2,x1], $
            [y1,y1,y2,y2], $
            target=plt, $
            /data, $
            thick=0.5, $
            ;linestyle=[1,'5555'X], $
            ;linestyle = 4, $
            ;linestyle=6, $
            ;ystyle=1,
            ;color=color[ii], $
            color=fill_color[ii], $
            /fill_background, $
            ;fill_background = 0, $
            ;fill_background=1, $
            fill_color=fill_color[ii], $
            ;fill_color='light gray'
            ;fill_color='eeeeee'X, $
            ;fill_transparency=50, $
            name = name[ii] $
        )
        ;v_shaded.Order, /SEND_TO_BACK
        shaded[ii].Order, /SEND_TO_BACK
    endfor

    plt = [ plt, shaded ]
    return, shaded

end
