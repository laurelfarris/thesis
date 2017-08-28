;; Last modified:   18 August 2017 18:04:17

goto, START

n = 65
m = 100

y = a6_flux[a6t1+65:a6t2-100]

w = window( dimensions=[700,400] )

;vert = plot( [n,n], [min(y),max(y)], /overplot )


diff = y - shift(y, 1)

arr = [ [y], [diff] ]


for i = 0, n_elements(arr)-1 do begin
    p = plot( arr[*,i], xstyle=1, ystyle=1, layout=[1,2,i+1], margin=0.1, /current)
endfor

;--------------------------------------------------------------------------------------------------
;; Confirming that calculating total flux before taking difference is the same as when
;; flux is calculated after taking difference images.

arr = randomu( seed, 10,10,10 )

f1 = []
for i=0, 9 do begin
    f1 = [f1, total( arr[*,*,i] ) ]
endfor
d1 = f1 - shift(f1,1)


f2 = []
for i=0, 9 do begin
    d2 = arr[*,*,i] - arr[*,*,i-1]
    f2 = [f2, total(d2)]
endfor


START:;-------------------------------------------------------------------------------------------

end
