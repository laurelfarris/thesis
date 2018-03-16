;; Last modified:   14 March 2018





full = indgen(10)
bad = [2,3,4]
good = full

foreach i, bad do begin
    good[ where( good eq i ) ] = -1
endforeach


stop

for i = 0, n_elements(full)-1 do begin
    j = where( bad eq i )
    if j eq -1 then good = [ good, i ]
endfor

end
