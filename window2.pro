;; Last modified:   23 May 2018 16:19:13




function window2


    ; 2 possible inputs:
    ;   span two columns (8.5) or one (8.5/2)
    ;   ratio of wy to wx

    common defaults

    win = getwindows()
    if ( win[0] eq !NULL ) then begin
        wx = 8.5; / 2.0
        wy = 3.0; * 2.0
        w = window( dimensions=[wx,wy]*dpi, location=[600,0] )
        return, w
    endif else return, 0

end
