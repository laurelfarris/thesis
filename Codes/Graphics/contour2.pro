;- Last modified:       03 October 2018
;- Programmer:          Laurel Farris


function contour2, data, x, y, _EXTRA=e

    common defaults



    c = contour( $
        data, $
        x, y, $
        overplot=1, $
        ;n_levels=2, $ ; ignored by c_values
        ;c_value = [c1,c2], $
        c_thick = 0.5, $
        c_label_show=0, $
        ;c_color = , $
        ;color = , $
        _EXTRA = e )

    return, c

end
