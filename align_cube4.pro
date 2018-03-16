
; \begin{verbatim}
;+
; NAME : alignoffset
; PURPOSE :
;        Determine the offsets of an image with respect to a reference image
; CALIING SEQUENCE
;       OFFSET  =  alignoffset(IMAGE, REFERENCE, Cor)
; INPUTS:
;      IMAGE         the object image
;      REFERENCE     the reference image
; OUTPUT:
;     OFFSET         a two-element array of the offset values
;                    defined by  OFFSET  = (i, j) - (l, m)
;                    where (i, j) is the object image coordinates of a feature
;                   and (l, m),  its reference image coordinates.
;  OPTIONAL OUTPUT:
;       Cor        the maximum correlation coefficient
;
; REMARK:
;            FFT method is used to mximize the cross-correlation
; HISTORY:
;      1999 May,   J. Chae
;      2004 Decemebr, J. Chae: Subtract mean values and apply the window function before calculating correlation
;-
function alignoffset, image, reference, cor
                                   ;  Check compatibility

    si = size(image)
    sr = size(reference)

    if not(si(1) eq sr(1) and si(2) eq sr(2)) then begin
     print, 'Incompatible Images : alignoffset'
    return, [0,0.]
    endif
                      ;

    nx =  2^fix(alog(si(1))/alog(2.))
    nx = nx*(1+(si(1) gt nx))
    ny =  2^fix(alog(si(2))/alog(2.))
    ny = ny*(1+(si(2) gt ny))

                      ; Subtract median values

    image1= image  - mean(image)
    reference1 = reference -mean(reference)
                   if nx ne si(1) or ny ne si(2) then begin
                   image1 = congrid(image1, nx, ny, cubic=-0.5)
                   reference1 = congrid(reference1, nx, ny, cubic=-0.5)
                   endif

                   ; Maximize cross-correlation over the indeteger pixels


    sigma_x = nx/6.
    sigma_y = ny/6.
    xx=findgen(nx)# replicate(1., ny)
    xx=xx-nx*(xx ge nx/2)
    yy=replicate(1.,nx) # findgen(ny)
    yy = yy - ny*(yy ge ny/2)
    window = shift(exp(-0.5*((xx/sigma_x)^2+(yy/sigma_y)^2) ), $
                    nx/2, ny/2)
    window = sqrt(window)

    ;window=1.

    cor = float(fft(fft(image1*window, 1)*fft(reference1*window, -1), -1))

    tmp = max(cor, s)
    x0 = s(0) mod nx  & x0 = x0 - nx*(x0 gt nx/2)

    y0 = s(0) / nx  & y0 = y0 - ny*(y0 gt ny/2)

                   ; Maximize the cross-correlation over the subpixels
    cc = (shift(cor, -x0+1, -y0+1))(0:2, 0:2)
    x1 = (cc(0,1)-cc(2,1))/(cc(2,1)+cc(0,1)-2.*cc(1,1))*.5
    y1 = (cc(1,0)-cc(1,2))/(cc(1,2)+cc(1,0)-2.*cc(1,1))*.5
    x = x0+x1
    y = y0+y1
    if n_params() ge 3 then begin
    image1= shift_sub(image1, -x, -y)
    i=findgen(si(1))#replicate(1., si(2))+x
    j=replicate(1., si(1))#findgen(si(2))+y
    w=i ge 0 and i le si(1)-1 and j ge 0 and j le si(2)-1.
    cor = total(image1*reference1*w)/sqrt(total(image1^2*w)*total(reference1^2*w))
    endif
    return, [float(x)*si(1)/nx, float(y)*si(2)/ny]

end


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


;; 2018 March 05 - Made a few tweaks:
;; Both subroutines are included in the same file for easy reference.
;; align_cube3.pro statements are being run at the main level.

ref = cube[*,*,373]
sz = size(cube, /dimensions)
n_align = 6

;; 2xNxi array for shifts in x and y for every image, for a total of N images,
;;    and i alignments
shifts = fltarr( 2, sz[2], n_align )


;; Calculate shifts
for j = 0, n_align-1 do begin
    for i = 0, sz[2]-1 do begin

        offset = ALIGNOFFSET( cube[*, *, i], ref )
        ;break (or something similar if DON'T want to apply shifts to cube.

        cube[*, *, i] = SHIFT_SUB( cube[*, *, i], -offset[0], -offset[1] )

        ;; Append offsets for the i-th image to the 'shifts' array
        shifts[*, i, j] = -offset

    endfor
endfor

end
