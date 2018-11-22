;
; input:    frequency, power
;              (fourier2.pro needs to be run before this)
; keywords: fmin, fmax - range of frequencies to show on x-axis



;function plot_spectra, frequency, power, color=color

    
    plt[ii] = PLOT2( $
        frequency, (power-min(power))/(max(power)-min(power)), $
        /current, $
        /device, $
        position = pos*dpi, $
        overplot = ii<1, $
        xtitle = 'frequency (Hz)', $
        ytitle = 'power', $
        sym_size = 0.1, $
        symbol = 'Circle', $
        ;name = name[ii], $
        color = color[ii] )

    if (plt[0].ylog eq 1) then plt[0].ytitle = 'log power'

    ax = plt[0].axes
    period = [120, 180, 200]
    ax[2].tickvalues = 1./period
    ax[2].tickname = strtrim( round(1./(ax[2].tickvalues)), 1 )
    ax[2].title = 'period (seconds)'
    ax[2].showtext = 1

    ;- convert frequency units: Hz --> mHz AFTER placing period markers
    ;- in the correct position, based on original frequency values.
    ;- SYNTAX: axis = a + b*data
    ax[0].coord_transform=[0,1000.]
    ax[0].title='frequency (mHz)'
    ax[0].tickformat='(F0.2)'
