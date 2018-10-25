

;- 21 October 2018


;function IMAGE3_wrapper, $
function IMAGE3, $
    data, $
    rows=rows, $
    cols=cols, $
    titles=titles, $
    _EXTRA=e

    common defaults
    ;resolve_routine, 'colorbar2', /either
    resolve_routine, 'get_position', /either

    sz = size(map, /dimensions)

    wx = 8.5
    wy = 11.0

    ;wy = wx * (float(rows)/cols) * (float(sz[1])/sz[0])
    dw
    win = window( dimensions=[wx,wy]*dpi, /buffer )

    width = 2.0
    height = width

    left = 0.75
    top = 0.75
    xgap = 1.50
    ygap = 0.75

    im = objarr(cols*rows)

    for ii = 0, n_elements(im)-1 do begin
        position = GET_POSITION( $
            layout=[cols,rows,ii+1], $
            width=width, $
            height=height, $
            wy=wy, $
            left=left, $
            right=right, $
            top=top, $
            bottom=bottom, $
            xgap=xgap, $
            ygap=ygap )

        im[ii] = image2( $
            map[*,*,ii], $
            /current, /device, $
            position=position*dpi, $
            ;max_value=0.2*max(map[*,*,ii]), $
            ;min_value=min(map[*,*,ii]), $
            title = titles[ii], $
            _EXTRA=e )
    endfor

    return, im
end

function IMAGE3, $

    ;- 23 October 2018
    ;- NOT to be called like IDL's image function, which is how I have 
    ;- image2.pro set up.

    im = image3_wrapper( $
        wx = 8.5, $        
        wy = 11.0, $        
        _Extra = e)
end
