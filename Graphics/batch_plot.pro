;+
;-
;- LAST MODIFIED*:
;-
;-   07 August 2024
;-     Added 'else' to conditional test of buffer value
;-
;-   27 December 2027
;-           (Apparently I jumped forward in time... still only 2024 :)
;-    Merged "batch_plot.pro" & "batch_plot_2.pro"
;-     Old notes (justified merging, if not already the better way...) 
;-     • Appears that most plotting routines are still using the first version...
;-     •  => most of this file is unaltered since copied from batch_plot.pro (21 August 2020)
;-
;-   *08/13/2019 (Created)
;-   *08/14/2021 (version 1: "batch_plot.pro")
;-   *09/02/2021 (version 2: "batch_plot_2.pro"),
;-        before merging with current file: "batch_plot.pro" )
;- *based on ls timestamp in NMSU astro directory
;-


;- EXTERNAL FILES/SUBROUTINES:
;-   • Graphics/plot2.pro
;-   •     "_filenames_batch_plot.txt" = list of .pro files where "batch_plot*" appears
;-   •     Powercurves/batch_plot_2_OLD_20200613.pro ... ??
;-            (not sure about these last two...)
;-

;- PURPOSE:
;-   Handles plotting multiple curves on one set of axes

;- USEAGE / CALLING SYNTAX:
;-   plt = BATCH_PLOT( xdata, ydata, kw*=kw*, ... )
;-

;- INPUT: xdata, ydata = M x N arrays (x & y data points to plot)
;-    M = # data points / t_obs (JD, date/time, or simply numerical index)
;-    N = # plots, each a 1D array consisting of M data points,
;-             measured as a function of t_obs values in xdata
;-   xdata[m,n] = time or observation index
;-   ydata[m,n] = intensity or other measurement, corresponding to xdata arrays
;-        NOTE: the N time arrays in xdata (of length M)
;-          may be idenetical in the M-direction if t_obs is the same for all N plots
;- Optional kws (override defaults defined in batch_plot wrapper)
;-

;- TO DO:
;-   [] If x and y dimensions don't initally match,
;-       replicate the array** over dimension=2 so it's the same size as y.
;-           **what array? -27 Dec 2023
;-     8/7/2024 -- looks like I did this, but should test before deleting this task
;-   
;-   [] overplot flare lines, periods of interest, etc. BEFORE generating legend,
;-          unless new targets may be added to an existing legend...

;- Misc notes & comments (originally from either version, v1 &/or v2, who the heck knows):
;-
;-     26 April 2019:
;-       Added symbol kw
;-   
;-     02 November 2018 (from Enote on subroutines):
;-       Need to be able to call LC routine for any length of time (full data set, small
;-       flares before and after, etc. Label ticks outside of main subroutine? Takes
;-       longer, but may be easier way to separate things, and leave less important
;-       stuff for later)
;-   
;-     16 November 2018
;-       color and name are currently required input.
;-       Wrote this for a specific task, so it's okay for now.
;-       Not likely to be plotting light curves without assigning names or colors.
;-   
;-     25 January 2019
;-       I assume that was before I added the wrapper... currently looks like
;-       string array of colors can be defined using @color, and
;-       NAME defaults to an array of empty strings, one for each plot.

