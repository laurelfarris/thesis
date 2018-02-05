;; Last modified:   05 February 2018 13:16:27

GOTO, START


r = 500

; Center coordinates of AR
xc = 2400
yc = 1650
temp = a6data[ xc-r:xc+r-1, yc-r:yc+r-1, 150:400 ]

; Center coordinates of quiet region
xc = 2000
yc = 2400
quiet = a6data[ xc-r:xc+r-1, yc-r:yc+r-1, 150:400 ]


START:
align_cube3, quiet, temp, shifts




STOP
xstepper, temp, xsize=512, ysize=512

im = image( (a6data[*,*,0])^0.5, margin=0, layout=[1,1,1] )

end
