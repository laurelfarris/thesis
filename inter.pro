;; Last modified:   05 March 2018 23:14:16


; input:            shifts [ 2 x N ]; x/y shifts for N images


pro plot_all_shifts, shifts


    ;; shifts should be 2xN array.

    cols=1
    rows=1
    @graphics

    ydata = shifts
    xdata = indgen( (size(shifts, /dimensions))[1] )

    graphic = plot( xdata, ydata[0,*], /nodata, $
        position=pos[*,0], $
        ;xrange = [650,720], $
        ;xmajor = 20, $
        xtickinterval = 20, $
        xminor = 4, $
        ;yrange=[-2.00,2.00], $
        _EXTRA=plot_props)

    p = objarr(2)
    p[0] = plot( xdata, ydata[0,*], $
        color='dark cyan', $
        ;symbol = 'circle', $ sym_filled = 1, $ sym_size = 0.5, $
        /overplot)

    p[1] = plot( xdata, ydata[1,*], $
        color='dark orange', $
        ;symbol = 'circle', $ sym_filled = 1, $ sym_size = 0.5, $
        /overplot)

end



function interpolate_shifts, shifts

    ;; number of shifts/images
    sz = size( shifts, /dimensions )
    N = fix(sz[1])

    ;; Initialize COMPLETE arrays (post-interpolation)
    cadence_inter = findgen(N)
    data_inter = fltarr( sz )

    ;; "Bad" indices of shifts that are definitely wrong (after first alignment)
    bad = []
    bad = [ bad, $
        [  7: 11], $
        [ 84:103], $
        [107:109], $
        [260:320], $
        [461:462], $
        [472:477], $
        [641:642], $
        [671:701], $
        [716:717] ]

    bad = []
    bad = [ bad, [5:13], [ 82:110], [660:710] ]
    ;bad = [ bad, [250:330], [460:500]];, [600:N-1] ]

    ;; "Good" indices.
    good = []
    for i = 0, n_elements(cadence_inter)-1 do begin
        j = where( bad eq i )
        if j eq -1 then good = [ good, i ]
    endfor
    ;good = [ 0,[1:6],[12:83],[104:106],[110:259],[321:460],[463:471],[478:640],[643:670],[702:715],[718:N-1]]

    ;; Crop data to normal shifts ONLY
    cad = cadence_inter[good]
    data = shifts[ *, good ]

    data_inter[0,*] = interpol( data[0,*], cad, cadence_inter, /spline )
    data_inter[1,*] = interpol( data[1,*], cad, cadence_inter, /spline )

    return, data_inter

end

goto, start

;; Read in unprocessed data cube for AIA 1600.
restore, 'aia_1600_cube.sav'
ref = cube[*,*,373]
sz = size(cube, /dimensions)
shifts     = fltarr( 2, sz[2] )
old_shifts = []
new_shifts = []


START:;----------------------------------------------------------------------------------
;;  Calculate shifts
for i = 0, sz[2]-1 do begin
    offset = alignoffset( cube[*,*,i], ref )
    shifts[*,i] = -offset
endfor
old_shifts = [ [[ old_shifts ]], [[ shifts ]] ]
stop


;--------------------------------------------------------------------------------------
;; Plot shifts (one panel showing horizonal and vertical shifts).
;;   Interpolate to get CORRECT set of shifts
;; Plot shifts again. Make more corrections manually if needed.

;shifts = interpolate_shifts( old_shifts[*,*,a] )
shifts = interpolate_shifts( shifts )
stop
shifts[*,250:330] = 0.0
shifts[*,450:510] = 0.0
shifts[*,600:*] = 0.0
plot_all_shifts, shifts
stop
;--------------------------------------------------------------------------------------

;; Save shifts
new_shifts = [ [[ new_shifts ]], [[ shifts ]] ]
stop


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
