

;- 24 October 2018

;- Input 3D data cube and arrays of image kws, then loops through them.
;- Not meant to be called just like IDL's image, so
;-   use whatever keywords you need.

function IMAGE3_wrapper, $
    data, $
    ;X, Y, $
    wx = wx, $
    ;wy = wy, $
    ;width = width, $
    ;height=height, $
    left = left, right = right, xgap = xgap, $
    top = top, bottom = bottom, ygap = ygap, $
    rows=rows, cols=cols, $
    title=title, $
    buffer=buffer, $
    _EXTRA=e


    common defaults
    resolve_routine, 'get_position', /either

    sz = size(data, /dimensions)
    if n_elements(sz) eq 2 then nn = 1 else nn = sz[2]

    width = (wx - ( left + right + (cols-1)*xgap )) / cols
    height = width * float(sz[1])/sz[0]

    wy = top + bottom + (rows*height) + (rows-1)*ygap

    if keyword_set(buffer) then $
        win = window(dimensions=[wx,wy]*dpi, buffer=1) $
    else $
        win = window(dimensions=[wx,wy]*dpi, location=[500,0])
        

    im = objarr(nn)

    ;if not arg_present(X) then X = indgen(sz[0])
    ;if not arg_present(Y) then Y = indgen(sz[1])

    for ii = 0, nn-1 do begin
        position = GET_POSITION( $
            layout=[cols,rows,ii+1], $
            width=width, $
            height=height, $
            wy=wy, $
            left=left, $
            top=top, $
            xgap=xgap, $
            ygap=ygap )

        im[ii] = image2( $
            data[*,*,ii], $
            ;X, Y, $
            /current, /device, $
            position=position*dpi, $
            title = title[ii], $
            _EXTRA=e )
    endfor

    return, im
end


function IMAGE3,  $
    data, $
    ;X, Y, $
    _EXTRA=e

    common defaults

    sz = size(data, /dimensions)
    ;if n_elements(sz) eq 2 then nn = 1 else nn = sz[2]

    if n_elements(sz) eq 2 then $
        data = reform( data, sz[0], sz[1], 1, /overwrite )
    sz = size(data, /dimensions)
    nn = sz[2]

    ; Use optional kw to add letter to each input title?
    title = alph[0:nn-1]

    im = image3_wrapper( $
        data, $
        ;X, Y, $
        buffer = 1, $
        rows = 1, $
        cols = 1, $
        wx = 8.0, $
        ;wy = 11.0, $
        top = 0.2, $
        left = 0.2, $
        right = 0.2, $
        bottom = 0.2, $
        xgap = 0.2, $
        ygap = 0.2, $
        title = title, $
        _EXTRA = e)
    return, im
end
