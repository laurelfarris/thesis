
; Last modified:   20 April 2018
; Calculates power map
; Input:  data = 3D data cube for which to calculate power maps
;            z = array of START indices
;           dz = length over which to calculate FT (# images)
;      cadence = cadence of data (seconds)
; NOTES:     (May 11 2018) Added /NORM keyword to fourier2.
;            (May 13 2018) switched from TOTAL to MEAN power.


function power_maps, $
    data, $
    z=z, $
    dz=dz, $
    bandwidth=bandwidth, $
    cadence=cadence, $
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
    test = intarr( sz[2] )

    start_time = systime(/seconds)
    ; Could use foreach i, z... but need i increasing by 1 for map.
    ; Add some test codes here, or some kind of error handling.
    ; This takes way too long just to lose everything because the
    ;  last value of i was "out of range" or whatever.

    ; TEST: this should produce error if z is out of range.
    for i = 0, n-1 do test[i] = data[ 0, 0, z[i]:z[i]+dz-1 ]

    ; Array to keep track of how many pixels saturate at each z value.
    sat_arr = fltarr( sz[2] )

    for i = 0, n-1 do begin
        for y = 0, sz[1]-1 do begin
        for x = 0, sz[0]-1 do begin
            ; subtract 1 from dz so that total # images is eqal to dz
            flux = data[ x, y, z[i]:z[i]+dz-1 ]
            sat = [where( flux ge 15000. )]
            if sat[0] eq -1 then begin
                power = reform( (fourier2( flux, cadence, /NORM ))[1,*] )
                ;map[x,y,i] = total( power[ind] )
                map[x,y,i] = mean( power[ind] )
            endif
        endfor
        endfor
    endfor

    print, format='("Power maps calculated in ~", F0.1, " minutes.")', $
        (systime(/seconds) - start_time)/60
    return, map
end


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


goto, start
start:;--------------------------------------------------------------------

;f1 = 0.005
;f2 = 0.006
fmin = 0.0048
fmax = 0.0060
bandwidth = [fmin,fmax]

;; Make another level of subroutines for all the specifics below,
;; one for several different situations. Each of them call the
;; general routine above, and all return essentially the same thing.

; # images (length of time) over which to calculate each FT.
;dz = 64
dz = 42

; Setting up thing to run HMI power map.
;hmimap = power_maps( hmi_data, z=z, dz=dz, cadence=45 )

z = [0:200]
map = power_maps( S.(0).before, z=z, dz=dz, bandwidth=bandwidth, cadence=24,norm=1)
;aia1600map = power_maps( A[0].data, z=z, dz=dz, cadence=A[0].cadence)
;aia1700map = power_maps( A[1].data, z=z, dz=dz, cadence=A[1].cadence )
stop

save, aia1600map, filename='../aia1600map2.sav'
save, aia1700map, filename='../aia1700map2.sav'
stop

aia1600 = create_struct( aia1600, 'map', aia1600map )
aia1700 = create_struct( aia1700, 'map', aia1700map )

A = [aia1600, aia1700]


end
