;; Last modified:   01 February 2018 13:09:49


GOTO, START


flare_start = '01:30'
flare_end   = '02:30'

;; Decimal time - hours since midnight on day of flare
TIMESTAMPTOVALUES, index.t_obs, hour=hour, minute=minute, second=second
a7t_decimal = hour + (minute/60.) + (second/3600.)


;; Array of observation times in form 'hh:mm', for comparing to flare start and end
;;    times, plus used as axis labels for lightcurves.
a7t_obs = strmid( index.t_obs, 11, 5 )
t1 = (where(a7t_obs eq flare_start))[ 0]
t2   = (where(a7t_obs eq flare_end  ))[-1]



START:
props = { $
    font_size      : 11, $
    xtickname      : ['01:30','01:40','01:50','02:00','02:10','02:20','02:30'], $
    xtickfont_size : 9, $
    xtitle         : "UT time (15 February 2011)", $
;    ytitle         : "Intensity (DN s$^{-1}$)", $
    thick          : 1.5, $
    xmajor         : 7, $
    xminor         : 10, $
    stairstep      : 1, $
    xstyle         : 1, $
    ystyle         : 2, $
    axis_style     : 2 $
}


x = a7t_decimal[t1:t2]
y = flux[t1:t2]

;; Smooth lightcurve
y_smooth = smooth(y,8)
y_diff = (y - y_smooth)/y_smooth

wx = 1000
wy = 500
w = window( dimensions=[wx,wy] )


;; First panel
lightcurve = plot( x, y, $
    /current, $
    layout=[1,2,1], $
    margin=[0.2, 0.1, 0.2, 0.2], $
    ;color='dark orange', $
    color='dark cyan', $
    xshowtext=0, $
    ;yrange=[2e7,8e7], $
    title = "SDO/AIA  1700$\AA$", $
    _EXTRA=props )

smooth_lc = plot( x, y_smooth, $
    /overplot, linestyle=2, thick=1.5 )

bg = plot( [ x[0],x[-1] ], [mean(y[0:10]),mean(y[0:10])], $
    /overplot, linestyle=1, thick=1.0 )


;; Second panel
subtracted_lc = plot( $
    x, y_diff, /current, $
    layout=[1,2,2], $
    margin=[0.2, 0.2, 0.2, 0.1], $
    ;color='dark orange', $ Save this color for AIA 1600
    color='dark cyan', $
    _EXTRA=props )



STOP

;; old ft, for choppy lightcurve
;result    = fourier2( y, 24.0, /norm )

;; new ft, for smooth lightcurve
result    = fourier2( y_diff, 24.0 )

frequency = result[0,*]
power     = reverse( result[1,*], 2 )
period    = reverse( (1./(frequency)), 2 )


locs = where( period lt 400 )  ; My own 'filter'
period = period[locs]
power = power[locs]

wx = 1000
wy = 300
w = window( dimensions=[wx,wy] )



props = { $
    title : "SDO/AIA  1700$\AA$", $
    xtitle : "Period [seconds]", $
    ytitle : "Power", $
    font_size      : 11, $
    xtickfont_size : 9, $
    ytickfont_size  :  9, $
    thick          : 1.5, $
    ystyle         : 2, $
    axis_style     : 2 $
}


ft = plot( period, power, /current, $
    ;xrange=[50,1000], $
    ;yrange=[0,0.13], $
    xlog=1 $
)

v1 = plot( [120,120], [0,max(power)], /overplot, linestyle=1 )
v2 = plot( [180,180], [0,max(power)], /overplot, linestyle=2 )





STOP

xstepper, data, xsize=512, ysize=512

;lc[0] = plot( hx, hy, /current, margin=0.08,  color='sea green', _EXTRA=props)
;lc[1] = plot( ax, a6y, /overplot, color='deep sky blue', _EXTRA=props )
;lc[2] = plot( ax, a7y, /overplot, color='firebrick', _EXTRA=props )


;t = text( 0.7, 0.28, "HMI", font_size=fontsize-1, font_name=fontname)
;t = text( 0.7, 0.44, "AIA 1600$\AA$", font_size=fontsize-1, font_name=fontname )
;t = text( 0.7, 0.69, "AIA 1700$\AA$", font_size=fontsize-1, font_name=fontname)
;ax = lc[0].axes
;ax[3].showtext = 1
;ax[3].title="inst"
;ax[3].tickname = [ "", "hmi", "", "aia1600", "", "", "", "aia1700", "", "" ]


;txt = text( x, y, filename, font_size=fontsize-2, font_name=fontname)



; Add vertical line at flare start/peak/etc. times (25 Sep 2017)-------------------

; start/peak times, according to GOES (or AIA? or both??)
;x1 =
;x2 =

; Min/max y values of lightcurve plot
;y1 =
;y2 =


;vert = plot( [x1, x1], [y1,y2], linestyle=2, /overplot )
;vert = plot( [x2, x2], [y1,y2], linestyle=2, /overplot )




END
