;; Last modified:   12 February 2018 18:03:24


pro my_xstepper, cube, scale=scale, start=start

    if not keyword_set(scale) then scale=1.0
    if not keyword_set(start) then start=0

    sz = scale*(float(size(cube, /dimensions)))
    xstepper, cube, xsize=sz[0], ysize=sz[1], start=start

end
