
; Last modified:   15 June 2018
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
    threshold = 10000

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


pro AIA_POWER_MAPS, cube, channel


    print, 'Running power maps for AIA ' + channel
    fmin = 0.0048
    fmax = 0.0060
    dz = 64

    cube = crop_data(cube)
    sz = size( cube, /dimensions )

    ; z-dimension of map has to be at least dz LESS than z-dimension of data
    map = fltarr( sz[0], sz[1], sz[2]-dz )
    help, map

    step = 50
    for i = 0, sz[2]-dz-1, step do begin

        ; Keep track of progress (and make sure code hasn't stalled)
        print, 'z start = ', strtrim(i,1)

        z = [i:i+step-1]
        map[*,*,z] = power_maps( $
            cube, 24, [fmin,fmax], z=z, dz=dz, norm=0 )
        save, map, filename='aia' + channel + 'map.sav'
    endfor

end

; 2018-06-26
; Restoring aligned data takes too long to run every time I run aia_power_maps
; to correct minor errors. So pulled these lines back into main level.
; Should be combined with interpolation routines somwhere (since interpolation
; needs to be done before maps, but is never saved into .sav files).

goto, start

;channel = '1600'
channel = '1700'
cadence = 24
;restore, '../aia' + channel + 'aligned.sav'

; Interpolate to get missing data and corresponding timestamp.
; (pulled lines from prep.pro, but this should be separated).
read_my_fits, 'aia', channel, index, data, nodata=1, prepped=1
time = strmid(index.date_obs,11,11)
jd = get_jd( index.date_obs + 'Z' )
LINEAR_INTERP, cube, jd, cadence, time
stop

start:
AIA_POWER_MAPS, cube, channel

;aia1600 = create_struct( aia1600, 'map', aia1600map )
;aia1700 = create_struct( aia1700, 'map', aia1700map )
;A = [aia1600, aia1700]

end
