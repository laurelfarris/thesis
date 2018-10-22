

; Last modified:    13 June 2018
; Programmer:       Laurel Farris
; Description:      subroutines with custom default configurations



pro xstepper2, $
    cube, $
    scale=scale, $
    channel=channel, $
    invert_colors=invert_colors, $
    _EXTRA=e


    sz = float(size( cube, /dimensions ))

    if keyword_set(invert_colors) then $
        default_colortable = 54 $
    else $
        default_colortable = 0


    if keyword_set(channel) then $
        aia_lct, wave=fix(channel), /load $
    else $
        loadct, default_colortable



    mindata = []
    maxdata = []
    for i = 0, sz[2]-1 do begin
        mindata = [mindata, min(cube[*,*,i])]
        maxdata = [maxdata, max(cube[*,*,i])]
    endfor
    ;print, max(mindata)
    ;print, min(maxdata)
    ;stop

    if not keyword_set(scale) then scale = 1
    
    x = 500 * float(scale)
    y = x * (sz[1]/sz[0])

    xstepper, cube>max(mindata)<min(maxdata), $
        xsize=x, ysize=y, $
        _EXTRA=e


end