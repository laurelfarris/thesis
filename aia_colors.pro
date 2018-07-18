


function aia_colors, wave=wave, load=load

    aia_lct, r, g, b, wave=fix(wave), load=load
    ct = [ [r], [g], [b] ]
    return, ct


end
