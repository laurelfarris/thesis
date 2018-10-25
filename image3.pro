

;- 24 October 2018

function IMAGE3_wrapper, $
    data, $
    rows=rows, $
    cols=cols, $
    title=title, $
    _EXTRA=e

    common defaults
    resolve_routine, 'get_position', /either

    sz = size(data, /dimensions)
    if n_elements(sz) eq 2 then n = 1 else n = sz[2]

    wx = 8.5
    wy = 11.0
    dw
    win = window( dimensions=[wx,wy]*dpi, /buffer )

    width = 2.0
    left = 0.75
    top = 0.75
    xgap = 1.50
    ygap = 0.75

    im = objarr(N)

    for ii = 0, N-1 do begin
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

    sz = size(data, /dimensions)
    if n_elements(sz) eq 2 then N = 1 else N = sz[2]

    ; Use optional kw to add letter to each input title?
    title = alph[0:N-1]

    im = image3_wrapper( $
        data, $
        rows = 1, $
        cols = 1, $
        wx = 8.5, $
        wy = 11.0, $
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



end
