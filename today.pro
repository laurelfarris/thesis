;; Last modified:   24 April 2018 16:14:34

goto, start


; Images - label axes with arcsec

ax[2].tickname = strtrim(round(ax[0].tickvalues * 0.6),1)

; Put mini tests everywhere!

; AIA 304 data (April 10)

start:;------------------------------------------------------------------------------

; Movie actually runs faster when window is smaller

; 1700 easier to see at the current scale
temp = A[1].map
xstepper2, temp^0.5, scale=0.75, subscripts=[0:250]
; Have I done this yet? Made a bunch of images, but I don't think I ever
; looked at a movie of the power maps... not sure how that slipped my mind.

; Trim depending on where enhancement is
x1=0
y1=0
x2=499
y2=329
temp = temp[x1:x2,y1:y2,*]

; No movement:
composite = TOTAL( temp, 3 )
w = window2()
im = image2( $
    composite, $
    /current, /device, $
    layout=[1,1,1], margin=[1.0, 0.75, 0.25, 0.25], $
    xtitle='X (pixels)', $
    ytitle='Y (pixels)', $
    title=A[1].name, $
)
; Only way this differs from regular images is the data itself and the color bar.
; Even the data dimensions and axis labels are the same.

; Movement: Just describe in Conclusions for now.



; Another thing to be done LATER:
dz = 10
period = 1./((fourier2( indgen(dz), 24 ))[0,*])
stop

end
