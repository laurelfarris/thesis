; Last modified:    06 April 2018
; Programmer:       Laurel Farris
; Description:      subroutines with custom default configurations

; Make a split routine for just making plots that don't intend to put
; in paper? This would be a good place to keep lines for adding titles,
; legends, text, anything to keep track of all important info.
; Make additional routine best suited for making graphics when advisor is
; looking over my shoulder: Something I can call quickly and that
; shows every bit of important information, no matter how ugly.

; Don't appear to get errors even if e is undefined.
; Also keywords don't have to already be present in order to
; redefine them (as in, don't need a default rgb_table to
; pass a different one to image2.

; ~@grahpics:
; defaults = graphics(), where graphics returns defaults
;if n_elements(e) ne 0 then e = { defaults, e }

;scatterplot_props = { $
;    symbol     : 'circle', $
;    sym_size   : 2.0, $
;    sym_thick  : 2.0, $
;    sym_filled : 1 }

; .run graphics just so I can declare the defaults common block
pro graphics
    common defaults, fontsize, dpi
    fontsize = 10
    dpi = 96
    return
end
