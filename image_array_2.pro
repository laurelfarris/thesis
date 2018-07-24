

pro IMAGE_ARRAY_2, data, X, Y, layout=layout, title=title, _EXTRA=e

    ; string array of letters: (a), (b), ..., (z)
    alph = '(' + string( bindgen(1,26)+(byte('a'))[0] ) + ')'

    common defaults
    sz = size(data, /dimensions)
    cols = layout[0]
    rows = layout[1]


    left = 0.75
    bottom = 0.50
    right = 0.25
    ;right = right + 1.25 ; room for colorbar
    top = 0.5

    margin = [ left, bottom, right, top ] * dpi

    ;im = objarr(cols,rows)
    im = objarr(cols*rows)

    for ii = 0, n_elements(im)-1 do begin

        im[ii] = image2( $
            data[*,*,ii], $
            X, Y, $
            /current, /device, $
            layout=[cols,rows,ii+1], $
            margin=margin, $
            title=title[ii], $
            _EXTRA = e)

        tx = (im[ii].position)[2]
        ty = (im[ii].position)[3]
        resolve_routine, 'text2', /either
        t = TEXT2( $
            alph[ii], target=im[ii] )

    endfor

    ;save2, 'test.pdf', /add_timestamp 

end

pro IMAGE_ARRAY_WRAPPER, data, _EXTRA=e
    IMAGE_ARRAY, data ; , $ .... other stuff
end
