;Copied from clipboard


plt3 = BATCH_PLOT( $
    ;ind, $
    xdata[2:*,*], $   ;- xdata defined above as [ [ind], [ind] ] so dimensions match ydata.
    detrended, $
    stairstep=1, $
    ;ytickvalues=[-1.e6, 0, 1e6], $
    ;ytickvalues=[0.0], $
    ;overplot = 1<cc, $
    title = 'Detrended', $
    ;color=['dark orange', 'blue'], $
    color=A.color, $
    wx=wx, wy=wy, $
    left = 0.75, right=0.25, $
    ;thick = 2.0, $
    buffer=0)

    end

