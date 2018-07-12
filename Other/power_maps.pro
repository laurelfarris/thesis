
; Last modified:   12 July 2018 (changed threshold from hard-coded variable
;     to optional keyword
; Calculates power map
; Input:  data = 3D data cube for which to calculate power maps
;            z = array of START indices
;           dz = length over which to calculate FT (# images)
;      cadence = cadence of data (seconds)
; NOTES:     (May 11 2018) Added /NORM keyword to fourier2.
;            (May 13 2018) switched from TOTAL to MEAN power.

;; TO-DO:
;;   Make another level of subroutines for all the specifics below,
;;   one for several different situations. Each of them call the
;;   general routine above, and all return essentially the same thing.

; 15 June 2018
; Reading in data and creating maps first, without messing with
;  structures or dictionaries (yet). Do need to interpolate though!


; Probably don't need this anymore:
pro restore_maps, struc, channel
    ; Return variables 'map' and 'map2' (map2 - /NORM)
    ;if n_elements(A.[i].map) eq 0 then restore...
    restore, '../aia' + channel + 'map.sav'
    restore, '../aia' + channel + 'map2.sav'

    ; Power at each timestep, from total(maps).
    ; Still needs to be corrected for saturated pixels.
    power2 = total( total( map2, 1 ), 1 );, fltarr(dz)  

    struc = create_struct( struc, 'power', power, 'power2', power2 )
end


function POWER_MAPS, $
    data, $
    cadence, $
    bandwidth, $
    threshold=threshold, $
    z=z, $
    dz=dz, $
    norm=norm

    sz = size( data, /dimensions )

    f1 = bandwidth[0]
    f2 = bandwidth[1]

    if n_elements(z) eq 0 then z=[0]
    if n_elements(dz) eq 0 then dz = sz[2]

    frequency = reform( (fourier2( indgen(dz), cadence, NORM=NORM ))[0,*] )
    ind = where( frequency ge f1 AND frequency le f2 )

    n = n_elements(z)
    map = fltarr( sz[0], sz[1], n )

    start_time = systime(/seconds)
    ; Could use foreach i, z... but need i increasing by 1 for map.
    ; Add some test codes here, or some kind of error handling.
    ; This takes way too long just to lose everything because the
    ;  last value of i was "out of range" or whatever.

    ; TEST: this should produce error if z is out of range.
    test = intarr( sz[2] )
    for i = 0, n-1 do test[i] = data[ 0, 0, z[i]:z[i]+dz-1 ]

    ; Array to keep track of how many pixels saturate at each z value.
    sat_arr = fltarr( sz[2] )
    if not keyword_set(threshold) then threshold = 10000

    for i = 0, n-1 do begin
        for y = 0, sz[1]-1 do begin
        for x = 0, sz[0]-1 do begin
            ; subtract 1 from dz so that total # images is eqal to dz
            flux = data[ x, y, z[i]:z[i]+dz-1 ]
            sat = [where( flux ge threshold )]
            if sat[0] eq -1 then begin
                power = reform( (fourier2( flux, cadence, norm=norm ))[1,*] )
                ;map[x,y,i] = total( power[ind] )
                ; MEAN is better - accounts for variation due to freq res
                map[x,y,i] = mean( power[ind] )
            endif
        endfor
        endfor
    endfor

    print, format='("Power maps calculated in ~", F0.1, " minutes.")', $
        (systime(/seconds) - start_time)/60
    return, map
end


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

        ; Test that z isn't out of range (find better way to do this... later)
        if sz[2] - i LT step then z = [i:sz[2]-1] else z = [i:i+step-1]

        map[*,*,z] = POWER_MAPS( $
            cube, cadence, [fmin,fmax], z=z, dz=dz, norm=norm )

        save, map, filename=file
        endfor
end


; 2018-06-26
;   Restoring aligned data takes too long to run every time I run aia_power_maps
;   to correct minor errors. So pulled these lines back into main level.
;   Should be combined with interpolation routines somwhere (since interpolation
;   needs to be done before maps, but is never saved into .sav files).
; 2018-06-27
;   Really glad I commented this... I was about to put those lines back into
;   the subroutine :)

; Restore aligned data cube (not map yet)
channel = '1600'
restore, '../aia' + channel + 'aligned.sav'
cube = crop_data(cube)

; Interpolate to get missing data and corresponding timestamp.
; (pulled lines from prep.pro, but this should be separated).
; Don't need to read fits at all when interp isn't needed.
; This is just to get date_obs, used as test for missing data.
if channel eq '1700' then begin
    ;READ_MY_FITS, 'aia', channel, index, data, nodata=1, prepped=1
    READ_MY_FITS, index, data, inst='aia', channel=channel, nodata=1;, prepped=1
    time = strmid( index.date_obs,  11, 11 )
    jd = get_jd( index.date_obs + 'Z' )
    cadence = 24
    LINEAR_INTERP, cube, jd, cadence, time
endif

; 27 June 2018 - finishing map for AIA 1700 (indices z = 650:684)
; (after .reset_session), at ML.
; subroutine hiccup: case where restoring and continuing existing map...
; Copied code from AIA_POWER_MAPS and commented/modified as needed.

; 28 June 2017 - finishing map (norm=1) for AIA 1600
; step is for saving map every 50-th timestep... 
;    don't need it for last 30 or so images (halted because i was out
;    of range, not because I lost ssh connection)

; Find z-index at which computation of power map stopped and set = start
; Notes from 27 June 2018
if 0 gt 1 then begin ; sneaky comment :)
    sz = size(map, /dimensions)
    map_total = fltarr(sz[2])
    for i = 0, sz[2]-1 do $
        map_total[i] = total(map[*,*,i])
    unfinished_ind = where(map_total eq 0.0)
    print, unfinished_ind[0]
    ;print, unfinished_ind - shift(unfinished_ind, 1)
    stop
endif

start = 250
file = 'aia' + channel + 'map_norm.sav'
AIA_MAPS, cube, channel, file, start=start, norm=1
stop


;----------------------------------------------------------------------------------
; another .reset_session

restore, 'aia1700map_final.sav'
map_final = map[*,*,0:649]
restore, '../aia1700map.sav'
map = map[*,*,0:649]

print, where( map_final ne map)

; output = -1, so we should be good!

restore, 'aia1700map_final.sav'
help, map
print, map[200,200,0]

channel = '1700'
save, map, filename='aia' + channel + 'map.sav'

restore, 'aia1700map.sav'
;start:
print, map[200,200,-1]

end
