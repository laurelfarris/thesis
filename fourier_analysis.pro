;; Last modified:   07 June 2017 19:44:01


function fdata
    h1 = 90
    h2 = 240
    h = fltarr( (size(hmi_data[*,*,h1:h2], /dimensions))[2] )
    a = fltarr( (size(aia_data, /dimensions))[2] )

    h_norm = h/max(h)
    a_norm = a/max(a)


    h_during = h1
    for i = 0, n_elements(h)-1 do begin
        ;d[i] = total( hmi_data[*,*,i+1] ) - total( hmi_data[*,*,i] )
        h[i] = total( hmi_data[*,*,h_during] )
        h_during = h_during+1
    endfor
    for i = 0, n_elements(a)-1 do begin
        ;d[i] = total( hmi_data[*,*,i+1] ) - total( hmi_data[*,*,i] )
        a[i] = total( aia_data[*,*,i] )
    endfor
    return, 0
end


delt = 45

h = hmi_data[2400, 1650, *]
a = aia_data[2400, 1650, *]

;; Array containing power and phase at each frquency (according to comments).
h_result = Fourier2( h, 45 )
a_result = Fourier2( a, 12 )

;frequency = result[0,*]
;power_spectrum = result[1,*]
;phase = result[2,*]
;amplitude = result[3,*]




end
