

;- Thu Dec 20 07:25:24 MST 2018

;function aia_colors, wave, load=load, syntax=syntax
function aia_colors, wave, load=load

;    if keyword_set(syntax) then begin
;        print, ''
;        print, 'syntax: IDL> result = AIA_COLORS( wave=wave, load=load )'
;        print, 'Returns color table for specified AIA channel.'
;        return, 0
;    endif


    ;- Is there a way to test if no keywords are set at all?
    ;- Would be easier to get syntax help by calling function with no arguments,
    ;-  rather than knowing the "syntax" keyword, which kind of defeats the purpose...
    if not keyword_set(wave) then begin
        print, ''
        print, 'syntax: IDL> result = AIA_COLORS( wave=wave, load=load )'
        print, 'Returns color table for specified AIA channel.'
        return, 0
    endif

    aia_lct, r, g, b, wave=fix(wave), load=load
    ct = [ [r], [g], [b] ]
    return, ct


end
