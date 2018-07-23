;; Last modified:   30 May 2018 11:09:03


function window2_old, scale=scale

    common defaults


    wx = 8.5
    wy = 11.0

    if keyword_set(scale) then begin
        wx = wx * scale 
        wy = wy * scale
    endif

    w = window( dimensions=[wx,wy]*dpi )

    return, w

end

function GET_WINDOW, wx=wx, wy=wy, lx=lx, ly=ly, buffer=buffer

    common defaults
    win = window( $
        dimensions=[wx,wy]*dpi, $
        location=[lx,ly], $
        buffer=buffer )
    return, win

end


function WINDOW2, delete_existing=delete_existing, _EXTRA=e


    if keyword_set( delete_existing ) then dw

    win = GET_WINDOW( $
        wx = 8.5, $
        wy = 11.0, $
        lx = 500, $
        ly = 0, $
        buffer = 0, $
        _EXTRA=e )

    return, win

end
