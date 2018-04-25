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

pro define_block
    common defaults, fontsize, dpi
    fontsize = 10
    dpi = 96
    return
end

pro save2, name, _EXTRA=e

    path = '/home/users/laurel07/'
    filename = name + '.pdf'

    fls = file_search( path + filename )

    ;; Add option to either overwrite, or append file that already
    ;; exists with, e.g. '_old' or mark in some other way, e.g.:
    ; while fls ne "" ; i = i + 1 ; filename = basename + '_' + strtrim(i,1)
    ; keep appending _1, _2, etc. until no other file matches
    ; Set these equal to same values used when determining position?
    ; That only applies to individual panels, not entire figure.

    ; show time of creation on figure somewhere.

    w = getwindows(/current)
    dims = w.dimensions/96
    width = dims[0]
    height = dims[1]

    ; may not need wx and wy at all!

    if fls eq '' then begin
        fwin.save, path + filename, $
            page_size=[width,height], $
            width=width, height=height, _EXTRA=e
    endif else print, "File ", filename, " already exists."
    return
end


function window2, _EXTRA=e
    common defaults
    w = window( $
        dimensions=[8.5, 11.0]*dpi, $
        location=[500,0], $
        _EXTRA=e $
    )
    return, w
end

function image2, data, _EXTRA=e

    common defaults

    ;sz = size(data, /dimensions)
    ;if n_elements(sz) eq 2 then $
    ;    data = reform( data, sz[0], sz[1], 1, /overwrite)


    im = image( $
        data, $
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
        _EXTRA = e )

    return, im
end


function plot2, xinput, yinput, _EXTRA=e

    common defaults
    if yinput eq !NULL then begin
    ;if not arg_present(y) then begin
        y = xinput
        x = indgen( n_elements(y) )
    endif else begin
        y = yinput
        x = xinput
    endelse

    p = plot( $
        x, y, $
        font_size = fontsize, $
        ytickfont_size = fontsize, $
        xtickfont_size = fontsize, $
        axis_style = 2, $
        xtickdir = 0, $
        ytickdir = 0, $
        xsubticklen = 0.5, $
        ysubticklen = 0.5, $
        xminor = 5, $
        yminor = 5,  $
        xstyle = 1, $
        ystyle = 3, $
        _EXTRA = e )
    return, p
end


function text2, x, y, str=str, i, _EXTRA=e
    common defaults

    ; If one graphic is selected, it's returned in array 'graphics'.
    ; Need a way to select ALL graphics (without clicking)
    ;  in current window. ; See 'dw' routine.

    alph = string( bindgen(1,26)+(byte('a'))[0] )
    alph2 = '(' + alph + ')'
    if not keyword_set(str) then str = alph2[i]
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
    common defaults
    leg = legend( $
        font_size = fontsize, $
        linestyle = 6, $
        shadow = 0, $
        _EXTRA=e )
    return, leg
end

function colorbar2, _EXTRA=e
    common defaults
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


pro xstepper2, cube, scale=scale, _EXTRA=e
    ; Last modified:   21 March 2018 19:14:32

    sz = float(size( cube, /dimensions ))

    if not keyword_set(scale) then scale = 1

    y = 800 * float(scale)
    x = y * (sz[0]/sz[1])

    xstepper, cube, xsize=x, ysize=y, _EXTRA=e

end
