; Last modified:   09 April 2018



goto, start

; Calculate total power
z = [0:199:10]
dz = 64
total_power, A[0], z, dz, frequency, power
aia1600 = create_struct( aia1600, 'power', power )
total_power, A[1], z, dz, frequency, power
aia1700 = create_struct( aia1700, 'power', power )
stop


; kind of a mess, but a good start.

; If I have nested loops, that's probably a good sign
; that the innermost one can go in a subroutine.



for i = 0, rows*cols-1 do begin

    plot_ft, 1000*frequency, A, z[i], pos

endfor



leg = legend2( target=[ p[0], p[1]] )




; AIA 1600
;ft_again, A[0].flux

; AIA 1700
;ft_again, A[1].flux



end
