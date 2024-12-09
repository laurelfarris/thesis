;Copied from clipboard


resolve_routine, 'batch_plot', /either
dw
plt = BATCH_PLOT(  $
    aia_xdata, $
    aia_ydata, $
    axis_style=1, $
    ;ystyle=0, $   ; NICE range
    ;ystyle=1, $   ; EXACT data range
    ;ystyle=2, $   ; pad axes slightly BEYOND NICE range
    ;ystyle=3, $   ; pad axes slightly BEYOND EXACT range
    thick=[0.5, 0.8], $
    ;   1700 slightly thicker plot curve than 1600, for grayscale printouts :)
    ;xrange=[0,n_obs-1], $
    xtickinterval=xtickinterval, $
    xminor=xminor, $
    ;yticklen=yticklen, $
    ;stairstep=stairstep, $
    color=A.color, $
    name=A.name, $
    ;symbol="None", $
    buffer=buffer $
)

end

