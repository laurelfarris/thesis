
; Last modified:    Sat 09 Apr 2017
; Programmer:       Laurel Farris
; Description:      General configurations that apply to all graphics.


; for myPlot, make xdata and ydata keywords, and use indgen(...) for xdata
; when not specified.

; Make a split routine for just making plots that don't intend to put
; in paper? This would be a good place to keep lines for adding titles,
; legends, text, anything to keep track of all important info.
; Maybe just make one best suited for making graphics when advisor is
; looking over my shoulder: shows every bit of important information,
; no matter how ugly.



fontsize = 10

plot_props = { $
    current        : 1, $
    device         : 1, $
    font_size      : fontsize, $
    ytickfont_size : fontsize, $
    xtickfont_size : fontsize, $
    axis_style     : 2, $
    xstyle         : 1, $
    ystyle         : 3, $
    xtickdir       : 0, $
    ytickdir       : 0, $
    xticklen       : 0.1/wy, $
    yticklen       : 0.1/wx, $
    xsubticklen    : 0.5, $
    ysubticklen    : 0.5, $
;    xminor         : 9, $
    yminor         : 4 }

scatterplot_props = { $
    symbol     : 'circle', $
    sym_size   : 2.0, $
    sym_thick  : 2.0, $
    sym_filled : 1 }

image_props = { $
    ;'rgb_table', intarr(256,3), $
    font_size      : fontsize, $
    current        : 1, $
    device         : 1, $
    ytickfont_size : fontsize, $
    xtickfont_size : fontsize, $
    axis_style     : 2, $
    xtickdir       : 0, $
    ytickdir       : 0, $
    xsubticklen    : 0.5, $
    ysubticklen    : 0.5, $
    xminor         : 5, $
    yminor         : 5  $
}

legend_props = { $
    font_size : fontsize, $
    device  : 1, $
    ;sample_width : 1, $
    ;horizontal_spacing : 0.06, $
    ;horizontal_alignment : 0.75, $
    linestyle : 6, $
    shadow : 0 }

cbar_props = { $
    font_style  : "italic", $
    font_size   : fontsize-1, $
    textpos     : 1, $
    border      : 1, $
    ticklen     : 0.3, $
    subticklen  : 0.5 $
    }
