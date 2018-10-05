;-
;- Last modified:       05 October 2018
;-
;-
;-



pro IMAGE_ARRAY, $
    ;data, X, Y, $
    dic, $
    cols = cols, $
    rows = rows, $
    _EXTRA=e


    common defaults

    print, dic.Keys()
    data = dic.data

    ;im = objarr(cols,rows)
    im = objarr(cols*rows)

    sz = size(data, /dimensions)
    wx = 8.5
    wy = 11.0
    ;wy = wx * (float(sz[1])/sz[0]) * (float(rows)/cols)
    win = window( dimensions=[wx,wy]*dpi, buffer=1 )

    for ii = 0, n_elements(im)-1 do begin

        ; add space to right margin to leave room for colorbar?
        position = GET_POSITION( layout=layout )

        im[ii] = IMAGE2( $
            data[*,*,ii], $
            X, Y, $
            /current, $
            /device, $
            position=position, $
            _EXTRA = e )

    endfor
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
