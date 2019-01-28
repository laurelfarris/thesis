

;- 24 October 2018

;- Input 3D data cube and arrays of image kws, then loops through them.
;- Not meant to be called just like IDL's image, so
;-   use whatever keywords you need.


;- Does this get errors if product of default rows and cols (both=1)
;-   doesn't match number of images in input array?


;- 14 December 2018
;- Loop to place images in window could either depend on rows and cols,
;- or on sz[2] from input array... like how IDL often has multiple kws
;- that could do the same thing or similar, but one will always override
;- the other.



;- 24 January 2019
;-   Commented line adding letter (a) to title.
;-   Was probably using that when imaging arrays of BDA power maps
;-    a couple months ago.


;- 27 January 2019
;- Having problems with get_position, so using layout/margin for now.


function IMAGE3_wrapper, $
    data, $
    XX, YY, $
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
    ;- REFORM(data) is applied before this routine is called,
    ;-   so this shouldn't ever be true, and should be able to delete these lines.
    ;- Unless I use the simple one-line and don't bother reforming data...
    ;- Will have to test that at some point.
    ;- Depends on what else sz is used for after this point.


    ;- Use window width, margins (and xgap for multi-graphics) to set image width
    width = (wx - ( left + right + (cols-1)*xgap )) / cols
    ;print, width

    ;- Aspect ratio preserved for images, so scale height accordingly
    height = width * float(sz[1])/sz[0]
    ;print, height


    ;- Use top/bottom margins, ygap, and number of rows to determine window height.
    wy = top + bottom + (rows*height) + (rows-1)*ygap



    if keyword_set(buffer) then $
        win = window(dimensions=[wx,wy]*dpi, buffer=1) $
    else $
        win = window(dimensions=[wx,wy]*dpi, location=[250,0])

    im = objarr(nn)

    ;if not arg_present(XX) then XX = indgen(sz[0])
    ;if not arg_present(YY) then YY = indgen(sz[1])

    for ii = 0, nn-1 do begin
        position = GET_POSITION( $
            layout=[cols,rows,ii+1], $
            width=width, $
            height=height, $
            wx=wx, $
            left=left, $
            top=top, $
            xgap=xgap, $
            ygap=ygap )


        im[ii] = image2( $
            data[*,*,ii], $
            XX, YY, $
            /current, /device, $
            ;position=position*dpi, $
            layout = [cols,rows,ii+1], $
            margin = [left,bottom,right,top]*dpi, $
            title = title[ii], $
            _EXTRA=e )
        ;print, im[ii].position*wx


    endfor
    ;txt = ADD_LETTERS_TO_FIGURE( target=im )
    return, im
end


function IMAGE3, data, XX, YY, _EXTRA=e

    common defaults


    sz = size(data, /dimensions)

    ;- If data is 2D array (just one image), adjust dimensions to 2D.
    ;-   (Need second dimension to use sz[2] a couple lines down...).
    if n_elements(sz) eq 2 then $
        data = reform( data, sz[0], sz[1], 1, /overwrite )
    sz = size(data, /dimensions)
    nn = sz[2]

    ;- Or, pretty sure could just use this one line.. though may
    ;- have to make a correction in image3_wrapper...
    ;if n_elements(sz) eq 2 then nn = 1 else nn = sz[2]


    ;- X and Y should be optional...
    if n_elements(XX) eq 0 then XX = indgen(sz[0])
    if n_elements(YY) eq 0 then YY = indgen(sz[1])

    im = image3_wrapper( $
        data, $
        XX, YY, $
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
        title = alph[0:nn-1], $
        _EXTRA = e)
    return, im
end
