;; Last modified:   09 May 2018 10:00:03


; Layout of code to check for correct normalization.


flux = hmi[0,0,*] ; or something...
result = fourier2( flux, 45, /NORM )
power = reform( result[1,*] )


a = n_elements( flux )
b = n_elements( power )
; a should = b/2... I think.
print, a
print, b


; By Parseval's theorem, these should be the same?
; At least if the normalization kw is set... I think.
; Because this is supposed to be a check on normalization.
total_power = total( power )
var = ( moment(flux) )[1]



end
