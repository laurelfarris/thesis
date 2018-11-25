;
; input:    frequency, power
;              (fourier2.pro needs to be run before this)
; keywords: fmin, fmax - range of frequencies to show on x-axis





;function plot_spectra, frequency, power, color=color



    ;bb = ''
    ;prompt = 'Plot spectra?'
    ;read, bb, prompt=prompt

    ;if bb eq 'y' then begin



        ;win = GetWindows(/current)
        ;if win eq !NULL then $
            ;win = window( dimensions=[8.0,4.0]*dpi, location=[500,0] )

function PLOT_SPECTRA_GENERAL, $
    frequency, power, $
    color=color, $
    name=name, $
    buffer=buffer, $
    _EXTRA = e

    common defaults

    xdata = frequency
    ydata = power

    win_scale = 1
    wx = 8.00*win_scale
    wy = 2.75*win_scale
    if keyword_set(buffer) then $
        win = window( dimensions = [wx,wy]*dpi, buffer=1 ) $
    else $
        win = window( dimensions = [wx,wy]*dpi, location=[500,0] )

    left = 1.00
    right = 1.10
    bottom = 0.5
    top = 0.2

    x1 = left
    y1 = bottom
    x2 = wx - right
    y2 = wy - top
    position = [x1,y1,x2,y2]*dpi

    sz = size(ydata, /dimensions)
    if n_elements(sz) eq 1 then sz = reform(sz, sz[0], 1, /overwrite)

    ;- nn = # curves to (over)plot
    nn = sz[1]

    plt = objarr(nn)
    for ii = 0, nn-1 do begin

        plt[ii] = PLOT2( $

        cols=1
        rows=1

        pos = get_position( layout=[cols,rows,1], width=6.5, height=2.5 )

        plt[ii] = PLOT2( $
            frequency, $ ;(power-min(power))/(max(power)-min(power)), $
            power, $
            /current, $
            /device, $
            overplot = ii<1, $
            ;position = pos*dpi, $
            layout=[1,1,1], $
            margin=0.5*dpi, $
            xtitle = 'frequency (Hz)', $
            ytitle = 'power', $
            symbol = 'Circle', $
            color = color[ii], $
            ;name = name[ii], $
            sym_size = 0.5 )

        if (plt[0].ylog eq 1) then plt[0].ytitle = 'log power'


        if ii ge 1 then continue

        ax = plt[0].axes
        period = [120, 180, 200]
        foreach pp, period, ii do begin
            xx = 1./pp
            v = plot2( [xx,xx], plt[0].yrange, /overplot, ystyle=1, linestyle=ii+1 )
        endforeach
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
    ;endif
