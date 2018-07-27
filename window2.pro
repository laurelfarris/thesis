;; Last modified:   30 May 2018 11:09:03



function WINDOW2, _EXTRA=e

    ;win = GetWindows( 'Name of Window', /current, NAMES=window_names )


    common defaults

    win = WINDOW( $
        dimensions=[8.5,11.0]*dpi, $
        buffer = 1, $
        location = [500,0], $
        _EXTRA=e )


    return, win

end
