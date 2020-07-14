;Copied from clipboard


ind = [200:nbins-1]
;
wx = 8.0
wy = 8.0
dw
win = window( dimensions=[wx,wy]*dpi, buffer=buffer )
resolve_routine, 'plot2', /is_function
plt = plot2( $
    xdata, result, $
    ;xdata[ind], result[ind], $
    /current, $
    stairstep=1, $
    ;xlog=1, $
    ylog=1, $
    ;xmajor=
    ;yrange=[0.1, 10^(ceil(alog10(max(result)))) ], $
    ;yrange=[0,10], $
    ;min_value=0, $
    xticklen=(0.10/wy), $
    yticklen=(0.10/wx), $
    title='C3.0 pre-flare ' + bda_time[0,0] + '-' + bda_time[1,0], $
        ;- [] need better multiflare structure setup for this!
    ytitle='# pixels', $
    xtitle='3-minute power', $
    buffer=buffer $
)
save2, 'histogram'

end