function WRAP_BATCH_PLOT, $  ; called by "wrapper" function BATCH_PLOT (defined below)
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
    

    common defaults

    ;    win_scale = 1.0
    ;    ;wy = 3.00*win_scale
    ;    wx = 8.00*win_scale
    ;    wy = 4.00*win_scale

    if buffer eq 1 then $
        win = window( dimensions = [wx,wy]*dpi, buffer=1 ) $
    else if buffer eq 0 then $
        win = window( dimensions = [wx,wy]*dpi, location=[500,0] ) $
    else begin
        print, "buffer = ", buffer, " ... may be defined incorrectly."
    endelse

    x1 = left
    y1 = bottom
    x2 = wx - right
    y2 = wy - top
    position = [x1,y1,x2,y2]*dpi

    sz = size(ydata, /dimensions)

    ; Make sure input arrays are of equal dimensions, and adjust xdata to match ydata if needed

    ; 1. One way:
    ;     Reform both arrays and redefine sz using new ydata dimensions
    ;         by testing if there's only one plot.. I guess?
    ;     if n_elements(sz) eq 1 then begin
    ;         ydata = reform(ydata, sz[0], 1, /overwrite)
    ;         xdata = reform(xdata, sz[0], 1, /overwrite)
    ;         sz = size(ydata, /dimensions)
    ;     endif

    ; 2. Better way: apply IDL function REBIN to modify x dims to match y dims (sz)
    ;     (rebinning an array with its current dimensions has no effect)

    if size(xdata, /n_dimensions) ne size(ydata, /n_dimensions) then begin
        xdata = rebin( xdata, sz[0], sz[1] )
        ; f-ing REBIN! Took forever to find/discover this...
    endif

    ; NOTE: (SIZE(array))[0] = SIZE( array, /n_dimensions )

    ;
    ; This duplicates the same M-element array N times to achieve xdata = [MxN] array,
    ;  which is a potential waste of memory, but in the routine's current form, is
    ;  not as straightforward as one might assume to use the same xdata array
    ;  for each loop iteration ... not worth spending time re-coding this more elegently.
    ; As it sits, xdata and ydata increase in index for every loop iteration)


    ; REFORM(arr) w/ no args or kws : dim =1 is removed otherwise NO CHANGE
    ;   (if statement above is not necessary... I think)

    xdata = reform(xdata)
    ydata = reform(ydata)

    ;+ PLOT +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    ;    if not keyword_set(xtitle) then xtitle = " "
    ;    if not keyword_set(ytitle) then ytitle = " "
    ;    if not keyword_set(name) then name = strarr(sz[1])


    ;symbol = [ 'Circle', 'Square' ]
    ;  ??? ==>> symbol should NOT be re-defined (or oringally defined) here!

    plt = objarr(sz[1])

    for ii = 0, sz[1]-1 do begin

        ;- Create new axes if overplot NOT set
        ;-    (mostly for multiple overlaid plots within multi-panel figure... I think.)


        ; 07 August 2024 -- not sure if any of this is necessary:
        ;        if not keyword_set( overplot ) then begin
        ;            if ii eq 0 then $
        ;                axis_style = 1 $   ; single x/y axes
        ;            else axis_style = 4    ; No axes, but same margins as if axes were present
        ;        endif else axis_style = 2  ; Box axes (upper & lower x-axes; left & right y-axes)


        ; v2 (initial reason for copying to ..._2 ??)
        ;   tried replacing /overplot kw with new approach of
        ;     putting second plot on same window and graphic position as the first plot,
        ;     but without /overplot, plt2 stays "detached" and keeps its own y-labels.
        ;
        ; 06 August 2024 ★ ★ ★
        ;   /overplot not set for 1600 and 1700 curves b/c each has its own y-axis, 
        ;         but IS set for any additional plots, such as flare BDA times, shading, smoothed LC, etc.

        plt[ii] = PLOT2( $
            xdata[*,ii], $
            ydata[*,ii], $
            /current, $
            /device, $
            overplot = ii<1, $     ; v1
            ;overplot=overplot, $  ; v2
            ;  (see comment about v2 and overplot above)
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
            ;
            ;xmajor= , $
            ;xminor=5, $
            ;ymajor=5, $
            ;yminor= , $
            ;xticklen=0.025, $
            ;yticklen=0.010, $
            ;  -- moved kw definitions to wrapper, which should pass them along to _EXTRA=e here...
            ;
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
end


function BATCH_PLOT, $
    xdata, ydata, $
    _EXTRA = e

    ;
    ; 8/07/2024 --
    ;   Function called directly from ML (or other module):
    ;     all kws not explicitly listed in BATCH_PLOT definition are included in _EXTRA=e;
    ;     call to WRAP_BATCH_PLOTS defined DEFAULT values of kws,
    ;     which are OVERWRITTEN by values defined in _EXTRA=e
    ;  
    ;   REMINDIER: purpose of wrappers is to set default kw values;  
    ;     necessary extra (and often confusing) step b/c can't set defaults in function definition
    ;

    sz = size(ydata, /dimensions)

    ;- If ydata only contains one plot (no oplots):
    if n_elements(sz) eq 1 then begin
        ydata = reform(ydata, sz[0], 1, /overwrite)
        xdata = reform(xdata, sz[0], 1, /overwrite)
        sz = size(ydata, /dimensions)
    endif


    ;- Graphics/color.pro -- IDL script (run LINE BY LINE)
    @color

    ; 8/07/2024 -- why are the following defined separately here instead of directly in call to wrapper?


    xticklen=0.025
    yticklen=0.010
    ;xticklen=0.03
    ;yticklen=0.012

    plt = WRAP_BATCH_PLOT( $
        xdata, $
        ydata, $
        ; 12 August 2024 -- added line to define wx (not sure why not included already...)
        wx = 8.0, $
        wy = 3.0, $
        left = 1.00, $
        right = 1.10, $
        bottom = 0.5, $
        top = 0.2, $
        ;top = 0.3, $
        buffer = 1, $
        ;overplot = 0, $
        color = color, $
        axis_style = 2, $
        linestyle = make_array( sz[1], value='-', /string ), $
        ;thick = [0.5,0.8], $
        ;thick = thick, $
        thick = make_array( sz[1], value=0.5, /float ), $
        symbol = make_array( sz[1], value="None" ), $
        ;name = name, $
        name = STRARR(sz[1]), $  ; string array used to refer to each graphic/plot
        ;ytitle = STRARR(sz[1]), $
        ;xtitle = STRARR(), $
        xminor=5, $
        ymajor=5, $
        xticklen=xticklen, $
        yticklen=yticklen, $
        ;xticklen=xticklen*1.2, $
        ;yticklen=yticklen*1.2, $
        ;stairstep=1  ;- e.g. detrended/flattend LCs, ~ { Milligan2017 }
        _EXTRA = e $
    )
    return, plt
end
