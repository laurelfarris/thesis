;; Last modified:   14 October 2017 10:58:03



function ALL_PROPS
    ;; To be called for any type of graphic (all panels... so not position)

    fontname = "Helvetica"
    fontname = "DejaVuSans"
    fontsize = 10
    fontstyle = 0
    props = { $
        font_name : fontname, $
        font_size : fontsize, $
        font_style : fontstyle, $
        xtickfont_name : fontname, $
        ytickfont_name : fontname, $
        xtickfont_size : fontsize, $
        ytickfont_size : fontsize, $
        xtickfont_style : fontstyle, $
        ytickfont_style : fontstyle, $
        xsubticklen : 0.5, $
        ysubticklen : 0.5, $
        xstyle : 1 $
    }

    return, props

end


function MY_PLOT, x, y, layout=layout, image_dimensions=image_dimensions, txt=txt,_EXTRA=ex
    ;; Call to plot ANY data. Specifics are set in the main level


    ;; Layout
    cols = layout[0]
    rows = layout[1]
    width = image_dimensions[0]
    height = image_dimensions[1]

    ;; Add extra kws to defaults
    props = ALL_PROPS()
    if ( n_elements(ex) ne 0 ) then $
        props = create_struct( props, ex )

    ;; Positions (may want to change margin and gap, but subroutine to set it all up shouldn't change)
    margin = 50.0
    gap = 10.0
    POSITIONS, cols, rows, width, height, margin, gap, $
        position, dim

    ;; Make graphics
    sz = size(y, /dimensions)
    p = objarr(sz[0])

    for i = 0, cols*rows-1 do begin

        p[i] = plot( x, reform(y[i,*]), $
            /current, $
            dimensions=dim, $
            /device, $
            position=position[*,i], $
            _EXTRA=props $
        )

        pos = p[i].position
        x1 = round(pos[0]*dim[0])
        y1 = round(pos[1]*dim[1])
        ax = p[i].axes

        if x1 ne margin then ax[1].showtext = 0
        if y1 ne margin then ax[0].showtext = 0

        if keyword_set(txt) then begin
            tx = dim[0]*pos[0]+gap
            ty = dim[1]*pos[3]-gap
            t = text(tx, ty, txt[i], /device, alignment=0.5, vertical_alignment=0.5)
        endif

    endfor


    return, p

end


;; All the science is done in this part


x = (findgen(1000)/1000.) * 6*!PI
y = findgen(4, n_elements(x) )
y[0,*] = sin(x)
y[1,*] = sin(x-10)
y[2,*] = 10.*sin(x)
y[3,*] = 10. + sin(x)


p = MY_PLOT( x, y, layout=[2,2], image_dimensions=[400,400], $
    txt = [ '(a)', '(b)', '(c)', '(d)', '(f)', '(g)' ], $
        xmajor = 5, $
        xminor = 4, $
        ;xshowtext = 1, $
        ;yshowtext = 1, $
        xtitle="time", $
        ytitle="f(time)", $
        yminor = 4 $
        )

;leg = legend( /normal, $
;    position=[0.15,0.92], $
;    horizontal_alignment='LEFT', $
    ;vertical_spacing=0.03, $
;    linestyle='none', $
;    shadow=0, $
;    font_name="Helvetica", $
;    font_size=10 )




end
