



; 26 August 2018
; What frequency resolution is obtained with time segment 100 minutes in length?
; 749/3 = 249.667, so each segment is dz = 249 frames in length.
; Gives frequency resolution of 0.1673 mHz

ind = [0, 249

for k = 0, 1 do begin

    flux = A[k].flux

    for i = 0, 2,  do begin

        S = CALC_FT( flux[, 24 )


        p = plot( S.frequency
        ; Don't forget, there's a subroutine for this!
    endfor
endfor

end
