;- 29 April 2019
;- Test normalization for FTs.




pro test

    T = 1800.
    cadence = 24.
    norm = 0
    buffer = 1


    ;- number of samples (data points, or observations)
    ;nn = 100
    nn = T/cadence

    ;- number of 3-minute cycles in t-segment
    ;n_cycles = 2
    n_cycles = T/180.

    ;cadence = (n_cycles*180.) / nn


    x = findgen(nn)
    x = (x/max(x)) * (2*!PI)

    n_plots = 5
    y = fltarr( n_elements(x), n_plots )


    ;- 3-minute signal
    ;y[*,0] = 1.0* sin(x*n_cycles)
    y[*,0] = 1.0* sin(x*(T/180.))
    ;- flare
    y[*,1] = 2.0* sin(x*(T/1800))
    ;- Other signals
    y[*,2] = 0.5* sin(x*(T/120.))
    y[*,3] = 0.5* sin(x*(T/300.))
    y[*,4] = 0.5* sin(x*(T/200.))

    color = [ 'dark green', 'dark slate blue', 'black', 'blue', 'indigo' ]
    thick = [ 2, 1, 1, 1, 1 ]
    linestyle = [0, 0, 1, 2, 3, 4, 5]


    for ii = 0, n_plots-1 do begin
        plt = plot2( x, y[*,ii], overplot=ii<1, $
            buffer=buffer, $
            ;thick=thick[ii], $
            ;linestyle=linestyle[ii], $
            color=color[ii] )
    endfor

    signal = total( y, 2 )

    plt = plot2( x, signal, overplot=1, thick=2, color='red'  )

    result = fourier2(  signal, cadence, norm=norm )
    frequency = reform( result[0,*] )
    power = reform( result[1,*] )

    ind = where( frequency ge 0.005 and frequency le 0.006 )
    ;print, frequency[ind]
    print, power[ind[1]]
    print, max(power)
    
    print, variance(signal)

    plt = plot_spectra( frequency, power, $
        bottom=0.20, right=0.20, top=0.20, wx=10, wy=10, $
        ylog=0, $
        buffer=buffer )




end
