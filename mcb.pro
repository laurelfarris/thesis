;Copied from clipboard


@parameters
print, class
format = '(e0.2)'
for cc = 0, 1 do begin
;    print, min(A[cc].flux), format=format
;    print, max(A[cc].flux), format=format
    print, max(A[cc].flux)/min(A[cc].flux), format=format
endfor

end

