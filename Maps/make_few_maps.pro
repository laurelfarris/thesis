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
        ;map[*,*,i] = power_maps( $
        map[*,*,i] = COMPUTE_POWERMAPS( $
            data[*,*,i1:i2], 24, [fmin,fmax], threshold=10000 )
    endfor
    return, map
end
