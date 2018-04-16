;; Last modified:   21 March 2018 19:14:32



pro xstepper2, cube, scale=scale, _EXTRA=e

    sz = float(size( cube, /dimensions ))

    if not keyword_set(scale) then scale = 1

    y = 800 * float(scale)
    x = y * (sz[0]/sz[1])

    xstepper, cube, xsize=x, ysize=y, _EXTRA=e

end
