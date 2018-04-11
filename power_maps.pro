; Last modified:   08 April 2018
;

pro plot_power_vs_time, z, map

    ;; map = 3D array of maps (x,y,t)

    win = window( dimensions=[1200, 800] )

    xdata = z
    ydata = total( total( map, 1), 1 )

    p = plot2( xdata, ydata, /current, $
        xtickvalues=[0:199:25], $
        xtickname=time[0:199:25], $
        xtitle='observation time (15 February 2011)', $
        ytitle='3-minute power' $
    )
end


function power_maps, $
    data, $
    z=z, dz=dz, $
    T=T, $
    cadence=cadence

    ; Calculates power map (not for imaging).

    ; data = 3D data cube for which to calculate power maps
    ; z = array of START indices
    ; dz = length over which to calculate FT (# images)
    ; T = 2-element array of lower and upper period (seconds)
    ; cadence = cadence of data (seconds)


;    if keyword_set( period_range ) then $
;        frequency_range = reverse( 1./period_range )
;
;    f1 = frequency_range[0]
;    f2 = frequency_range[1]
;
;    frequency = reform( (fourier2( indgen(dz), cadence ))[0,*] )
;    ind = where( frequency ge f1 AND frequency le f2 ) 


    ; Indices of power/frequency arrays within desired bandpass.
    ;   dz = # images (length of time) over which to calculate each FT.
    ind = get_frequencies( cadence=24, dz=dz, T=T )
    stop

    sz = size( data, /dimensions )
    n = n_elements(z)
    map = fltarr( sz[0], sz[1], n )

    start_time = systime(/seconds)
    for i = 0, n-1 do begin
        for y = 0, sz[1]-1 do begin
        for x = 0, sz[0]-1 do begin

            ; subtract 1 from dz so that total # images is eqal to dz
            flux = data[ x, y,   z[i] : z[i]+dz-1]

            sat = where( flux ge 15000. )

            if sat ne -1 then begin
                map[x,y,i] = 0
                break
            endif else begin
                result = fourier2( flux, cadence )
                power = reform( result[1,*] )
                map[x,y,i] = total( power[ind] )
                ;map[x,y,i] = mean( power[ind] )
            endelse
        endfor
        endfor
    endfor

    print, format='("That took about ", F0.1, " minutes.")', $
        (systime(/seconds) - start_time)/60

    return, map

end



;; Make another level of subroutines for all the specifics below,
;; one for several different situations. Each of them call the
;; general routine above, and all return essentially the same thing.

; # images (length of time) over which to calculate each FT.
dz = 64

; starting indices/time for each FT (length = # resulting maps)
z_end = (where( aia1600.time eq '01:20' ))[0]
z = [0:z_end]

;temp = S.(0).data[40:139,90:189,*]
aia1600map = power_maps( A[0].data, z=z, dz=dz, ind=ind, cadence=24. )
aia1600 = create_struct( aia1600, 'map', aia1600map )

;temp = S.(1).data[40:139,90:189,*]
aia1700map = power_maps( A[1].data, z=z, dz=dz, ind=ind, cadence=24. )
aia1700 = create_struct( aia1700, 'map', aia1700map )


end
