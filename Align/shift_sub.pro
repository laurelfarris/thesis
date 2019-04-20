;; Last modified:   13 February 2018 01:02:58



;+
; NAME: SHIFT_SUB
; PURPOSE:
;     Shift an image with subpixel accuracies
; CALLING SEQUENCE:
;      Result = shift_sub(image, x0, y0)
; HISTORY
;      2004 August, J. Chae, Added the keyword:cubic  for cubic spline interpolation option
;-

function shift_sub, image, x0, y0, cubic=cubic

if fix(x0)-x0 eq 0. and fix(y0)-y0 eq 0. then return, shift(image, x0, y0)

s =size(image)
x=findgen(s(1))#replicate(1., s(2))
y=replicate(1., s(1))#findgen(s(2))
x1= (x-x0)>0<(s(1)-1.)
y1= (y-y0)>0<(s(2)-1.)

;; compiling shift_sub with this statement gave an error...
;;   "Return statement can't have values"...
;;return, interpolate(image, x1, y1)

arr = interpolate(image, x1, y1)
return, arr

end
