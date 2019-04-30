;+
;- LAST MODIFIED:
;-   Wed Jan 30 20:00:58 MST 2019
;-
;- PURPOSE:
;-   Overplot vertical lines on existing plot
;-
;- INPUT:
;-   plt (current plot object)
;-   xindices -- array of x-indices to plot
;-
;- KEYWORDS:
;-   bg (background) -- set to plot lines behind all others.
;-
;- OUTPUT:
;-
;- TO DO:
;-   input yrange instead of using plt to get yrange inside this code?
;-   As long as code still has access to the plot to put the lines on it...



pro oplot_vertical_lines
;pro oplot_horizontal_lines
;pro oplot_lines

    ;- 20 April 2019
    ;- From comp book p. 10: musings about user entering 2 arrays
    ;-  and then this subroutine should figure out whether they're horizontal
    ;-  or vertical, b/c one arg would be an array and the other would be
    ;-  just the x or y coord? Not sure actually... never did write a good
    ;-  routine for general plotting of horizontal and/or vertical lines.
;- NOTE:
;-   Notes on oplot_vertical_lines in comp book p 10 -- might be helpful
;-
end


pro HLINE, $
    plt, $
    yindices, $
    linestyle=linestyle, $
    name=name, $
    bg=bg, $
    _EXTRA=e



    nn = n_elements(yindices)

    xrange = plt.xrange

    hor = objarr(nn)
    foreach yy, yindices, jj do begin
    
        hor[jj] = plot( $
            xrange, $
            [yy, yy], $
            /current, $
            /overplot, $
            thick = 0.5, $
            ;linestyle = jj+1, $
            linestyle = linestyle[jj], $
            ystyle = 1, $
            ;color = color[jj], $
            name = name[jj], $
            _EXTRA=e )

        if keyword_set(bg) then hor[jj].Order, /SEND_TO_BACK
    endforeach
    return
end


pro VLINE, $
    plt, $
    xindices, $
    bg=bg, $
    _EXTRA=e


    nn = n_elements(xindices)

    yrange = plt.yrange

    ;color = ['gainsboro', 'light gray' ]
    ;-  ideas for light shades

    vert = objarr(nn)
    foreach xx, xindices, jj do begin
    
        vert[jj] = plot( $
            ;[ xx, xx ], $
            ;yrange, $
            xx, yy, $
            /current, $
            /overplot, $
            thick = 0.5, $
            linestyle = jj+1, $
            ystyle = 1, $
            ;color = color[jj], $
            color = 'gainsboro', $
            ;name = name[jj], $
            _EXTRA=e )
        if keyword_set(bg) then vert[jj].Order, /SEND_TO_BACK
    endforeach
    return
end

    ; . . . . . . . . . . .
    ; [1, '1111'X]


    ; ....................
    ;[1, '5555'X]


    ; __  __  __  __  __
    ;[1, 'F0F0'X]
    ;[1, '6666'X]
    ;[1, '3C3C'X] ; shift 'F0F0' so it's symmetric


    ; __ . __ . __ . __ . __ .
    ;[1, '4FF2'X]


    ; __ . . __ . . __ . . __
    ;[1, '23E2'X]


    ; ___ .. ___ .. ___ .. ___
    ;[1, '47E2'X]


    ; __  . . .  __  . . .  __
    ;[1, '48E2'X]


    ; 1  0001
    ; 2  0010
    ; 3  0011
    ; 4  0100
    ; 5  0101
    ; 6  0110
    ; 7  0111

    ; C  1100
    ; D  1101
    ; E  1110
    ; F  1111


    ;- Dots:
    ; 1111 - spread out
    ; 5555 - closer together

    ;- Dashes
    ; 3333
    ; F0F0

    ;- Dash dot
    ; 7272

    ;- Dash dot dot (IDL doesn't have a linestyle option for this...)
    ; 7F92
    ; 4FF2 --> symmetry

    ;- Dash dot dot dot
    ; 7C92
