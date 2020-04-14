;+
;- 14 April 2020
;-
;- running average LCs to accompany time-freq power plots (aka discrete WA)
;- has been on to-do list for way too long, seems like should be relatively simple..
;-



buffer=1

dz = 64

sz = size(A.flux, /dimensions)

lc_avg = fltarr( sz[0]-dz+1, sz[1] )
help, lc_avg

for cc = 0, 1 do begin
    for ii = 0, sz[0]-dz do begin
        lc_avg[ii,cc] = MEAN( A[cc].flux[ ii:ii+dz-1 ] )
    endfor
endfor

print, max(lc_avg[*,0])
print, max(lc_avg[*,1])


dw
plt = objarr(2)
for cc = 0, 1 do begin
    plt[cc] = plot2( $
        lc_avg[*,cc], $
        buffer=buffer, $
        overplot=cc<1, $
        linestyle=cc $
    )
endfor
;-
;-
save2, 'LC_running_avg'
;-
;-


end
