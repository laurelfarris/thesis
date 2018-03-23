;; Last modified:   21 March 2018 19:46:00

; Calculate shifts using alignoffset.pro.
; Make corrections if necessary.
; Save shifts.
; Apply corrected shifts to data cube using shift_sub.pro.
; Repeat.

; Regarding plots: after first alignment, "good" shifts overlap for
; horizontal and vertical, so can only see one. Need a different way to plot these.
;  (March 14)
; Maybe color axes on each side, and shift/scale differently?

pro plot_all_shifts, shifts
    ;; shifts should be 2xN array (no third dimension)
    @graphics
    ydata = shifts
    xdata = indgen( (size(shifts, /dimensions))[1] )
    p = objarr(2)
    p[0] = plot( xdata, ydata[0,*], $
        color='dark cyan', $
        dimensions=[800,800], $
        layout=[1,1,1], $
            xtitle = 'alignment run #', $
            name = 'Horizonal shifts' )
        ;symbol = 'circle', $ sym_filled = 1, $ sym_size = 0.5, $
        _EXTRA=plot_props)
    p[1] = plot( xdata, ydata[1,*], $
        color='dark orange', $
        ;symbol = 'circle', $ sym_filled = 1, $ sym_size = 0.5, $
        /overplot)
end

pro CALCULATE_SHIFTS, cube, ref, shifts

    ; Calculate shifts WITHOUT actually shifting data cube.
    ; This doesn't take as long as calculating shifts).
    ; input: cube, ref
    ; output: shifts

    sz = size(cube, /dimensions)
    shifts = fltarr( 2, sz[2] )
    for i = 0, sz[2]-1 do begin
        offset = ALIGNOFFSET( cube[*,*,i], ref )
        shifts[*,i] = -offset
    endfor
end

pro APPLY_SHIFTS, cube, shifts

    ; Apply shifts (2xN) to cube
    ; input: shifts
    ; output: cube

    sz = size(cube, /dimensions)
    for i = 0, sz[2]-1 do begin
        cube[*,*,i] = SHIFT_SUB( cube[*,*,i], shifts[0,i], shifts[1,i] )
    endfor
end


; Main level: values/variables that vary according to project.

; Restore (unprocessed) variable 'cube' = [1000 x 1000 x 749] int array
restore, 'aia_1600_cube.sav'

; reference image
ref = cube[*,*,373]

; Null variables to append old/new shifts
old_shifts = []
new_shifts = []

; What's the best way to align this crap?
; Could align chunks of data individually (wouldn't have to wait as long for
; shifts to be caculated/applied, especially since most of it is for shifts that do not
; need correcting... although I do use those values to interpolate).
;
; Could put test inside subroutine to test if the difference between shift[i] is
; greater than some value. If it is, then use open-ended interpolation?
; Or whatever that's called.

; Maybe align one 'chunk' at a time, divided according to shitty coordinates,
; though they supposedly are not consistent from one alignment to the next.
; They're probably close though, so this is likely a safe way to do it.
; Only problem might be keeping track of each piece, and appending aligned bits
; in the appropriate place.
; IDEA: pre-defined aligned_cube with slightly smaller x/y dimensions, and same z.
;    Once satisfied with one chunk, set
;    aligned_cube[100:899, 100:899, z1:z2] = cube_chunk
; Probably should keep track of all shifts the same way... maybe go back to
;   pre-defined shifts to allow for 20 alignment runs, or whatever.

; Calculate shifts
calculate_shifts, cube, ref, shifts

; Array of initial shifts, before interpolating/adjusting
; For .sav files only?
old_shifts = [ [[ old_shifts ]], [[ shifts ]] ]

stop

;--------------------------------------------------------------------------------------
; Dick around with shifts (plot, interpolate, plot again) until satisfied.
; Maybe this whole part should be its own subroutine.

; Plot shifts (one panel showing horizonal and vertical shifts).

; Interpolate to get CORRECT set of shifts.
; 'shifts' variable is modified, so be sure to save original values as needed.
; Consideration: look deeper into spline vs. other types of interpolation.
; Consideration: shifts may change multiple times, and in multiple ways
;    (interpolating, manually adjusting)
;    before they're good enough to save in new_shifts and apply to data cube.
shifts = INTERPOLATE_SHIFTS( old_shifts[*,*,a] )

; Plot shifts again. Make more corrections manually if needed.
; E.g. if one value is off, estimate it as the mean of its adjacent values.
;new_shifts[0,311,0] = mean( [ new_shifts[0,310,0], new_shifts[0,312,0]] )

;--------------------------------------------------------------------------------------
; Save final shifts, after confirming they look correct.
; For .sav files only?
new_shifts = [ [[ new_shifts ]], [[ shifts ]] ]

; Apply new shifts to cube
APPLY_SHIFTS, cube, shifts

; Check that data looks okay... no jumps anywhere.
xstepper, cube, xsize=500, ysize=330

end
