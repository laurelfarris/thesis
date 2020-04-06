;+
;- DATES MODIFIED:
;-   25 July 2019 -- changed arg "wave" to kw "wave=wave" to
;-     achieve same calling sequence as ssw routine "aia_intscale.pro"
;-      --> AIA_INTSCALE( data, wave=wave, exptime=exptime )
;-
;-  04 April 2020
;-    Renamed to aia_gct.pro ('g' stands for "get" colortable, as opposed to
;-    SSW routine aia_lct, where I assume 'l' stands for "load" ct, which is
;-    not helpful for me.
;-
;- ROUTINE:
;-   aia_gct.pro
;-
;- EXTERNAL SUBROUTINES:
;-   SSWIDL procedure AIA_LCT
;-
;- PURPOSE:
;-   Returns color table in a single variable, using the three arrays returned
;-     by AIA_LCT for red, green, and blue.
;-   Perhaps not necessary, but manually creating the color table every time I
;-     want to show aia colors is a pain in the ass. Simple to just call this.
;-
;- USEAGE:
;-   ct = AIA_GCT( wave=wave, load=load )
;-
;- INPUT:
;-   wave : central wavelength for which to load characteristic aia color,
;-     in INTEGER form.
;-
;- KEYWORDS (optional):
;-   load : Set to "make the color table active".
;-     Usually don't need this, but couldn't hurt I suppose.
;-
;- OUTPUT:
;-   color table that can be used as input kws for IMAGE function, or whatev.
;-
;- TO DO:
;-   [] item 1
;-   [] item 2
;-   [] ...
;-
;- AUTHOR:
;-   Laurel Farris
;-


function AIA_GCT, color_table_array, wave=wave, load=load; , $
    ;syntax=syntax

;+
;- Had trouble with printing calling syntax? Or just wasn't top priority?
;-  (04 April 2020)
;-
;    if keyword_set(syntax) then begin
;        print, ''
;        print, 'syntax: IDL> result = AIA_GCT( wave=wave, load=load )'
;        print, 'Returns color table for specified AIA channel.'
;        return, 0
;    endif


    ;- Is there a way to test if no keywords are set at all?
    ;- Would be easier to get syntax help by calling function with no arguments,
    ;-  rather than knowing the "syntax" keyword, which kind of defeats the purpose...
    if not keyword_set(wave) then begin
        print, ''
        print, 'syntax: IDL> result = AIA_GCT( wave=wave, load=load )'
        print, 'Returns color table for specified AIA channel.'
        return, 0
    endif

    aia_lct, r, g, b, wave=fix(wave), load=load


    ;ct = [ [r], [g], [b] ]
    ct = TRANSPOSE([ [r], [g], [b] ])
    ;- switching from [256, 3] to [3, 256], tho may not matter...
    ;-  documentation for IMAGE indicates rgb_table kw can be set to
    ;-  3xN OR Nx3 array (30 July 2019, reworded 04 April 2020)


    return, ct


end
