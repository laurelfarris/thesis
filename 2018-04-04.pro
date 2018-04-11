

test = []
for i = 0, 224, 9 do begin
    test = [test, i]
endfor
print, n_elements(test)

; 04 April 2018
;  Currently  -->  cube [ 500 330 749 ]
map = power_maps(temp, z=indgen(100), dz=50, ind=ind, cadence=24)
