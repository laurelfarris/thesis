; 13 July 2018

; Does graphic really need to have actual data?
; When overplotting data that lies outside of current axis range,
; does plot expand to include all of the new plot?
x = indgen(10)
y = x^2
graphic = plot2( x, y, /nodata, /buffer )
x = indgen(20)
y = x^2
p = plot2( x, y, /overplot )
save2, 'test_overplot.pdf'

stop



; 12 July 2018

goto, start

restore, '../aia1600map.sav'
sz = size(map, /dimensions)
n_zeros = intarr(sz[2])
stop
for i = 0, sz[2]-1 do begin
    n_zeros[i] = n_elements( where( map[*,*,i] eq 0.0 ) )
endfor
; nevermind... power is 0.0 in some map pixels where data did not saturate


start:
power = get_power(A[0].flux, cadence=24, channel='1600', data=A[0].data)
print, max(power)
stop
power = get_power_from_maps( A[0].data, '1600', threshold=10000, dz=64 )


stop

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
