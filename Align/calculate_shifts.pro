pro CALCULATE_SHIFTS, cube, ref, shifts
    ; Calculate shifts WITHOUT actually shifting data cube
    ; input: cube, ref
    ; output: shifts

    sz = size(cube, /dimensions)
    shifts = fltarr( 2, sz[2] )

    for ii = 0, sz[2]-1 do begin
        offset = ALIGNOFFSET( cube[*,*,ii], ref )
        shifts[*,ii] = -offset
    endfor
end
