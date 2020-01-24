;Copied from clipboard


dz = 64
maxflux = fltarr(749-dz+1)
for ii = 0, 748 do begin
    maxflux[ii] = max( A[cc].data[*,*,ii:ii+dz-1] )
endfor
print, min(maxflux) ;-  2955.66
print, max(maxflux) ;- 16754.1

end

