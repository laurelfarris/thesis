;Copied from clipboard


;- With the "props" structures, the call to plot_pt is still exactly
;-  the same in _maps as it is in _flux...
;- NOTE: xdata is defined in plot_pt
resolve_routine, 'plot_pt', /is_function
plt = PLOT_PT( $
    power, dz, A[0].time, buffer=1, $
    stairstep = 1, $
    ;yminor = 4, $
    name = A.name )
    ;yrange=[-250,480], $ ; maps
;ax = plt[0].axes
;ax[1].tickname = strtrim([68, 91, 114, 137, 160],1)
;ax[3].tickname = strtrim([1220, 1384, 1548, 1712, 1876],1)
ax2 = (plt[0].axes)[1]
ax2.title = plt[0].name + " 3-minute power"
ax2.text_color = plt[0].color
ax3 = plt[1].axes
ax3.title = plt[1].name + " 3-minute power"
file = 'time-3minpower_maps'
save2, file

end

