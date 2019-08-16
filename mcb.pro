;Copied from clipboard


;- With the "props" structures, the call to plot_pt is still exactly
;-  the same in _maps as it is in _flux...
;- NOTE: xdata is defined in plot_pt
resolve_routine, 'plot_pt', /either
plt = PLOT_PT( power, dz, A[0].time, buffer=1, _EXTRA=props )
;ax = plt[0].axes
;ax[1].tickname = strtrim([68, 91, 114, 137, 160],1)
;ax[3].tickname = strtrim([1220, 1384, 1548, 1712, 1876],1)
file = 'time-3minpower_maps'
save2, file

end

