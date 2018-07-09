; Last modified:   29 June 2018

; should have no problem running this, even if spontaneously reading
; random data from a few fits files and want to plot it.
; No loops here; call this routine INSIDE loops.

; Also see aia_prep documentation on plotting light curves.
; ---
; Entire time series
;time = ['00:00', '04:59']
; C-class flare
;time = ['00:30', '01:00']
;ind = [ (where(date_obs eq time[0]))[0] : (where(date_obs eq time[1]))[0] : 75 ]
; ---

;what_to_plot = 'lightcurve'
what_to_plot = 'power'

xdata = A[0].jd
xrange = [ min(xdata), max(xdata) ]

case what_to_plot of

    'lightcurve': begin
        ytitle = 'counts (DN s$^{-1}$)'
        ;ydata = ydata - min(ydata)
        ;ydata = ydata / max(ydata)
        file = 'lc.pdf'

        ; y-axis labels - AIA 1600 on the left and AIA 1700 on the right.
        ax[3].showtext=1
        values1 = strtrim( (p[0].ytickvalues + min( A[0].flux/A[0].exptime ))/1e7, 1 )
        values2 = strtrim( (p[1].ytickvalues + min( A[1].flux/A[1].exptime ))/1e8, 1 )
        ax[1].tickname = strmid( values1, 0, 3 ) + '$\times 10^7$'
        ax[3].tickname = strmid( values2, 0, 3 ) + '$\times 10^8$'
        ax[1].title = A[0].name + ' (DN s$^{-1}$)'
        ax[3].title = A[1].name + ' (DN s$^{-1}$)'

        PLOT_VS_TIME, A, xdata, ydata, ytitle=ytitle;, xrange=xrange
        resolve_routine, 'save2'
        save2, file;, /add_timestamp

        end

; Plot power at x +/- dz to show time covered by each value.
;  (see notes from 2018-05-13)
    'power': begin
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

        file = 'power.pdf'
        end

end


end
