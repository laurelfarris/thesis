;-
;- Last modified:       05 October 2018
;-
;-
;-



function IMAGE_ARRAY, $
    data, $
    ;X, Y, $
    ;dic, $
    cols = cols, $
    rows = rows, $
    title = title, $
    colorbar = colorbar, $
    _EXTRA=e

    common defaults


    im = objarr(cols*rows)

    sz = size(data, /dimensions)
    ;wy = wx * (float(sz[1])/sz[0]) * (float(rows)/cols)
    resolve_routine, 'get_position', /either
    resolve_routine, 'colorbar2', /either

    for ii = 0, n_elements(im)-1 do begin

        ; add space to right margin to leave room for colorbar?
        position = GET_POSITION( layout=[cols,rows,ii+1], ygap=0.40 )

        im[ii] = IMAGE2( $
            data[*,*,ii], $
            X, Y, $
            /current, $
            /device, $
            title = title[ii] + '; AR_2a', $
            position=position*dpi, $
            _EXTRA = e )
    endfor
    return, im

    ;- Make separate routine to create colorbar, then return to this level.
    if keyword_set(colorbar) then begin
        for ii = 0, n_elements(im)-1 do begin
            ;im[ii].position = im[ii].position
            ;c = colorbar2( 
        endfor
    endif
end


;- Create 3D array of images you want to show.

data = [ [[A[0].data[*,*,0]]], [[A[1].data[*,*,0]]], [[hmi_mag[*,*,0]]], [[hmi_cont[*,*,0]]] ]

aia1600 = dictionary( $
    "data", A[0].data[*,*,0], $
    "title", A[0].name)

aia1700 = dictionary( $
    "data", A[1].data[*,*,0], $
    "title", A[1].name)

hmi_mag = dictionary( $
    "data", hmi_mag[*,*,0], $
    "title", "HMI B$_{LOS}$")

end
