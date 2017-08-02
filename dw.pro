;; Last modified:   08 July 2017 13:07:47
;; Delete all open graphic windows

pro dw

    win = getwindows()

    for i = 0, n_elements(win)-1 do $
        if ( win[i] ne !NULL ) then win[i].close



end
