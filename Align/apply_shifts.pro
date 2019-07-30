
pro APPLY_SHIFTS, cube, shifts
    ; Apply shifts (2xN) to cube
    ; input: shifts
    ; output: cube

    sz = size(cube, /dimensions)
    for ii = 0, sz[2]-1 do $
        cube[*,*,ii] = SHIFT_SUB( cube[*,*,ii], shifts[0,ii], shifts[1,ii] )
end
