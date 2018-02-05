;; Last modified:   01 February 2018 22:03:20

GOTO, START
START:

;; Fourier transforms

a6flux = total(total(a6,1),1)
a7flux = total(total(a7,1),1)

flux = [ [a6flux],[a7flux] ]


STOP
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


wx = 1000
wy = 300
w = window( dimensions=[wx,wy] )

p = objarr(2)

for i=0,1 do begin

    result = fourier2( flux[*,i], 24.0 )

    frequency = result[0,*]
    power     = reverse( result[1,*], 2 )
    period    = reverse( (1./(frequency)), 2 )

    locs = where( period lt 400 )  ; My own 'filter'
    period = period[locs]
    power = power[locs]

    p[i] = plot( period, power, /current, $
        layout=[1,2,i+1], $
        ;xrange=[50,1000], $
        ;yrange=[0,0.13], $
        xlog=1 )
    v1 = plot( [120,120], [0,max(power)], /overplot, linestyle=1 )
    v2 = plot( [180,180], [0,max(power)], /overplot, linestyle=2 )

endfor

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


end
