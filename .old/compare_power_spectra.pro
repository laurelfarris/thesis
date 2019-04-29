; Last modified:   05 June 2018

; Always give input in frequencies (Hz), e.g. vert = 1./[180,300]

pro compare_power_spectra
    ; power from total flux vs. power summed over power map
    ; test using corner of AIA 1700 (non-flaring)
    ; Plotting P(\nu)
    crop = 10
    testdata = A[1].data[ 0:crop-1, 0:crop-1, * ]
    testz = [0:600]

    ; power from total flux
    testflux = total( total( testdata,1 ), 1 )
    testpower1 = []

    foreach z, testz, i do begin
        result = fourier2( testflux[z:z+dz-1], 24, /NORM )
        power = reform( result[1,*] )
        testpower1 = [ testpower1, MEAN( power[ind] ) ]
    endforeach

    ; power from sum of power map
    testmap = power_maps( testdata, z=testz, dz=64, cadence=24 )
    testpower2 = total( total( testmap,1 ), 1 )

    testx = indgen(601)
    p = plot2( testx, testpower1, color='blue' )
    p = plot2( testx, testpower2, /overplot, color='red' )
end
