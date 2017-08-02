;; Last modified:   09 July 2017 11:10:59

;; Rotate each 2D image in data cube 180 degrees.


pro hmi_rotate, cube

    sz = size( cube, /dimensions )

    for i = 0, sz[2]-1 do begin
        cube[*,*,i] = rotate( cube[*,*,i], 2 )
    endfor

end
