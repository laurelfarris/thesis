;; Last modified:   30 May 2018 11:09:03


; Even if I don't use this in subroutines, can still be a hepful
; reference on how to handle and return windows and their properties,
; examples using NAME and 'names', etc.

; Take lots of notes here! Just remember to refer to it...


; To-Do     Add kw option to reverse wx and wy? E.g. landscape...


function WINDOW2, dimensions=dimensions, _EXTRA=e

    common defaults

    ; Syntax:
    ;  win = GetWindows( 'Name of Window', /current, NAMES=window_names )

    win = GetWindows( /current, NAMES=window_names )
    ;win = GetWindows( NAMES=window_names )

    ;win = GetWindows( name )
    ; NOTE: window_names will be undefined if window is NULL



    ;; Create new window
    if win eq !NULL then begin

        if not keyword_set(dimensions) then begin
            wx = 8.5
            wy = 11.0
            dimensions = [wx,wy]*dpi
        endif

        win = WINDOW( $
            dimensions = dimensions, $
            location=[500,0], $
            buffer = 0, $
            name = 'No-Name figure. Sad figure', $
            title = 'Title', $
            window_title = 'Window Title', $
            _EXTRA=e )

        print, 'New window: "', win.name, '"'

    ;; Erase existing window
    endif else begin
        ;count = n_elements(window_names)
        print, 'Current window: "' , window_names, '"'
        win.erase
    endelse

    return, win

end
