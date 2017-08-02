;; Last modified:   13 June 2017 14:02:31



n = 1000
delt = (2*!PI)/n
delt = 1.0
x = make_array(n, /index,increment=delt)
y = sin(x)
;y2 = 0.5*sin(x+(!PI/4.))
;delt = 45.0


;;; This is all standard... put into subroutine!
;; Array containing power and phase at each frquency (according to comments).
result = Fourier2( y, delt )

frequency = result[0,*]
power_spectrum = result[1,*]
phase = result[2,*]
amplitude = result[3,*]

ytitle=["frequency", "power spectrum", "phase", "amplitude"]

;resolve_routine, "graphic_configs"
;e = graphic_configs(2)
w = my_window( 700, 700, /del )


for i = 0, 3 do begin
    p = plot(result[i,*], layout=[2,2,i+1], /current, $
    ytitle=ytitle[i], xtitle="") ;,  _EXTRA=e)
endfor


end
