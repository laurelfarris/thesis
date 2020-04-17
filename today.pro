;+
;- 17 April 2020
;-
;- Modified code copied from Notes/2020-03-05.pro
;-



buffer=1
;-
;- center coords of ROI
center = [382,192]
;-
;-
;-  'offset' = distance between ROI center and tip of arrow
offset = 10; + 5
;-
;-  'arrow_mag' = "magnitude" of the arrow (length of arrow shaft).
arrow_mag = 25
;-
;-
;- separate elements of center array into x and y coords.
x0 = center[0]
y0 = center[1]
;-
;-
;- 'xycomp' = length of the x and y vector components of the arrow
;-    (sloppy variable name, but all I can come up with right now).
;-  Value is calculated from arrow_mag using Pythagorean theorem, and determines
;-   x1 and y1 (the coords of the arrow end not pointing at the ROI).
xycomp = sqrt( (arrow_mag^2)/2 )
;-
;-
;- X and Y args for ARROW function (endpoint coords of arrow graphic).
x2 = x0 + offset
y2 = y0 - offset
x1 = x2 + xycomp
y1 = y2 - xycomp
;-




;+
;--- Overlay arrows on existing graphic (created elsewhere)
;-

resolve_routine, 'arrow2', /is_function
;-
;test = arrow2( [10,50], [10,50], color='magenta', line_thick=3.0, $
;    fill_background=1 )
myarrow = objarr(2)
for cc = 0, 1 do begin
    myarrow[cc] = ARROW2( $
        [x1,x2], [y1,y2], $
        target=im[cc+2], $
        thick=3.0, $
        line_thick=2.0, $
        head_angle=30, $   ;- default in my subroutine (arrow2) = 45 degrees.
        head_size=0.5, $    ;- forgot what this is...
        fill_background=1 )
        ;buffer=buffer )
endfor
;-
save2, filename + '_arrow'
;-



;----------------------------------------------------------------------


;-
;- Everything else in this code is just notes, not needed for future ARROW func.
;-

;- other values used while playing with IDL's ARROW function... is fun :)
;xx = [385, 395]
;yy = [172, 182]
;
;x1 = 10
;x2 = 50
;y1 = 20
;y2 = 80


;-
;- Many of the input args for X and Y... Some may be incorrect.
;-  All are probably useless, but I'm wary of deleting anything.
;myarrow = ARROW2( $
    ;[ [x1,x2], [y1,y2] ], $
    ;[x1,x2]+10, [y1,y2], $
    ;[ [x0+rr, x0+(2*rr)], [y0+rr, y0+(2*rr)] ], $
    ;[ xx, yy], $
    ;[20, 10]+150, [20, 50]+20, $
    ;[20, 10]+250, [20, 50]+20, $
    ;)


;mypolygon1.delete
;mypolygon2.delete

;rr = 4
;mypolygon1 = polygon2( center=[x1, y1], dimensions=[rr,rr], /data )
;mypolygon2 = polygon2( center=[x2, y2], dimensions=[rr,rr], /data )

end
