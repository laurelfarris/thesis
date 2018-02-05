;; Last modified:   27 June 2017 13:24:29




function MY_WINDOW, wx, wy, keep_windows=keep_windows

    win = getwindows( )
    if not keyword_set(keep_windows) then begin
        for i = 0, n_elements(win)-1 do $
            if ( win[i] ne !NULL ) then win[i].close
    endif

    return, window( dimensions=[wx, wy], location=[0,0], buffer=0 )

end
