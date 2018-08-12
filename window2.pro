;; Last modified:   30 May 2018 11:09:03


function GET_WINDOW, $
    wx=wx, wy=wy, location=location, buffer=buffer

    ;win = GetWindows( 'Name of Window', /current, NAMES=window_names )

    common defaults

    win = GetWindows( /current, NAMES=window_names )
    print, 'Current window: ', window_names

    if win eq !NULL then $
        win = window( dimensions=[wx,wy]*dpi, location=location, buffer=buffer )
    endif else begin
        win.erase
    endelse

    return, win
end

function WINDOW2, _EXTRA=e
    win = get_window( $
        wx = 8.5, $
        wy = 5.5, $
        buffer = 1 $
        )
    return, win
end
