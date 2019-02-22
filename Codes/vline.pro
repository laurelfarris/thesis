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

end
