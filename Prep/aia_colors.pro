;- LAST MODIFIED:
;-   25 July 2019 -- changed arg "wave" to kw "wave=wave" to
;-     achieve same calling sequence as ssw routine "aia_intscale.pro"
;-      --> AIA_INTSCALE( data, wave=wave, exptime=exptime )
;- 
;+ 


;function aia_colors, wave, load=load, syntax=syntax
function AIA_COLORS, wave=wave, load=load

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


    ;ct = [ [r], [g], [b] ]
    ct = transpose([ [r], [g], [b] ])
    ;- switching from [256, 3] to [3, 256], tho may not matter... pretty
    ;-  sure rgb_table kw can deal with either one (30 July 2019)


    return, ct


end
