;; Last modified:   14 March 2018 19:09:42


goto, start

restore, 'aia_1600_cube.sav'

x = [ [0, 300], [650, 999] ]
y = [ [0, 350], [700, 999] ]
z = [ 225, 350 ]

mainref = cube[*,*, 373]
;cube = cube[*,*, z[0]:z[1]-1]

average_shifts = []

for a = 0, 5 do begin

    s = []

    for i = 0, 1 do begin
        for j = 0, 1 do begin

        x1 = x[0,i]
        x2 = x[1,i]
        y1 = y[0,j]
        y2 = y[1,j]

        temp = cube[ x1:x2, y1:y2, * ]
        ref = mainref[ x1:x2, y1:y2 ]

        sz = size(temp, /dimensions)
        shifts = fltarr(2, sz[2])
        
        for l = 0, sz[2]-1 do begin

            offset = alignoffset( temp[*,*,l], ref )
            shifts[*,l] = -offset

        endfor

        ;align_cube3, temp, ref, shifts=shifts
        s = [ [[s]], [[shifts]] ]


        endfor
    endfor

    shifts = mean( s, dimension=3 )

    for l = 0, sz[2]-1 do $
        cube[*,*,l] = shift_sub( $
            cube[*,*,l], shifts[0,l], shifts[1,l] )

    average_shifts = [ [[ average_shifts ]], [[ shifts ]] ]

endfor

stop

for i = 0, 1 do $
    im = image( $
        (cube[*,*,373])^0.5, $
        ;(cube[400:600,400:600,z[i]])^0.5, $
        layout=[1,1,1], $
        margin=0.0, $
        dimensions=[800,800] )



;all_shifts[*, z[0]:z[1], a] = average_shifts
;a = a + 1


restore, 'aia_1600_cube.sav'
ref  = cube[ 100:899, 100:899, 373 ]
cube = cube[ 100:899, 100:899, 0:224 ]

align_cube3, cube, ref, shifts=shifts
stop


start:;----------------------------------------------------------------------------------
xstepper, (cube)^0.5, xsize=800, ysize=800

end
