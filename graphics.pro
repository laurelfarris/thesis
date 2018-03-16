;; Last modified:   05 March 2018 17:31:34

; Last modified:    Sat 09 Apr 2017
; Programmer:       Laurel Farris
; Description:      General configurations that apply to all graphics.
;                       Call once to define common block, then shouldn't have to call again.



alph = string( bindgen(1,26)+(byte('a'))[0] )

dpi = 96

width=5.0
height=5.0

cols = 1
rows = 1

margin = [0.75, 0.50, 1.0, 0.75]
xgap=1.00
ygap=0.10

position = positions( $
    layout=[cols,rows], $
    margin=margin, $
    width=width, $
    height=height, $
    xgap=xgap, $
    ygap=ygap, $
    dpi=dpi )
if n_elements(size(position, /dimensions)) le 1 then $
    position = reform(position, 4, 1)

wx = max( position[2,*] ) + margin[2]
wy = max( position[3,*] ) + margin[3]
win = window( dimensions=[wx, wy]*dpi, location=[2,0]*dpi )

position = position*dpi
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
