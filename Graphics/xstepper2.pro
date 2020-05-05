;+
;- LAST MODIFIED:
;-
;-   29 April 2019
;-    ... and did what?
;-
;-   05 May 2020
;-     Editing comments... not much else to do.
;-
;- PROGRAMMER:
;-   Laurel Farris
;-
;- DESCRIPTION:
;-   call IDL xstepper routine more or less like normal;
;-   subroutine written with my general preferences defined within so I
;-   never need to worry about setting anything except kws that are
;-   unique to whatever is being movie-ed.
;-  





pro xstepper2, $
    cube, $
    scale=scale, $
    channel=channel, $
    invert_colors=invert_colors, $
    _EXTRA=e



    if keyword_set(invert_colors) then $
        default_colortable = 54 $
    else $
        default_colortable = 0


    if keyword_set(channel) then $
        aia_lct, wave=fix(channel), /load $
    else $
        loadct, default_colortable

    sz = size(cube, /dimensions)

    mindata = []
    maxdata = []
    for i = 0, sz[2]-1 do begin
        mindata = [mindata, min(cube[*,*,i])]
        maxdata = [maxdata, max(cube[*,*,i])]
    endfor

    if not keyword_set(scale) then scale = 1.0 else scale = float(scale)
    xsize = sz[0] * scale
    ysize = sz[1] * scale

    if not keyword_set(start) then start=0

    xstepper, cube>max(mindata)<min(maxdata), $
        xsize=xsize, ysize=ysize, $
        start=start, $
        _EXTRA=e

end
