;+
;- LAST MODIFIED:
;-   12 February 2019
;-
;- PURPOSE:
;-   Create graphic with array of images from input imdata cube.
;-
;- INPUT:
;-   3D data cube
;-
;- KEYWORDS:
;-   title - in ARRAY form to loop through each iteration of image2.
;-
;- OUTPUT:
;-   graphic
;-
;- TO DO:
;-   [] See if errors happen when the product of default rows and cols
;-      doesn't match number of images in input array.
;-   [] Add colorbar option
;-
;- NOTE:
;-   This is NOT meant to be called just like IDL's image, so
;-   use whatever keywords you need.



function IMAGE3_wrapper, $
    data, $
    ;XX, YY, $
    wx = wx, $
    ;wy = wy, $
    ;width = width, $
    ;height=height, $
    left = left, right = right, xgap = xgap, $
    top = top, bottom = bottom, ygap = ygap, $
    rows=rows, cols=cols, $
    title=title, $
    cbar=cbar, $
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


    ;- Image width:
    ;-  Calculate starting with window width (wx) and subtract space allotted to
    ;-     left/right margins and xgap (if applicable).
    ;- Image height:
    ;-   Calculate using aspect ratio of data cube.
    width = (wx - ( left + right + (cols-1)*xgap )) / float(cols)
    height = width * float(sz[1])/sz[0]
;    print, width
;    print, height

    ;- Window height (wy):
    wy = top + bottom + (rows*height) + (rows-1)*ygap
    ;wy = wy*1.7
    ;print, top + bottom + (rows*height) + (rows-1)*ygap


    if keyword_set(buffer) then $
        win = window(dimensions=[wx,wy]*dpi, buffer=1) $
    else $
        win = window(dimensions=[wx,wy]*dpi, location=[250,0])
;-
;-
;-
;-

    ;print, win.dimensions/dpi

    im = objarr(nn)

    for ii = 0, nn-1 do begin
        position = GET_POSITION( $
            layout=[cols,rows,ii+1], $
            width=width, $
            height=height, $
            wx=wx, $
            left=left, $
            right=right, $
            top=top, $
            bottom=bottom, $
            xgap=xgap, $
            ygap=ygap )


;- 14 December 2018
;- Loop to place images in window could either depend on rows and cols,
;- or on sz[2] from input array... like how IDL often has multiple kws
;- that could do the same thing or similar, but one will always override
;- the other.


        im[ii] = image2( $
            data[*,*,ii], $
            ;XX, YY, $
            /current, /device, $
            position=position*dpi, $
            ;layout = [cols,rows,ii+1], $
            ;margin = [left,bottom,right,top]*dpi, $
            ;- 27 January 2019
            ;- Having problems with get_position, so using layout/margin for now.
            title = title[ii], $
            _EXTRA=e )
    endfor

    ;txt = ADD_LETTERS_TO_FIGURE( target=im )
    ;- 24 January 2019
    ;-   Commented this line... probably from imaging arrays of BDA power maps
    ;-    a couple months ago.

    return, im
end


function IMAGE3, data, $
    ;XX, YY, $
    _EXTRA=e


    common defaults

    ;- If data is 2D array (just one image), adjust dimensions to 2D, since
    ;-   second dimension is needed to use sz[2] a couple lines down.

    sz = size(data, /dimensions)

    if n_elements(sz) eq 2 then $
        data = reform( data, sz[0], sz[1], 1, /overwrite )
    if (n_elements(sz) ne 2) AND (n_elements(sz) ne 3) then begin
        print, ""
        print, "Data has ", strtrim(sz[0],1), " dimensions."
        print, "image3.pro was not written to handle this..."
        print, ""
        stop
    endif


;    if n_elements(XX) eq 0 then XX = indgen(sz[0])
;    if n_elements(YY) eq 0 then YY = indgen(sz[1])


    im = IMAGE3_wrapper( $
        data, $
        ;XX, YY, $
        buffer = 1, $
        rows = 1, $
        cols = 1, $
        ;width = , $
        ;height = , $
        wx = 8.0, $
        ;wy = 11.0, $
        top = 0.2, $
        left = 0.2, $
        right = 0.2, $
        bottom = 0.2, $
        xgap = 0.2, $
        ygap = 0.2, $
        title = alph[0:sz[2]-1], $
        _EXTRA = e)
    return, im

end
