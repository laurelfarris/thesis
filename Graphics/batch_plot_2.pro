;+
;- DATE CREATED:
;-   13 August 2019
;-
;- ROUTINE:
;-   batch_plot_2.pro
;-
;- EXTERNAL SUBROUTINES:
;-
;- PURPOSE:
;-   copied content of batch_plot.pro to try replacing /overplot kw with new approach of
;-   putting second plot on same window and graphic position as the first plot,
;-   but without /overplot, plt2 stays "detached" and keeps its own y-labels.
;-
;-
;-
;- USEAGE:
;-   plt = BATCH_PLOT_2( xdata, ydata, ... )
;-      (same as batch_plot[1])
;-
;- INPUT:
;-
;- KEYWORDS (optional):
;-
;- OUTPUT:
;-
;- TO DO:
;-
;- KNOWN BUGS:
;-   Errors when creating/accessing axes
;-       (according to comments in plot_spectra.pro from 19 June 2019, which have now
;-          been removed along with (commented) calls/references to version _2 so I won't
;-          get as confused in the future, one less output file if I use grep again to
;-          search for "batch_plot_2*" in */*.pro
;-
;-   Appears that most plotting routines are still using the first version...
;-
;-  ==>>  most of this file is unaltered since copied from batch_plot.pro (21 August 2020)
;-
;-
;- AUTHOR:
;-   Laurel Farris
;-
;-
;- 26 April 2019
;-   Added symbol kw
;-
;- 02 November 2018 (from Enote on subroutines):
;-   Need to be able to call LC routine for any length of time (full data set, small
;-   flares before and after, etc. Label ticks outside of main subroutine? Takes
;-   longer, but may be easier way to separate things, and leave less important
;-   stuff for later)
;-
;-
;- xdata = m x n array
;-   m: array of, e.g. JDs for each LC or frequencies for each Power spec.
;-   n: one x array for each y array
;- ydata = m x n array
;-   m: array of data points for each LC, power spectrum, whatev.
;-   n: # curves
;-
;--
;- 16 November 2018
;- color and name are currently required input.
;- Wrote this for a specific task, so it's okay for now.
;- Not likely to be plotting light curves without assigning names or colors.
;-
;- 25 January 2019
;-   I assume that was before I added the wrapper... currently looks like
;-   string array of colors can be defined using @color, and
;-   NAME defaults to an array of empty strings, one for each plot.
;--
;-
;- TO DO:
;-   If x dimensions don't match y, replicate the array over dimension=2 so
;-     it's the same size as y.
;-




function WRAP_BATCH_PLOT_2, $
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
    overplot=overplot, $
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



    ; ---------------------------------------------------------------

    ;- transpose(xdata) -- in case, e.g. [2,1000] instead of [1000,2]

;    ;If ydata only contains one plot (no oplots):
;    sz = size(ydata, /dimensions)
;    if n_elements(sz) eq 1 then begin
;        ydata = reform(ydata, sz[0], 1, /overwrite)
;        xdata = reform(xdata, sz[0], 1, /overwrite)
;        sz = size(ydata, /dimensions)
;    endif

    ; -- Better way (02 Sep. 2021)

    sz = size(ydata, /dimensions)

    ; f-ing REBIN! Why was this so hard to find???
    ; Duplicate xdata if ydata contains multiple plots (2D)
    ;  (if xdata dims already match sz, this shouldn't change anything)
    ; Still seems a waste of memory to duplicate array when should just
    ;  use the same xdata for each iteration of plotting loop below,
    ;  but not sure how to do that and not high priority right now...
;    if size(xdata,/n_dim) ne size(ydata,/n_dim) then begin
;        xdata = rebin( xdata, sz[0], sz[1] )
;    endif

    ;if size(ydata, /n_dimensions) eq 1 then begin
    ; NOTE: (size(array))[0] == size(array, /n_dimensions)

    ; REFORM(arr) w/ no args or kws : dim =1 is removed otherwise NO CHANGE
    ;   (if statement above is not necessary... I think)
    xdata = reform(xdata)
    ydata = reform(ydata)

    ;symbol = [ 'Circle', 'Square' ]

    plt = objarr(sz[1])

    for ii = 0, sz[1]-1 do begin

        if not keyword_set( overplot ) then begin
            if ii eq 0 then axis_style = 1 else axis_style = 4 ; left/bottom | No axes, same margins
        endif else begin
            axis_style = 2
        endelse

        plt[ii] = PLOT2( $
            xdata[*,ii], ydata[*,ii], $
            /current, /device, $
            overplot=overplot, $
            position = position, $
            ;xtitle = xtitle, $
            ;ytitle = ytitle, $
            axis_style=axis_style, $
            color = color[ii], $
            symbol = symbol[ii], $
            name = name[ii], $
            linestyle = linestyle[ii], $
            thick = thick[ii], $
            ;symbol = symbol[ii], $
            ;xmajor=, $
            ;xminor=5, $ ;- set in CALL (point of wrapper... 3/14/2020)
            ;ymajor=5, $
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



function BATCH_PLOT_2, $
    xdata, ydata, $
    _EXTRA = e

    ; "wrapper" called by user - used to set default keywords

    sz = size(ydata, /dimensions)

    @color

    name = strarr(sz[1])
    linestyle = make_array( sz[1], value='-', /string )
    thick = make_array( sz[1], value=0.5, /float )

    symbol = make_array( sz[1], value="None" )

    plt = WRAP_BATCH_PLOT_2( $
        xdata, ydata, $
        wx = 8.0, $
        wy = 3.0, $
        left = 1.00, $
        right = 1.10, $
        bottom = 0.5, $
        ;top = 0.2, $
        top = 0.3, $
        buffer = 1, $
        overplot = 0, $
        name = name, $
        color = color, $
        linestyle = linestyle, $
        thick = thick, $
        symbol = symbol, $
        _EXTRA = e )

    return, plt
end
