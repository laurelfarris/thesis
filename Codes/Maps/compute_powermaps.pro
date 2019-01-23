
; Last modified:   12 July 2018 (changed threshold from hard-coded variable
;     to optional keyword
; Calculates power map
; Input:  data = 3D data cube for which to calculate power maps
;      z_start = array of START indices
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

; 23 September 2018
; Removing part that excludes saturation. Will take longer to compute,
;  but better to have extra information that can easily be excluded,
;  in this case, by using masks.

;- 19 October 2018
;- Now putting it back... only calculating four maps, which can be done
;- fast enough to test different threshold values.
;-   Added if statement to use code that manages saturated pixels
;-   only if threshold kw is set.


function COMPUTE_POWERMAPS, $
    data, $
    cadence, $
    ;fmin=fmin, $
    ;fmax=fmax, $
    fcenter=fcenter, $
    bandwidth=bandwidth, $
    threshold=threshold, $
    z_start=z_start, $
    dz=dz, $
    norm=norm


    sz = size( data, /dimensions )

    if n_elements(z_start) eq 0 then z=[0] else z=z_start
    if n_elements(dz) eq 0 then dz = sz[2]

    if keyword_set(fcenter) and keyword_set(bandwidth) then begin
        fmin = fcenter - bandwidth/2.
        fmax = fcenter + bandwidth/2.
    endif

    frequency = reform( (fourier2( indgen(dz), cadence, NORM=NORM ))[0,*] )
    ind = where( frequency ge fmin AND frequency le fmax )


    nn = n_elements(z); - 1
    map = fltarr( sz[0], sz[1], nn )

    start_time = systime(/seconds)
    ;- Could use foreach i, z... but need i increasing by 1 for map.
    ;- Add some test codes here, or some kind of error handling.
    ;- This takes way too long just to lose everything because the
    ;-  last value of i was "out of range" or whatever.

    ;- TEST: this should produce error if array of starting z-values
    ;          is out of range.
    test = intarr( sz[2] )
    for i = 0, nn-1 do test[i] = data[ 0, 0, z[i]:z[i]+dz-1 ]


    if keyword_set(threshold) then begin

        ;---- Skip saturated pixels

        ;- Array to keep track of how many pixels saturate at each z value.
        sat_arr = fltarr( sz[2] )

        for i = 0, nn-1 do begin
            for y = 0, sz[1]-1 do begin
            for x = 0, sz[0]-1 do begin

                ;- Subtract 1 from dz so that total # images is eqal to dz
                flux = data[ x, y, z[i]:z[i]+dz-1 ]

                ;- z-coordinate(s) of saturated pixels in time segment
                sat = [where( flux ge threshold )]

                if sat[0] eq -1 then begin

                    power = reform( (fourier2( flux, cadence, norm=norm ))[1,*] )

                    ;map[x,y,i] = total( power[ind] )
                    map[x,y,i] = mean( power[ind] )
                    ;- MEAN is better than TOTAL,
                    ;     accounts for variation due to frequency resolution.
                endif
            endfor
            endfor
        endfor
    endif else begin

        ;---- Run calculations on all pixels, whether saturated or not.

        for i = 0, nn-1 do begin
            for y = 0, sz[1]-1 do begin
            for x = 0, sz[0]-1 do begin

                ;- Subtract 1 from dz so that total # images is eqal to dz
                flux = data[ x, y, z[i]:z[i]+dz-1 ]

                power = reform( (fourier2( flux, cadence, norm=norm ))[1,*] )
                map[x,y,i] = mean( power[ind] )
            endfor
            endfor
        endfor
    endelse

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

        ; Test that z isn't out of range
        ;   (find better way to do this... later)
        if sz[2] - i LT step then z = [i:sz[2]-1] else z = [i:i+step-1]

        map[*,*,z] = POWER_MAPS( $
            cube, cadence, [fmin,fmax], z=z, dz=dz, norm=norm )

        save, map, filename=file
        endfor
end

function MAKE_FEW_MAPS, data, time

    ; 18 July 2018
    ; Power maps with dz = 1 hour
    time = strmid(time, 0, 5)
    z = [ '00:30', '01:30', '02:30', '03:30']
    z = [ '00:30', '01:30' ]
    print, (where(time eq z[1]))[0] - (where(time eq z[0]))[0]
    ; --> 150

    dz = 150
    result = fourier2( indgen(dz), 24 )
    frequency = reform( result[0,*] )
    fmin = 0.005
    fmax = 0.006
    ind = where( frequency ge fmin AND frequency le fmax )
    ;print, 1000*frequency[ind], format='(F0.2)'
    ;print, 1./(frequency[ind]), format='(F0.2)'

    sz = size(data, /dimensions)
    N = n_elements(z)
    map = fltarr( sz[0], sz[1], N-1 )

    for i = 0, N-2 do begin
        i1 = (where( time eq z[i] ))[0]
        i2 = (where( time eq z[i+1] ))[0] - 1
        map[*,*,i] = power_maps( $
            data[*,*,i1:i2], 24, [fmin,fmax], threshold=10000 )
    endfor
    return, map
end

ii = 0
map6 = MAKE_FEW_MAPS( A[ii].data, A[ii].time )
stop


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
