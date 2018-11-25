


;- 25 November 2018

;- Polygon around enhanced regions
;- Lots of polygons on the same image...


function POLYGON_SUBREGIONS, center, target=target, width=width, color=color

    nn = (size(center,/dimensions))[1]
    pol = objarr(nn)
    resolve_routine, 'polygon2', /either

    for ii = 0, nn-1 do begin

        pol[ii] = polygon2( $
            target=im, center=center[*,ii], dimensions=[width,width],  $
            color=color[ii], $
            ;name='AR_' + strtrim(ii+1,1), $
            thick=1.0 )

        txt = text( $
            center[0,ii], center[1,ii] + r/2 + 1, $
            strtrim(ii+1,1), $
            /data, target=im, font_size=fontsize )
    endfor

    return, pol
end
