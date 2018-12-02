
; Last modified:    28 November 2018

; Name of file = name of routine called by user.
; x and y titles both need to be optional somehow...
; ytitle changes depending on whether plotting values that are
; normalized, absolute, shifted, exptime-corrected, etc.


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


;- 16 November 2018
;- color and name are currently required input.
;- Wrote this for a specific task, so it's okay for now.
;- Not likely to be plotting light curves without assigning names or colors.

;- TO DO:
;-   If x dimensions don't match y, replicate the array over dimension=2 so
;-     it's the same size as y.



function WRAP_BATCH_PLOT, $
    xdata, ydata, $
    wx = wx, $
    wy = wy, $
    left = left, $
    right = right, $
    bottom = bottom, $
    top = top, $
    color=color, $
    name=name, $
    linestyle = linestyle, $
    thick = thick, $
;    xtitle=xtitle, $
;    ytitle=ytitle, $
    buffer=buffer, $
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


    plt = objarr(sz[1])

    for ii = 0, sz[1]-1 do begin

        plt[ii] = PLOT2( $
            xdata[*,ii], ydata[*,ii], $
            /current, $
            /device, $
            overplot = ii<1, $
            position = position, $
            ;symbol = 'Circle', $
            ;xtitle = xtitle, $
            ;ytitle = ytitle, $
            color = color[ii], $
            name = name[ii], $
            linestyle = linestyle[ii], $
            thick = thick[ii], $
            ;xmajor=, $
            xminor=5, $
            ymajor=5, $
            ;yminor=, $
            xticklen=0.025, $
            yticklen=0.010, $
            _EXTRA = e )

    endfor



    ;- Display index (frame #) on upper x-axis.
    ;    ax[2].title = 'Index'
    ;    ax[2].minor = 4
    ;    ax[2].showtext = 1

    xdata = reform(xdata)
    ydata = reform(ydata)

    return, plt


    ;- Need to do all overplots of flare lines, periods of interest, etc.
    ;- before making legend... unless there's a way to add targts to
    ;- an existing legend.

end



function BATCH_PLOT, $
    xdata, ydata, $
    ;color=color, $
    ;name=name, $
    ;xtitle=xtitle, $
    ;ytitle=ytitle, $
    ;buffer=buffer, $
    _EXTRA = e


    sz = size(ydata, /dimensions)
    if n_elements(sz) eq 1 then begin
        ydata = reform(ydata, sz[0], 1, /overwrite)
        xdata = reform(xdata, sz[0], 1, /overwrite)
        sz = size(ydata, /dimensions)
    endif

    color = [ $
        'black', $
        'blue', $
        'red', $
        'lime green', $
        'deep sky blue', $
        'dark orange', $
        'dark cyan', $
        'dark orchid', $
        'sienna', $
        'dim gray', $
        'hot pink', $
        '' ]

    name = strarr(sz[1])
    linestyle = make_array( sz[1], value='-', /string )
    thick = make_array( sz[1], value=1.0, /float )

    plt = WRAP_BATCH_PLOT( $
        xdata, ydata, $
        wx = 8.0, $
        wy = 3.0, $
        ;xtitle = " ", $
        ;ytitle = " ", $
        ;overplot = 0, $
        name = name, $
        color = color, $
        linestyle = linestyle, $
        thick = thick, $
        buffer = 1, $
        left = 1.00, $
        right = 1.10, $
        bottom = 0.5, $
        top = 0.2, $
        _EXTRA = e )

    return, plt
end
