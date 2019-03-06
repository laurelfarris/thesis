



win = WIN_QUICK()

ex = [7, 8]

plt = objarr(2)

for cc = 0, 1 do begin
    plt[cc] = plot2( $
        A[cc].flux/(10.^ex[cc]), $
        /current, overplot=1<cc, $
        margin=0.1, color=A[cc].color )
endfor

end
