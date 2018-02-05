;; Last modified:   05 February 2018 16:24:34

pro plot_lightcurves, x, y

    ;; Properties for entire panel
    props = { $
        font_size      : 12, $
        xtickfont_size : 10, $
        ytickfont_size : 10, $
        xtitle         : "Start time (15-Feb-11 00:30:00)", $
        ytitle         : "Normalized Intensity", $
        thick          : 1.5, $
        xmajor         : 7, $
        xminor         : 5, $
        xtickname      : ['01:30','01:40','01:50','02:00','02:10','02:20','02:30'], $
        stairstep      : 1, $
        xstyle         : 1, $
        ystyle         : 2, $
        axis_style     : 2 $
    }

    ;; Make plots
    dw
    wx = 1100
    wy = 550
    w = window( dimensions=[wx,wy] )

    lc = plot( x, y, /nodata, /current, $
        layout=[1,1,1], $
        margin=[0.1, 0.1, 0.1, 0.1], $
        _EXTRA=props )



end

;; Get total flux
a6flux = total( total(a6,1), 1 )
a7flux = total( total(a7,1), 1 )

aia1600 = { $
    jd : a6jd, $
    flux : a6flux, $
    smooth_flux : smooth(a6flux,8), $
    background : mean(a6flux[0:9]), $
    name : "AIA 1600$\AA$", $
    color : 'dark orange' $
}
aia1700 = { $
    jd : a7jd, $
    flux : a7flux, $
    smooth_flux : smooth(a7flux,8), $
    background : mean(a7flux[0:9]), $
    name : "AIA 1700$\AA$", $
    color : 'dark cyan' $
}

s = create_struct( 'aia1600', aia1600, 'aia1700', aia1700 )

plot_lightcurves, s.aia1600.jd, s.aia1600.flux

n = n_tags(s)
p = objarr(n)
sm = objarr(n)
bg = objarr(n)
for i=0,n-1 do begin
    p[i] = plot( s.(i).jd, s.(i).flux, $
        /overplot, $
        color=s.(i).color, $
        name=s.(i).name $
        )
    sm[i] = plot( s.(i).jd, s.(i).smooth_flux, $
        /overplot, $
        linestyle=2, $
        name="Boxcar smoothed"
    bg[i] = plot( p[i].xrange, [s.(i).background,s.(i).background], $
        /overplot, $
        linestyle=1, $
        thick=1.0, $
        name="Background")
endfor

STOP
flare_start = '01:30'
flare_end   = '02:30'

; Indices of flare start/stop
time = strmid( a6index.t_obs, 11, 5 )
t1 = ( where( time eq flare_start ) )[ 0]
t2 = ( where( time eq flare_end   ) )[-1]

x = [ a6jd[t1], a6jd[t2] ]
for i = 0, 1 do begin
    v = plot( [ x[i], x[i] ], p.yrange, $
        /overplot, $
        linestyle=2, $
        thick=1.0 $
        )
endfor




STOP

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

leg = legend( target=[p1,p2,p3,p4], font_size=10, $
    position=[0.9,0.9], linestyle=6, shadow=0 )

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
