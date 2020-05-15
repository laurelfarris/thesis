;Copied from clipboard


;+
;-
;- SUBTRACT inverse transfrom
detrended = flux[2:*,*] - inverseTransform[1:*,*]
title = 'Detrended (flux - inverseTransform)'
fname = 'lc_detrended_SUBRACTED'
;-
;- DIVIDE inverse transfrom
;detrended = flux[2:*,*] / inverseTransform[1:*,*]
;title = 'Detrended (flux / inverseTransform)'
;fname = 'lc_detrended_DIVIDED'
;-
;-
dw
plt3 = BATCH_PLOT( $
    ;ind, $
    ;xdata[2:*,*], $   ;- xdata defined above as [ [ind], [ind] ] so dimensions match ydata.
    xdata[10:*,*], $
    detrended[8:*,*], $
    stairstep=1, $
    ;ytickvalues=[-1.e6, 0, 1e6], $
    ;ytickvalues=[0.0], $
    ;overplot = 1<cc, $
    title = title, $
    ;color=['dark orange', 'blue'], $
    color=A.color, $
    wx=wx, wy=wy, $
    left = 0.75, right=0.25, $
    ;thick = 2.0, $
    buffer=buffer $
)
;-
save2, fname

end

