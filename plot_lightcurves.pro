;; Last modified:   14 March 2018

width = 5.0
height = 2.0
cols = 1
rows = 1
@graphics


p = objarr(2)
sm = objarr(2)
background = objarr(2)

for i=0,1 do begin

    x = indgen( n_elements(s.(i).jd) )
    y = s.(i).flux
    y = y-min(y)
    y = y/max(y)

    if i eq 0 then begin
        graphic = plot( x, y, /nodata, $
            position=pos[*,i], $
            xtitle = "Start time (15-Feb-11 00:30:00)", $
            ytitle = "Normalized Intensity", $
            yrange = [-0.1,1.1], $
            _EXTRA=plot_props )
        ax = lc.axes
    endif

    p[i] = plot( x, y, $
        /overplot, $
        stairstep=1, $
        color=s.(i).color, $
        name=s.(i).name )

    smooth_flux = smooth(y,8)
    sm[i] = plot( x, smooth_flux, $
        /overplot, $
        linestyle='--', $
        thick=1.0, $
        name="boxcar smoothed")

    bg = mean(y[0:200])
    background[i] = plot( p[i].xrange, [bg,bg], $
        /overplot, $
        linestyle=':', $
        thick=1.0, $
        name="pre-flare background")

endfor
leg = legend( $
    target=[p[0], p[1], sm[0], background[0]], $
    position=pos[2:3] * [wx,wy-10], $
    _EXTRA=legend_props )

ax[2].tickinterval=75
ax[2].minor=5
ax[2].title="Image number"
ax[2].showtext=1

tmp = fix(ax[2].tickvalues)
ax[0].major = n_elements(tmp)
ax[0].tickname = S.(0).time[tmp]


; Indices of flare start/stop
flare_start = '01:30'
flare_end   = '02:30'
t1 = ( where( S.(0).time eq flare_start ) )[ 0]
t2 = ( where( S.(0).time eq flare_end   ) )[-1]

;; Vertical lines for flare start/stop
x = [ a6jd[t1], a6jd[t2] ]
x = [ t1, t2 ]
for i = 0, 1 do begin
    v = plot( $
        [ x[i], x[i] ], $
        graphic.yrange, $
        /overplot, $
        linestyle='-.', $
        thick=1.5 $
        )
endfor


stop
;----------------------------------------------------------------------------------
;; Last modified:   07 February 2018 15:46:35

fontsize = 10
;; Properties for entire panel
props = { $
    font_size      : fontsize, $
    xtickfont_size : fontsize, $
    ytickfont_size : fontsize, $
    xtitle         : "Start time (15-Feb-11 00:30:00)", $
    ytitle         : "Normalized Intensity", $
    thick          : 1.5, $
    ;xminor         : 5, $
    xticklen       : 0.04, $
    yticklen       : 0.01, $
    xstyle         : 1, $
    yrange         : [-0.1,1.1], $
    axis_style     : 2 $
}

;; Make plots

p = objarr(2)
sm = objarr(2)
background = objarr(2)

wx = 816
wy = 1056

for i=0,1 do begin

    x = indgen( n_elements(s.(i).jd) )
    y = s.(i).flux
    y = y-min(y)
    y = y/max(y)

    if i eq 0 then begin
        lc = plot( x, y, /nodata, /device, $
            dimensions=[ wx, wy ], $
            position=[96, 0.75*wy, wx-96, wy-96], $
            _EXTRA=props )
        ax = lc.axes
    endif
    p[i] = plot( x, y, $
        /overplot, $
        stairstep=1, $
        color=s.(i).color, $
        name=s.(i).name )

    smooth_flux = smooth(y,8)
    sm[i] = plot( x, smooth_flux, $
        /overplot, $
        linestyle='--', $
        thick=1.0, $
        name="boxcar smoothed")

    bg = mean(y[0:200])
    background[i] = plot( p[i].xrange, [bg,bg], $
        /overplot, $
        linestyle=':', $
        thick=1.0, $
        name="pre-flare background")

endfor

lpos = lc.position
lpos = lpos[2:3] * [wx,wy-10];,wx,wy]

leg = legend( $
    target=[p[0], p[1], sm[0], background[0]], $
    font_size=fontsize, $
    /device, $
    ;/relative, $
    position=lpos, $
    ;position=[pos[2],pos[3]], $ ;upper right corner (x2,y2)
    ;horizontal_alignment=0.75, $
    linestyle=6, $
    shadow=0 )

ax[2].tickinterval=75
ax[2].minor=5
ax[2].title="Image number"
ax[2].showtext=1

tmp = fix(ax[2].tickvalues)
ax[0].major = n_elements(tmp)
ax[0].tickname = S.(0).time[tmp]


;caldat, x, month, day, year, hour, minute, second
;ind = (where( minute eq 30 ))[0:-1:2]
;ticks = (S.(0).time)[ind]
;lc.xmajor = n_elements(ticks)
;lc.xtickname = ticks


;; vertical lines for flare start/stop

flare_start = '01:30'
flare_end   = '02:30'

; Indices of flare start/stop
t1 = ( where( S.(0).time eq flare_start ) )[ 0]
t2 = ( where( S.(0).time eq flare_end   ) )[-1]

x = [ a6jd[t1], a6jd[t2] ]
x = [ t1, t2 ]
for i = 0, 1 do begin
    v = plot( $
        [ x[i], x[i] ], $
        lc.yrange, $
        /overplot, $
        linestyle='-.', $
        thick=1.5 $
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
