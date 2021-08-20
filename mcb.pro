;Copied from clipboard


ydata = [ [power1], [power2] ]
;ydata = [ [power1/max(power1)], [power2/max(power2)] ]
resolve_routine, 'plot_spectra', /is_function
plt = PLOT_SPECTRA( $
    xdata, $
    ydata, $
    leg=leg, $
    name=name, $
    ylog=1, $
    buffer=buffer $
)
;
leg[0].label=name[0]
leg[1].label=name[1]
;
save2, 'testOldSubroutine'
;save2, 'testOldSubroutine_norm'

end

