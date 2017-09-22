;; Last modified:   21 September 2017 01:59:17

fontname = "Times"
fontsize = 9
font_props = { $
    font_name : fontname, $
    font_size : fontsize+2, $
    font_style : 1, $
    xtickfont_name : fontname, $
    ytickfont_name : fontname, $
    xtickfont_size : fontsize, $
    ytickfont_size : fontsize, $
    xtickfont_style : 0, $
    ytickfont_style : 0 $
}

cols = 2
rows = 2
b = 0.1
l = 0.1
t = 0.02
r = 0.02
gap = 0.02
resolve_routine, "positions", /either
pos = positions( cols, rows, b=b, l=l, t=t, r=r, gap=gap )

w = window(dimensions=[ cols*400, rows*400])
p = objarr(cols*rows)

for i = 0, cols*rows-1 do begin


    p[i] = plot( result[i,*], $
        /current, $
        position = pos[*,i], $
        xtitle="possible frequencies", $
        ytitle="power", $
        _EXTRA=font_props $
        )

    ax = p[i].axes
    if pos[0,i] ne l then ax[1].showtext = 0
    if pos[1,i] ne b then ax[0].showtext = 0

endfor

end
