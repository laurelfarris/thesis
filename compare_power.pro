


pro compare_power
    ; Compare power for total flux vs. total power over power map
    ; test using corner of AIA 1700 (non-flaring)


    crop = 10
    testdata = A[1].data[ 0:crop-1, 0:crop-1, * ]
    testz = [0:600]

    ; power based on total flux
    testflux = total( total( testdata,1 ), 1 )
    testpower1 = []

    foreach z, testz, i do begin
        result = fourier2( testflux[z:z+dz-1], 24, /NORM ) 
        power = reform( result[1,*] )
        testpower1 = [ testpower1, MEAN( power[ind] ) ]
    endforeach


    ; power based on total of power map
    testmap = power_maps( testdata, z=testz, dz=64, cadence=24 )

    ; should this be mean instead of total? Map is already showing
    ;  mean(power)... may just have to ask about this.
    testpower2 = total( total( testmap,1 ), 1 )


    testx = indgen(601)
    p = plot2( testx, testpower1, color='blue' )
    p = plot2( testx, testpower2, /overplot, color='red' )

end

;; May 15, 2018

; Compare power with and without /NORM set,
; for both total flux and normalized flux.

; Make plots and power maps.



; This gives power 749 elements, but will only have values for 749 - 64.
; The rest will = 0.0
;power = fltarr(n_elements(A[0].flux))
;aia1600 = create_struct( aia1600, 'power', power )
;aia1700 = create_struct( aia1700, 'power', power )
;A = [ aia1600, aia1700 ]


y1 = A[0].flux
y2 = A[0].flux_norm
struc = { $
    xdata : A[0].time, $
    ydata : [ [y1], [y1], [y2], [y2] ], $
    norm : [0,1,0,1], $
    title : [ $
        'flux; NORM=0', $
        'flux, NORM=1', $
        'flux_norm; NORM=0', $
        'flux_norm, NORM=1'] $
}



    ; Calculate possible frequencies for dz.
    frequency = (reform( fourier2( $
        indgen(dz), A[0].cadence, NORM=NORM )))[0,*] 
    ind = where( frequency ge f_min AND frequency le f_max )




; Calculate power for time series between each value of z and z+dz

dz = 64
f_min = 0.005
f_max = 0.006

; ydata
power_total = fltarr( 4, n_elements(A[0].flux) )
z_start = [0 : n_elements(power_total)-dz]

for j = 0, 3 do begin
    foreach z, z_start, i do begin

        input = struc.ydata[*,j]
        result = fourier2( input[z:z+dz-1], NORM=struc.norm[i], 24 )
        frequency = reform(result[0,*])

        ; MEAN power over frequency[ind] (freq. bandpass)
        ind = where( frequency ge 0.005 AND frequency le 0.006 )
        power = reform( result[1,*] )
        power_total[j,i] = MEAN( power[ind] )

    endforeach
endfor



p = objarr(4)
for i = 0, 3 do begin
    p[i] = plot2( $
        struc.xdata, power_total[i,*], $
        title=struc.title[i], $
        )
endfor






end
