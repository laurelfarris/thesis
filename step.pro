;; Last modified:   21 March 2018 19:14:32



pro step, cube, scale=scale

    sz = size( cube, /dimensions )

    if not keyword_set(scale) then scale = 1

    y = 800 * scale
    x = y * (sz[0]/sz[1])

    xstepper, cube, xsize=x, ysize=y

end
