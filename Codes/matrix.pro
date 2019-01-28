


M1 = 1
N1 = 4

M2 = 4
N2 = 1


AA = intarr(M1,N1) + 1
;AA = make_array( 1, 5, value=1 )
;print, AA
;print, ''
help, AA


BB = reform(indgen(M2, N2), M2, N2 )
;BB = reform( indgen(M2,N2), M2, N2 )
;BB = indgen(5)
;print, BB
;print, ''
help, BB


stop
print, AA ## BB


end
