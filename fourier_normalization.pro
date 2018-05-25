;; Last modified:   09 May 2018 10:00:03


; Layout of code to check for correct normalization.


flux = A[0].flux
result = fourier2( flux, 24, NORM=0 )
power = reform( result[1,*] )


; These should be equal... I think.
print, n_elements( flux )/2
print, n_elements( power )

; 11 May --- They are!


; Check on normalization:
; by Parseval's theorem, these should be the same because of
; conservation of energy.
print, total( power )
print, ( moment(flux) )[1]

; Only getting equal values if /norm kw is NOT set.



end
