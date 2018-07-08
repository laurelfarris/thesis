


; 07 July 2018

; test plot, then hide, then v-lines, then show again.


x = indgen(10)
y = x^2


w = window( /buffer )
p = plot2( x, y, /current, /nodata )
;p.hide = 1

v = plot2( [5,5], p.yrange, /overplot, ystyle=1, thick=3 ) 
p = plot2( x, y, /overplot, ystyle=1, color='red', thick=3)

;p.hide = 0

save2, 'test.pdf'

; Works if first create graphic with /nodata, 
;   then plot in order from background to foreground.


end
