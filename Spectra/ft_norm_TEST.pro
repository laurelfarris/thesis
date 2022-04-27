;- 29 April 2019
;- Test normalization for FTs.


;+
;- 04 April 2020
;- Renamed from test.pro to ft_norm_TEST.pro b/c more descriptive
;-   and is not the only file that begins with "test"...
;-




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


;nn = 1000
;xx = (findgen(nn)/nn) * !PI
;yy = fltarr(nn, 2)
;yy[*,0] = sin(8*xx)
;yy[*,1] = 10*(sin(4*xx)) + 5



xx = indgen(685)
;help, xx
yy = power
;help, yy


dw
win = window( dimensions=[8.0,4.0]*dpi, buffer=1 )

plt = objarr(2)

plt[0] = plot2( $
    xx, yy[*,0], /current, $
    layout=[1,1,1], margin=0.2, $
    axis_style = 1, $
    ytitle = "AIA 1600", $
    ycolor = "dark green", $
    ytext_color = "orange", $
    color = "blue" )

plt[1] = plot2( $
    xx, yy[*,1], /current, $
    position=plt[0].position, $
    ;layout=[1,1,1], margin=0.2, $
    axis_style = 4, $
    color = "red" )


 ax2 = axis2( 'X', $
    location='top', $
    target=plt[0], $
    showtext = 0 )

ax3 = axis2( 'Y', $
    location='right', $
    target=plt[1], $
    text_color = "red", $
    title = "AIA 1700", $
    showtext=1 )


save2, "test"




end
