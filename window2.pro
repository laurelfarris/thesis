;; Last modified:   30 May 2018 11:09:03

; Even if this isn't used in subroutines, still be a helpful reference on
; windows and their keywords, properties, methods, etc.

; To-Do     Add kw option to reverse wx and wy? E.g. landscape...

function WINDOW2, dimensions=dimensions, landscape=landscape, _EXTRA=e

    common defaults

    ; Syntax:
    ;  win = GetWindows( 'Name of Window', /current, NAMES=window_names )

    win = GetWindows( /current, NAMES=window_name )
    ; NOTE: window_names = variable with retrieved window name(s).
    ;         --> will be undefined if window is NULL

    ; Create new window
    if win eq !NULL then begin

        if not keyword_set(dimensions) then begin
            wx = 8.5
            wy = 11.0
            if keyword_set(landscape) $
                then dimensions = [wy,wx]*dpi $
                else dimensions = [wx,wy]*dpi
        endif

        win = WINDOW( $
            dimensions = dimensions, $
            ;location=[500,0], $
            buffer = 0, $
            name = 'No-Name figure. Sad figure', $
            title = 'Title', $
            window_title = 'Window Title', $
            font_size = fontsize, $
            _EXTRA=e )

        print, 'Created new window: "', win.name, '"'

    return, win ;-----

    ; Erase existing window (do this from calling routine, for now)
    endif else begin
        ;count = n_elements(window_names)
        print, 'Current window: "' , window_names, '"'
        win.erase
    endelse


end


function MAKE_WINDOW, _EXTRA=e

    ; Temporary function used inside plot_lc.pro

    common defaults
    wx = 8.5
    wy = 4.0

    win = GetWindows(/current)

    if win eq !NULL then begin
        win = window( $
            Name='LC', $
            ;window_title = '', $
            ;title = '', $
            dimensions=[wx,wy]*dpi, $
            buffer=1, $
            font_size=fontsize, $
            _EXTRA=e )
        print, 'Created window "', win.name, '"'
    endif else begin
        win.erase
        print, 'Erased window "', win.name, '"'
    endelse
    return, win
end
