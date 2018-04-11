;; Last modified:   14 March 2018


pro plot_detrended_signal


    ;; Detrended signal
    a6diff = (a6flux - a6smooth)/a6smooth
    a7diff = (a7flux - a7smooth)/a7smooth


    ;; 1600
    x = a6jd
    y = a6flux
    a6_detrended = (y-a6sm)/a6sm
    y = a6flux-min(a6flux)
    y = y/max(y)
    bg = mean(y[0:10])
    a6sm = smooth(y,8)


    ;; 1700
    x = a7jd
    y = a7flux-min(a7flux)
    y = y/max(y)
    bg = mean(y[0:10])
    a7sm = smooth(y,8)

    a7_detrended = (y-a7sm)/a7sm

    y = y + 0.2
    p4 = plot( x, y, /overplot, $
        color='dark cyan', $
        name="AIA 1700$\AA$", $
        _EXTRA=props )
    p5 = plot( x, a7sm, /overplot, linestyle=2, thick=1.5 )
    p6 = plot( [x[0],x[-1]], [bg,bg], $
        /overplot, linestyle=1, thick=1.0)

    ;; Detrended lightcurves
    y = a6_detrended
    ;y = a6_detrended - min(a6_detrended)
    ;y = y/max(y)
    p7 = plot( $
        a6jd, y, /current, $
        layout=[1,2,2], $
        margin=[0.1, 0.1, 0.1, 0.0], $
        color='dark orange', $
        _EXTRA=props )
    y = a7_detrended
    ;y = a7_detrended - min(a7_detrended)
    ;y = y/max(y)
    p8 = plot( $
        a7jd, y, /overplot, $
        color='dark cyan', $
        _EXTRA=props )

end
