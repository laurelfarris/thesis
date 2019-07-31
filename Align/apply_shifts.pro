
pro APPLY_SHIFTS, cube, shifts
    ; Apply shifts (2xN) to cube
    ; input: shifts
    ; output: cube

    ;sz = size(cube, /dimensions)

    ;- Use shifts instead of cube (30 July 2019)
    sz = size(shifts, /dimensions)
    ;- sz[0] = 2 (shifts[0,*,*] = x-shifts, shifts[1,*,*] = y-shifts
    ;- sz[1] = number of images (=sz[2] for cube)
    ;- sz[2] = number of times align_cube3 was run (usually < 10)


    for jj = 0, sz[2]-1 do begin

        for ii = 0, sz[1]-1 do $
            cube[*,*,ii] = SHIFT_SUB( $
                cube[*,*,ii], shifts[0,ii,jj], shifts[1,ii,jj] )

    endfor
end
