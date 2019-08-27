;Copied from clipboard


    result = fourier2( flux, cadence )
    frequency = result[0,*]
    power = result[1,*]
    plt = plot2( frequency, power, buffer=0, location=[500,0] )

    end

