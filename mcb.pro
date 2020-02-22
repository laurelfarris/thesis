;Copied from clipboard


;- 21 February 2020 -- apparently plot_pt used to be pro, not func
;resolve_routine, 'plot_pt';, /either
;PLOT_PT, power, dz, A[0].time, _EXTRA = props
;-
resolve_routine, 'plot_pt', /is_function
plt = PLOT_PT( A[0].time, power, dz, buffer=0);, _EXTRA = props
;-

end

