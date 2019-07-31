;- The following routines were written in DC as a way to save bits of
;-   power maps at a time to avoid losing everything every time the
;-   ssh connection was lost (which was a lot...).
;- Can be ignored if working at office.
pro AIA_MAPS, cube, channel, file, start=start, norm=norm
    ; Generates new map or restores EXISTING map and starts at kw 'start'.
    ; WRITES TO FILE!
    ;   (make sure you're not overwriting a file that took hours to compute...)

    cadence = 24
    fmin = 0.0048
    fmax = 0.0060
    dz = 64
    print, 'Running power maps for AIA ' + channel

    if keyword_set(start) then begin
        ; restore existing map
        restore, file & endif $
    else begin
        ; generate new map
        ; NOTE: z-dim of map must be at least dz LESS than z-dim of data.
        start = 0
        sz = size( cube, /dimensions )
        map = fltarr( sz[0], sz[1], sz[2]-dz )
        endelse

    sz = size( map, /dimensions )

    ; save map to file every 50-th timestep (or whatever value is desired)
    step = 50

    ; Loop - sole purpose of this is to save every increment.
    ;   otherwise, no loop is needed, just set map[*] = power_maps(...)
    ;   So if computing last 30 or so images, don't need loop, e.g.
    ;   z = [ 650:sz[2]-dz-1]

    for i = start, sz[2]-1, step do begin

        ; Test that z isn't out of range
        ;   (find better way to do this... later)
        if sz[2] - i LT step then z = [i:sz[2]-1] else z = [i:i+step-1]

        ;map[*,*,z] = POWER_MAPS( $
        map[*,*,z] = COMPUTE_POWERMAPS( $
            ;- 21 April 2019
            ;- I think power_maps was renamed to compute_powermaps
            ;-  so it was more obvious what the routine was for.
            ;-  Same change in the following function.
            cube, cadence, [fmin,fmax], z=z, dz=dz, norm=norm )

        save, map, filename=file
        endfor
end
