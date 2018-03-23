; Last modified:   23 March 2018 16:34:21

; Call routine to make array of positions, then use positions to
; get window dimensions.


; Call IDL> @mywindow

dpi = 96
margin = [1.0, 1.0, 1.0, 1.0]
position = GET_POSITION( layout=layout, margin=margin, dpi=dpi )
wx = max( position[2,*] ) + margin[2]
wy = max( position[3,*] ) + margin[3]
win = window( dimensions=[wx, wy]*dpi, location=[2,0]*dpi )

; Scale position to be consistent with /device for graphics.
position = position*dpi
