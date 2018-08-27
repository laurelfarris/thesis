


;; Call PLOT_WITH_TIME with one of these structures

function PLOT_STRUCTURES, $
    ydata, $
    offset=offset, $
    ytitle=ytitle, $
    file=file

    dz = 64
    N = n_elements(ydata[*,0])
    if not keyword_set(offset) then offset = 0

    struc = { $
        xdata : [0:N-1]+offset, $
        ydata : ydata, $
        ytitle : ytitle, $
        file : file }

    return, struc
end

;xdata = A.jd-min(A.jd)
;xtitle = 'Start time (UT) on 15-Feb-2011 00:00'

; Lightcurves
lightcurve_struc = PLOT_STRUCTURES( $
    A.flux, $
    ytitle='DN s$^{-1}$', $
    file='lightcurve_1.pdf' )

; Power (flux)
power_flux_struc = PLOT_STRUCTURES( $
    A.power_flux, $
    offset = (dz/2) - 1, $
    ytitle = '3-minute power', $
    file = 'power_flux.pdf' )

; Power (maps)
power_maps_struc = PLOT_STRUCTURES( $
    A.power_maps, $
    offset = (dz/2) - 1, $
    ytitle = '3-minute power', $
    file = 'power_maps.pdf' )

; Average power
dz = 64
aia1600power = WA_AVERAGE(A[0].flux, A[0].power_maps, dz=dz)
aia1700power = WA_AVERAGE(A[1].flux, A[1].power_maps, dz=dz)

power_average_struc = PLOT_STRUCTURES( $
    [ [aia1600power], [aia1700power] ], $
    offset = dz-1, $
    ytitle = '3-minute power', $
    file = 'average_power_maps.pdf' )

end
