
;- Last modified:    26 April 2019
;-   Added symbol kw

;- 02 November 2018 (from Enote on subroutines):
;- Need to be able to call LC routine for any length of time (full data set, small
;- flares before and after, etc. Label ticks outside of main subroutine? Takes
;- longer, but may be easier way to separate things, and leave less important
;- stuff for later)


;- xdata = m x n array
;-   m: array of, e.g. JDs for each LC or frequencies for each Power spec.
;-   n: one x array for each y array
;- ydata = m x n array
;-   m: array of data points for each LC, power spectrum, whatev.
;-   n: # curves

;-------------------------
;- 16 November 2018
;- color and name are currently required input.
;- Wrote this for a specific task, so it's okay for now.
;- Not likely to be plotting light curves without assigning names or colors.

;- 25 January 2019
;-   I assume that was before I added the wrapper... currently looks like
;-   string array of colors can be defined using @color, and
;-   NAME defaults to an array of empty strings, one for each plot.
;-------------------------

;- TO DO:
;-   If x dimensions don't match y, replicate the array over dimension=2 so
;-     it's the same size as y.













function WRAP_BATCH_PLOT, $
    xdata, ydata, $
    wx = wx, $
    wy = wy, $
    ;margin=margin, $
    ;-  replace 4 kws with one?
    left = left, $
    right = right, $
    bottom = bottom, $
    top = top, $
    color=color, $
    name=name, $
    linestyle = linestyle, $
    thick = thick, $
    buffer=buffer, $
    symbol=symbol, $
    _EXTRA = e


; For single panel, pick margins, and use window dimensions to set width/height
;  (the other unknown)

    common defaults

;    win_scale = 1.0
;    ;wy = 3.00*win_scale
;    wx = 8.00*win_scale
;    wy = 4.00*win_scale


    if buffer eq 1 then $
        win = window( dimensions = [wx,wy]*dpi, buffer=1 ) $
    else $
        win = window( dimensions = [wx,wy]*dpi, location=[500,0] )


    x1 = left
    y1 = bottom
    x2 = wx - right
    y2 = wy - top
    position = [x1,y1,x2,y2]*dpi

    sz = size(ydata, /dimensions)
;    if n_elements(sz) eq 1 then begin
;        ydata = reform(ydata, sz[0], 1, /overwrite)
;        xdata = reform(xdata, sz[0], 1, /overwrite)
;        sz = size(ydata, /dimensions)
;    endif
;
;    if not keyword_set(xtitle) then xtitle = " "
;    if not keyword_set(ytitle) then ytitle = " "
;    if not keyword_set(name) then name = strarr(sz[1])

    ;s;ymbol = [ 'Circle', 'Square' ]

    plt = objarr(sz[1])

    for ii = 0, sz[1]-1 do begin

        ;- batch_plot_2 modification: axis_style=1 if ii=0 (i.e. first iteration), and
        ;-   axis_style=4 if ii>0 (no axes, keep margins so multiple graphics are aligned properly).

        plt[ii] = PLOT2( $
            xdata[*,ii], ydata[*,ii], $
            /current, /device, $
            overplot = ii<1, $
            position = position, $
            ;xtitle = xtitle, $
            ;ytitle = ytitle, $
            ;axis_style=axis_style, $  --> set in batch_plot_2
            color = color[ii], $
            symbol = symbol[ii], $
            name = name[ii], $
            linestyle = linestyle[ii], $
            thick = thick[ii], $
            ;symbol = symbol[ii], $
            ;xmajor=, $
            xminor=5, $
            ymajor=5, $
            ;yminor=, $
            xticklen=0.025, $
            yticklen=0.010, $
            _EXTRA = e )
    endfor


    ;- Add some extra white space between plot lines and x-axes.
    ;yr = plt[0].yrange
    ;delt = 0.05*(yr[1] - yr[0])
    ;plt[0].yrange = [ yr[0]-delt, yr[1]+delt ]
    ;-  Messes up attempts to shift_ydata after creating plt...


    ;- Display index (frame #) on upper x-axis.
    ;    ax[2].title = 'Index'
    ;    ax[2].minor = 4
    ;    ax[2].showtext = 1

    ;- args, modified versions are passed back to caller
    xdata = reform(xdata)
    ydata = reform(ydata)

    return, plt

    ;- Need to do all overplots of flare lines, periods of interest, etc.
    ;- before making legend... unless there's a way to add targts to
    ;- an existing legend.
end



function BATCH_PLOT, $
    xdata, ydata, $
    _EXTRA = e

    ;- transpose(xdata) -- in case, e.g. [2,1000] instead of [1000,2]


    sz = size(ydata, /dimensions)
    ;- If ydata only contains one plot (no oplots):
    if n_elements(sz) eq 1 then begin
        ydata = reform(ydata, sz[0], 1, /overwrite)
        xdata = reform(xdata, sz[0], 1, /overwrite)
        sz = size(ydata, /dimensions)
    endif

    @color

    name = strarr(sz[1])
    linestyle = make_array( sz[1], value='-', /string )
    thick = make_array( sz[1], value=0.5, /float )

    symbol = make_array( sz[1], value="None" )

    plt = WRAP_BATCH_PLOT( $
        xdata, ydata, $
        wx = 8.0, $
        wy = 3.0, $
        left = 1.00, $
        right = 1.10, $
        bottom = 0.5, $
        top = 0.2, $
        ;top = 0.3, $  --> batch_plot_2 value ... not a fundamental change.
        buffer = 1, $
        ;overplot = 0, $
        name = name, $
        color = color, $
        linestyle = linestyle, $
        thick = thick, $
        symbol = symbol, $
        _EXTRA = e )

    return, plt
end
