;+
;- LAST MODIFIED:
;-   28 July 2022
;-
;- PURPOSE:
;-   Add shaded regions to cover impulsive, peak, and decay time windows
;-
;- INPUT:
;-   x_vertices
;-
;- KEYWORDS:
;-
;- OUTPUT:
;-
;- TO DO:
;-   []

function OPLOT_SHADED, $
    x_vertices, $
    plt, $
    _EXTRA=e

    ;fill_color=['yellow', 'green', 'indigo']
    ;fill_color=['pale goldenrod', 'pale green', 'light sky blue']
    ;fill_color=['white smoke', 'light yellow', 'light blue']
    fill_color=['eeeeee'X, 'e4e4e4'X, 'dadada'X]
    ;fill_color=['ffffdf'X, 'dfffdf'X, 'afffff'X]
    color=['ffaf5f'X, '87d7af'X, '5f5fd7'X]
    name = ['impulsive', 'peak', 'decay']


    y2 = max( [plt[0].yrange, plt[1].yrange])
    y1 = min( [plt[0].yrange, plt[1].yrange])
    ; ==>> what if plt has more than two plots?? How to find min/max over all of them?

        shaded = objarr(3)
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
                ;color=color[ii], $
                color=fill_color[ii], $
                /fill_background, $
                fill_color=fill_color[ii], $
                ;fill_color='eeeeee'X, $
                ;fill_transparency=50, $
                name = name[ii] $
            )
            shaded[ii].Order, /SEND_TO_BACK
        endfor

    plt = [ plt, shaded ]
    return, shaded
end
