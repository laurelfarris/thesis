
; Last modified:   20 April 2018
; Calculates power map
; Input:  data = 3D data cube for which to calculate power maps
;            z = array of START indices
;           dz = length over which to calculate FT (# images)
;      cadence = cadence of data (seconds)
; NOTES:     Added /NORM keyword to fourier2.


function power_maps, $
    data, $
    z=z, $
    dz=dz, $
    cadence=cadence

    f1 = 0.004
    f2 = 0.006
    frequency = reform( (fourier2( indgen(dz), cadence, /NORM ))[0,*] )
    ind = where( frequency ge f1 AND frequency le f2 )

    sz = size( data, /dimensions )
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

    for i = 0, n-1 do begin
        for y = 0, sz[1]-1 do begin
            for x = 0, sz[0]-1 do begin

                ; subtract 1 from dz so that total # images is eqal to dz
                flux = data[ x, y, z[i]:z[i]+dz-1 ]
                sat = [where( flux ge 15000. )]
                if sat[0] eq -1 then begin
                    power = reform( (fourier2( flux, cadence, /NORM ))[1,*] )
                    map[x,y,i] = total( power[ind] )
                    ;map[x,y,i] = mean( power[ind] )
                endif
            endfor
        endfor
    endfor

    print, format='("Power maps calculated in ~", F0.1, " minutes.")', $
        (systime(/seconds) - start_time)/60

    return, map

end

goto, start


;; Make another level of subroutines for all the specifics below,
;; one for several different situations. Each of them call the
;; general routine above, and all return essentially the same thing.

; # images (length of time) over which to calculate each FT.
dz = 64

;; Copy lines to notebook, and delete:
; starting indices/time for each FT (length = # resulting maps)
;z_end = (where( aia1600.time eq '01:20' ))[0]
;z = [0:z_end]
;z = [190,254,318]

; 19 April 2018 - every 64th time step through entire time series.
;
; When developing code, can do, e.g. every fifth timestep, but for
; saving powermaps, do EVERY timestep to avoid confusion.
; Start code before leaving.
z = [0:680:5]
stop

; Setting up thing to run HMI power map.
hmimap = power_maps( hmi_data, z=z, dz=dz, cadence=45 )

aia1600map = power_maps( A[0].data, z=z, dz=dz, cadence=A[0].cadence)
aia1700map = power_maps( A[1].data, z=z, dz=dz, cadence=A[1].cadence )

start:;--------------------------------------------------------------------
aia1600 = create_struct( aia1600, 'map2', aia1600map )
aia1700 = create_struct( aia1700, 'map2', aia1700map )

A = [aia1600,aia1700]


end
