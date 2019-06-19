

;- Mon Dec 17 04:53:28 MST 2018

function mini_axis, plt;, location=location

    ;- From Old/plot_lightcurves_poster.pro,
    ;-   with a few modifications ( p--> plt, location )

    common defaults
    dz = 64

    ;- position of axis (data coordinates).
    ;-  "axis_range" --> x position
    ;-  "location"   --> y position

    x1 = 600 ; hard-coded... improve this later.
    x2 = x1+dz-1

    y = 3.e2
    ;y = (plt[0].yrange)[]

    ;- NOTE: if location isn't where you expect,
    ;-  see if plot is scaled in log space. If so, 0.5*yrange[1]
    ;-  will still be really close to the top.
    ;location = 0.5 * y2

    ;location = 5.6e2
    ;location = 1.e2


    ;- Make little axis bar showing width of dz
    dz_axis = axis( $
        'X', $
        location=y, $
        target=plt[0], $
        axis_range=[x1,x2], $
        major=2, $
        minor=0, $
        tickname=['',''], $
        tickdir=1, $
        textpos=1, $
        ;tickdir=(i mod 2), $
        tickfont_size = fontsize )


    resolve_routine, 'text2', /either
    txt = text2( $
        x1+(dz/2), $
        ;y+1500., $
        y+350, $ --> maps
        '$T=25.6 min$', $
        /data, $
        target = plt[0], $
        alignment = 0.5 ) ; center

    ;print, plt[0].yrange
    ;print, dz_axis.location
    ;print, convert_coord(txt.position, /normal, /to_data)

    return, dz_axis
end
