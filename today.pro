



; test plot, then hide, then v-lines, then show again.


x = indgen(10)
y = x^2


w = window( /buffer )
p = plot2( x, y, /current, color='red', thick=2 )

v = plot2( [5,5], p.yrange, /overplot, ystyle=1, thick=2 ) 

save2, 'test.pdf'


end
