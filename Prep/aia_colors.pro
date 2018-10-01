


function aia_colors, wave=wave, load=load, syntax=syntax

    if keyword_set(syntax) then begin
        print, ''
        print, 'syntax: IDL> result = AIA_COLORS( wave=wave, load=load )'
        print, 'Returns color table for specified AIA channel.'
        return, 0
    endif

    aia_lct, r, g, b, wave=fix(wave), load=load
    ct = [ [r], [g], [b] ]
    return, ct


end
