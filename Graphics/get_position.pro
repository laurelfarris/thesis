;- Last modified:    26 July 2018
;-
;-
;- Returns graphic position in the form [x1, y1, x2, y2], in inches.
;-
;- Arguments:
;-   layout = [cols,rows,loc]
;-   (same as IDL's layout kw, where loc starts at 1, not 0.)
;-
;- Keywords:
;-   left, bottom, right, top --> margins around outside of entire array.
;-   xgap, ygap
;-   aspect_ratio --> width/height
;-     NOTE: set aspect_ratio for PLOTS ONLY, not images,
;-             (which is why this kw is not included in the wrapper;
;-               dimensions for images are determined in image3.pro).
;-             Also, be careful to set to set as width divided by height,
;-               not height/width
;-
;- TO DO:
;-   *Write two separate routines:
;-     One where user inputs window dimensions and
;-       code calculates width and height of each panel,
;-       and one where user inputs width and height, with the potential of
;-       extra white space at far right side of page.
;-      Then just see which one you prefer to use.
;-
;-   *Determine top based on whether a title is set for each graphic.
;-      i.e. make it smaller if no title is set.
;-      Could set up separate margin structure for each scenario...
;-
;- 16 December 2018
;-   Testing for plots now.
;-   Trying version where user sets up everything EXCPT width/height.


function WRAP_GET_POSITION, $
    layout=layout, $
    left=left, $
	right=right, $
	top=top, $
    bottom=bottom, $
    width=width, $
    height=height, $
    xgap=xgap, $
    ygap=ygap, $
    wx=wx, $
    wy=wy, $
    aspect_ratio=aspect_ratio


    common defaults

    
    ;- Get dimensions of current window
    ;-   Should this go here or in wrapper??
;    dim = (GetWindows(/current)).dimensions / dpi
;    wx = float(dim[0])
;    wy = float(dim[1])


    cols = layout[0]
    rows = layout[1]
    location = layout[2]



    ;- Use width of WINDOW, along with left/right margins, xgap, and num(cols)
    ;-   to determine width of each plot.
    ;- If a_r NOT set, then fill the window space with plots,
    ;-   or set to 1.0 by default.


    ;- 28 January 2019 - back to too many keywords, just to make this routine
    ;-   work again (i.e. user sets width and height in addition to x/y gaps).
    ;width = (wx - ( left + right + (cols-1)*xgap )) / cols


    ;- Setting height like this should only be used for plotting, not images:
    ;if keyword_set(aspect_ratio) then $
    ;    height = width / aspect_ratio $
    ;else $
    ;    height = width ;- aka, =1 by default
        ;height = (wy - ( top + bottom + (cols-1)*xgap )) / cols


    ;- Set window height (wy) using graphic layout and dimensions.
    ;- NOTE:  not actually creating window here, just using wx and wy
    ;-   to determine position values.
    ;-  --> plot3 routine should take care of this.

    ;wy = (rows*height) + (rows-1)*ygap + top + bottom


    ;-----------------------------------------------------------------------------------
    ;- image_array = [cols, rows]
    ;-   Each element = location (layout[2]) of current graphic.
    ;-   Add 1 because layout locations start at 1, not 0.
    image_array = indgen(cols,rows) + 1


    image_array = reform( image_array, cols, rows )
    ;- Why is reform necessary? (This is why we comment our codes!)
    ;- Is it to remove any extra dimensions of length 1, or
    ;-   to ADD extra dimensions?
    ;help, image_array
    ;- --> add extra dimension, changed im_array from [3] to [3,1]

    coords = array_indices( $
        image_array, where( image_array eq location ))

    i = coords[0]
    j = coords[1]
    ;-----------------------------------------------------------------------------------


    ;- NOTE: wy is used to position first graphic relative to TOP of page
    ;-   rather than botoom. wx is not used at all.

    x1 = left + i*(width + xgap)
    x2 = x1 + width

    ;- Set y positions relative to BOTTOM of window.
    ;y1 = bottom + j*(height + ygap)
    ;y2 = y1 + height

    ;- Set y positions relative to TOP of window.
    y2 = wy - top - j*(height + ygap)
    y1 = y2 - height

    position = [ x1, y1, x2, y2 ]; * dpi
    ;- position currently in INCHES.
    ;- Uncomment dpi to get pixels, or remember to multiply by dpi and
    ;-    set /device (which should be set anyway).
    

    ;- Make structure so that window dimensions may also be returned.
    ;- This might also have a place in plot3 rather than here.
    ;- In fact, this should only be called once for each panel, not
    ;- when overplot is set, and certainly shouldn't have to determine
    ;- window dimensions more than once...

;    struc = { $
;        position : [ x1, y1, x2, y2 ], $
;        dimensions : [wx, wy] }
;        wx : wx, wy : wy }
;    return, struc
        
    return, position
end



function GET_POSITION, layout=layout, _EXTRA = e

    common defaults

    ;- Get dimensions of current window
    dim = (GetWindows(/current)).dimensions / dpi
;    wx = float(dim[0])
    wy = float(dim[1])


    top    = 0.25  ;- Needs space for GRAPHIC title (if set...)
    bottom = 0.50  ;- Needs space for xtitle AND x tick labels


    ;ygap   = top+bottom  ;- space between panels with space for
    ;- xtitle and ticks for top panel, and title of panel underneath,
    ;- except in cases where only the top of graphics have a title.
    ;- So ... Only if both top and bottom axes are labeled.
    ;- Should this really be the default?
    ;- Also, if user doesn't set ygap but they do set top and/or bottom,
    ;- then ygap is defined using the wrong values...
    ;-
    ;- 12 February 2019
    ;- ygap shouldn't be defined here anyway... sometimes I want top
    ;- and bottom labled, but want minimal, if any space between panels...
    ygap   = 0.75  ;- matching to default xgap for now..


    width = 2.0
    height = 2.0
    
    ;- margin space needed for ytitle/ticklabels
    ;-   depends on numerical value of ydata.
    xgap   = 0.75  ;-
    left   = 0.75  ;-
    right  = 0.10  ;-  Depends on whether ax[3] is labeled
    ;- 28 January 2019
    ;- probably don't need "right" or "bottom", since "left", "width", and "xgap"
    ;-  will already leave behind a set amount of white space
    ;-  (whatever is remaining on the page), or maybe the image will fall off
    ;-  the edge if one of those is too high...
    ;- In fact, they're not even in use anymore, only in commented code.
    ;-  Actually just realized, you could set the margins only and NOT
    ;-  the width or height if you just wanted to fill the width or height
    ;- of the page as much as possible,
    ;-  and didn't care about the figure dimensions.
    ;- Also, this may matter more
    ;- for plots... doing images right now, so doesn't seem as obvious.


    ;- NOTE: no default value for aspect_ratio because
    ;- don't want this kw set for images, only plots.
    ;- 

    wx = 8.0

    position = WRAP_GET_POSITION( $
        layout = layout, $
        wx = wx, $
        wy = wy, $
        width = width, $
        height = height, $
        left = left, $
        right = right, $
        bottom = bottom, $
        top = top, $
        xgap = xgap, $
        ygap = ygap, $
        ;aspect_ratio = 1.0, $
        _EXTRA = e )

    return, position

end
