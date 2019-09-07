;Copied from clipboard


A.map = A.map * map_mask
for cc = 0, n_elements(A)-1 do begin
    print, ""
    print, A[cc].channel, ":"
    print, "  min PowerMap = ", min(A[cc].map);, format=format
    print, "  max PowerMap = ", max(A[cc].map);, format=format
endfor

end

