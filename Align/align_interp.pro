;; Last modified:   05 March 2018 23:14:16
; input:            shifts [ 2 x N ]; x/y shifts for N images


;- 23 July 2019
;- [] See "align.pro" for similar routine(s)



;; Read in unprocessed data cube for AIA 1600.
restore, 'aia_1600_cube.sav'
ref = cube[*,*,373]
sz = size(cube, /dimensions)
shifts     = fltarr( 2, sz[2] )
old_shifts = []
new_shifts = []


;;  Calculate shifts
for i = 0, sz[2]-1 do begin
    offset = alignoffset( cube[*,*,i], ref )
    shifts[*,i] = -offset
endfor
old_shifts = [ [[ old_shifts ]], [[ shifts ]] ]


;--------------------------------------------------------------------------------------
;; Plot shifts (one panel showing horizonal and vertical shifts).
;;   Interpolate to get CORRECT set of shifts
;; Plot shifts again. Make more corrections manually if needed.

;shifts = interpolate_shifts( old_shifts[*,*,a] )
shifts = interpolate_shifts( shifts )

shifts[*,250:330] = 0.0
shifts[*,450:510] = 0.0
shifts[*,600:*] = 0.0
plot_allshifts, shifts

;--------------------------------------------------------------------------------------

;; Save shifts
new_shifts = [ [[ new_shifts ]], [[ shifts ]] ]


;; Apply new shifts to cube
;;  (after confirming previous shifts look correct).
;new_shifts[0,311,0] = mean( [ new_shifts[0,310,0], new_shifts[0,312,0]] )

for i = 0, sz[2]-1 do begin
    cube[*,*,i] = shift_sub( $
        cube[*,*,i], $
        new_shifts[0,i,a], new_shifts[1,i,a])
endfor
a = a + 1


im = image( (cube[400:600,400:600, 0])^0.5, margin=0.0 )
im = image( (cube[400:600,400:600,-1])^0.5, margin=0.0 )


end
