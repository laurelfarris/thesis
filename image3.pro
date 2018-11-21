

;- 24 October 2018

function IMAGE3_wrapper, $
    data, $
    wx = wx, $
    ;wy = wy, $
    ;width = width, $
    ;height=height, $
    left = left, right = right, xgap = xgap, $
    top = top, bottom = bottom, ygap = ygap, $
    rows=rows, cols=cols, $
    title=title, $
    cbar=cbar, $
    _EXTRA=e

    common defaults
    resolve_routine, 'get_position', /either

    sz = size(data, /dimensions)
    if n_elements(sz) eq 2 then n = 1 else n = sz[2]

    width = (wx - ( left + right + (cols-1)*xgap )) / cols
    height = width * float(sz[1])/sz[0]

    wy = top + bottom + (rows*height) + (rows-1)*xgap

    win = window( dimensions=[wx,wy]*dpi, buffer=0 )

    im = objarr(N)

    for ii = 0, N-1 do begin
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
            /current, /device, $
            position=position*dpi, $
            title = title[ii], $
            _EXTRA=e )
    endfor

    return, im
end


function IMAGE3,  $
    data, $
    _EXTRA=e


    ;- use third dimension of sz to set up defaults
    ;sz = size(data, /dimensions)
    ;if sz eq 2 then data = reform(data, sz[0], sz[1], 1)
    ;sz = size(data, /dimensions)
    ;if sz eq 2 then begin
    ;    print, "Reform function did not work. Returning."
    ;    return
    ;endif

    common defaults

    sz = size(data, /dimensions)
    if n_elements(sz) eq 2 then N = 1 else N = sz[2]

    ; Use optional kw to add letter to each input title?
    title = alph[0:N-1]

    ;- margins = 0.5 inches, or 0.2 inches with no labels

    im = image3_wrapper( $
        data, $
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



;- Images I need to make:
;-      * full disk
;-      * AR images (closeup)
;-      * polygons - boxes overlaid to mark subregions
;-      * contours of HMI B_LOS or continuum to mark umbra/penumbra
;-      * powermaps
;-      * subregions
;-      * WA plots - techically images
;-      * array of images/maps for my own reference
;-      *
;-      *
;- Keep routines that create graphics separate from those that
;-   calculate and/or collect all the data.


;- 23 October 2018
;- image3 takes 3D data cube and arrays of image kws, then loops through them.
;- Not meant to be called just like IDL's image, so
;-   use whatever keywords you need.
