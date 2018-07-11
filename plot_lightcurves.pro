; Last modified:   11 July 2018

; ---
; Entire time series
;time = ['00:00', '04:59']
; C-class flare
;time = ['00:30', '01:00']
;ind = [ (where(date_obs eq time[0]))[0] : (where(date_obs eq time[1]))[0] : 75 ]
; ---

what_to_plot = 'lightcurve'
;what_to_plot = 'power'

case what_to_plot of

    'lightcurve': begin
        file = 'lc.pdf'
        ytitle = 'counts (DN s$^{-1}$)'

        for i = 0, n_elements(A) do begin
            xdata = A[i].jd
            xrange = [ min(xdata), max(xdata) ]
            ydata = A[i].flux
            ;ydata = ydata - min(ydata)
            ;ydata = ydata / max(ydata)
            p[i] = PLOTT( $
                xdata, ydata, $
                overplot=i<1, color=A[i].color, name=A[i].name)
        endfor
        end

    'power': begin
        file = 'power.pdf'
        ytitle = '3-minute power'
        N = n_elements(xdata)
        xdata = xdata[32:N-32-1]

        ; Power from total flux
        ;ydata = A[i].flux / A[i].exptime
        ;ydata = wrapper( ydata, A[i].cadence )

        ; Power from power maps
        ; .run saturation
        aia1600power = total( total( aia1600map, 1 ) )
        ; Divide array of power vs. time by number of unsaturated pixels


        ; Plot power at x +/- dz to show time covered by each value.
        ;  (see notes from 2018-05-13)

        end

end

resolve_routine, 'save2'
save2, file;, /add_timestamp
stop


        ; y-axis labels - AIA 1600 on the left and AIA 1700 on the right.
        ax[3].showtext=1
        values1 = strtrim( (p[0].ytickvalues + min( A[0].flux/A[0].exptime ))/1e7, 1 )
        values2 = strtrim( (p[1].ytickvalues + min( A[1].flux/A[1].exptime ))/1e8, 1 )
        ax[1].tickname = strmid( values1, 0, 3 ) + '$\times 10^7$'
        ax[3].tickname = strmid( values2, 0, 3 ) + '$\times 10^8$'
        ax[1].title = A[0].name + ' (DN s$^{-1}$)'
        ax[3].title = A[1].name + ' (DN s$^{-1}$)'

end
