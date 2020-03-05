;+
;- 05 March 2020
;-  Using same values for ROI center and rr (length of polygon side) from
;-    previous "today.pro" that created LC by averaging over a few pixels centered
;-    on the ROI, smoothing LC, etc, etc.
;-  Task for this code is probably simpler, just need to produce image of power
;-    map (also from previous today.pro) and overlay an arrow using IDL's
;-    ARROW function. See E-note for details on calling syntax, kws, etc,
;-    Greenie, p. 110. for diagrams & examples, and
;-   IDL coding note "2020-01-24.pro" (note that since the dates in the comments
;-     in that code are 19 and 23 January, so filename may change, but shld be able
;-     to find using grep command to search for "arrow" in the text.
;-
;- PURPOSE: overlay ARROW graphic on power map (any map), pointing at
;-   "interesting features" ... does not have to perfect or pretty (yet).
;-


;-----------------------------------------------------------------------------------


;+
;- User-defined values
;-


dz = 64

;- center coords of ROI
center = [382,192]

;- dimensions of (square) polygon centered on ROI;
;-  contains the pixels spatially averaged to obtain LCs (see previous today.pro),
;-   for a total area = rr x rr square pixels.
rr = 10

;- index of power map to image, where map was obtained from FFT of
;-   data from z_ind to z_ind+dz-1.
z_ind = 201

;-  'offset' = distance between ROI center and tip of arrow
offset = 5

;-  'arrow_mag' = "magnitude" of the arrow (length of arrow shaft).
arrow_mag = 20



;-----------------------------------------------------------------------------------
;+
;- general code (no user input required)
;-

x0 = center[0]
y0 = center[1]

;-
;title = A[cc].name + ' 3-minute power (' + time[z_ind] + ' - ' + time[z_ind+dz-1] + ')' ,$
;-   title kw passed to image2 (below) in following form each iteration:
;-
;- Title now defined outside image loop so that call to IMAGE is less cluttered.
;-



title = A.name + ' 3-minute power (' + time[z_ind] + ' - ' + time[z_ind+dz-1] + ')'
help, title
;-   title should be 2-element string array. If not, this won't work. (05 March 2020)
;-


;+
;--- Create powermap image
;-

dw
;for cc = 0, 1 do begin
for cc = 0, 0 do begin
    ;- overlaying ARROW graphic on 3-min powermap from AIA 1600Å channel only, for now.
    ;-
    time = strmid(A[cc].time,0,8)
    imdata = A[cc].map[*,*,z_ind]
    im = image2( $
        alog10(imdata), $
        margin=0.1, $
        title = title[cc], $
        rgb_table=AIA_COLORS( wave=fix(A[cc].channel) ) $
    )
    pol = polygon2( $
        target=im, $
        center=[x0, y0], $
        dimensions=[rr,rr], $
        color='black' $
    )
endfor



;+
;--- Create Arrow graphic on top of powermap
;-

;- 'xycomp' = length of the x and y vector components of the arrow
;-    (sloppy variable name, but all I can come up with right now).
;-  Value is calculated from arrow_mag using Pythagorean theorem, and determines
;-   x1 and y1 (the coords of the arrow end not pointing at the ROI).
xycomp = sqrt( (arrow_mag^2)/2 )


;- X and Y args for ARROW function (endpoint coords of arrow graphic).
x2 = x0 + offset
y2 = y0 - offset
x1 = x2 + xycomp
y1 = y2 - xycomp

;- create arrow graphic on current image
resolve_routine, 'arrow2', /is_function
myarrow = ARROW2( $
    [x1,x2], [y1,y2], $
    thick=3.0, $
    line_thick=2.0, $
    head_angle=30, $   ;- default in my subroutine (arrow2) = 45 degrees.
    ;head_indent=0, $  ;- default already = 0; can delete this line.
    ;head_size=0, $    ;- forgot what this is...
    fill_background=1 $
)

;--------------


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
