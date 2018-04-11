;; Last modified:   04 April 2018


GOTO, start


;  Currently  -->  cube [ 500 330 749 ]


start:;-----------------------------------------------------------------------------
x = (findgen(225))/10.
y = sin(x)
y2 = [y, fltarr(100)]
y3 = [y, fltarr(500)]

result1 = fourier2( y,  24 )
result2 = fourier2( y2, 24 )
result3 = fourier2( y3, 24 )
;period = reform( 1./ result[0,*] )

@graphics
p1 = plot( result1[0,*], result1[1,*], xrange=[0.0,0.0025], $
    dimensions=[1800,800], $
    _EXTRA=plot_props )
p2 = plot( result2[0,*], result2[1,*], /overplot, color='blue' )
p3 = plot( result3[0,*], result3[1,*], /overplot, color='red' )


end
