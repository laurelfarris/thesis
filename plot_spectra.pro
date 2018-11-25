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



