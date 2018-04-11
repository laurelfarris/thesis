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


function image2, data, _EXTRA=e

    fontsize = 10

    ;sz = size(data, /dimensions)
    ;if n_elements(sz) eq 2 then $
    ;    data = reform( data, sz[0], sz[1], 1, /overwrite)


    im = image( $
        data, $
        font_size = 10, $
        ytickfont_size = fontsize, $
        xtickfont_size = fontsize, $
        axis_style = 2, $
        xtickdir = 0, $
        ytickdir = 0, $
        xticklen = 0.02, $
        yticklen = 0.02, $
        xsubticklen = 0.5, $
        ysubticklen = 0.5, $
        xminor = 5, $
        yminor = 5,  $
        _EXTRA = e )

    return, im
end


function plot2, xinput, yinput, _EXTRA=e

    if yinput eq !NULL then begin
    ;if not arg_present(y) then begin
        print, "no y argument"
        y = xinput
        x = indgen( n_elements(y) )
    endif else begin
        y = yinput
        x = xinput
    endelse

    fontsize = 10
    p = plot( $
        x, y, $
        font_size = fontsize, $
        ytickfont_size = fontsize, $
        xtickfont_size = fontsize, $
        axis_style = 2, $
        xtickdir = 0, $
        ytickdir = 0, $
        xticklen = 0.02, $
        yticklen = 0.02, $
        xsubticklen = 0.5, $
        ysubticklen = 0.5, $
        xminor = 5, $
        yminor = 5,  $
        xstyle = 1, $
        ystyle = 3, $
        _EXTRA = e )
    return, p
end


function text2, x, y, str, _EXTRA=e


    fontsize = 10
    t = text( $
        x, y, $
        str, $
        ;alph[i], $
        ;/normal, $  ; x,y relative to entire window (default)
        ;/relative, $ ; x,y relative to target
        ;/device, $  ; x,y in pixels
        ;target=p[i], $
        ;alignment=, $
        ;vertical_alignment=, $
        font_size=fontsize, $
        _EXTRA=e )
    return, t


    ; Extra stuff to figure out later:

    ; If one graphic is selected, it's returned in array 'graphics'.
    ; Need a way to select ALL graphics (without clicking)
    ;  in current window.
    ; See 'dw' routine.

    alph = string( bindgen(1,26)+(byte('a'))[0] )
    graphics = p.Window.GetSelect()
    for i = 0, n_elements(graphics)-1 do begin
        t = text( $
            x, y, $
            alph[i], $
            /device, /relative, $
            target=p[i], $
            ;alignment=, vertical_alignment=, $
            ;font_name=, $
            font_size=fontsize )
    endfor
end


function legend2, _EXTRA=e
    fontsize = 10
    leg = legend( $
        font_size = fontsize, $
        linestyle = 6, $
        shadow = 0, $
        _EXTRA=e )
    return, leg
end

function colorbar2, _EXTRA=e
    fontsize = 10
    c = colorbar( $
        ;target = graphic, $
        orientation = 1, $ ; 0 --> horizontal
        tickformat = '(F0.1)', $
        ;position = [], $
        textpos = 1, $ ; 1 --> right/above colorbar
        font_style = 2, $ ;italic
        font_size = fontsize, $
        border = 1, $
        ;ticklen = 0.3, $
        ;subticklen = 0.5, $
        ;major = 11, $
        ;minor = 5, $
        _EXTRA=e )
    return, c
end

function polygon2, x1, y1, x2, y2, _EXTRA=e

    ;x1 = 40
    ;x2 = 139
    ;y1 = 90
    ;y2 = 189

    rec = polygon( $
        [x1, x2, x2, x1 ], $
        [y1, y1, y2, y2 ], $
        data=1, $
        fill_transparency = 100, $
        linestyle = '--', $
        color='white', $
        _EXTRA=e )
    return, rec

end

