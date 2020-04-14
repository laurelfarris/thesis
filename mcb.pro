;Copied from clipboard


dw
plt = objarr(2)
for cc = 0, 1 do begin
    plt[cc] = plot2( $
        lc_avg[*,cc], $
        buffer=buffer, $
        overplot=cc<1, $
        linestyle=cc $
    )
endfor
;-
;-
save2, 'LC_running_avg'
;-
;-

end

