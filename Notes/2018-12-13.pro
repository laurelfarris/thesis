
;- 13 December 2018


goto, start


;- HMI prep routine!


dw
wx = 8.0
wy = 11.0
win = window( dimensions=[wx,wy]*dpi, location=[600,0] )

im = image2( H[0].data[*,*,0], /current, layout=[1,2,1], margin=0.2 )
im = image2( H[1].data[*,*,0], /current, layout=[1,2,2], margin=0.2 )

stop



flux = [ [H[0].flux], [H[1].flux] ]


flux_norm = []
flux_norm = [ [ flux_norm ], $
    [ (H[0].flux-min(H[0].flux)) / (max(H[0].flux)-min(H[0].flux)) ], $
    [ (H[1].flux-min(H[1].flux)) / (max(H[1].flux)-min(H[1].flux)) ] ]


wx = 8.0
wy = 8.0
win = window( dimensions=[wx,wy]*dpi, location=[600,0] )

color = ['green', 'purple']
p = objarr(2)
for ii = 0, 1 do begin
    p[ii] = plot2( $
        ;flux[*,ii], $
        flux_norm[*,ii], $
        /current, $
        overplot=ii<1, $
        color=color[ii] )
endfor


start:;---------------------------------------------------------------------------------
delvar, leg
leg = legend2( target=p )




stop


;- 11 December 2018


flux1 = A[0].flux
flux2 = flux1 - mean(flux1)

sigma1 = (moment(flux1));[1]
sigma2 = (moment(flux2));[1]


print, sigma1
print, sigma2


;- No, stddev does not change for mean-subtracted flux,
;-  as expected.


end
