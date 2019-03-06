



;- 22 October 2018

goto, start


start:;-------------------------------------------------------------------------------
;- Flare emergence and evolution at start of Feb 15, 2011 flare
;z = [257:268] - 120
z = [0:260:22]
z = [75:260:22]

stop

data = A.data[*,*,z,*]
sz = size( data, /dimensions )

wx = 8.5
wy = wx * (float(sz[1])/sz[0]) * (float(rows)/cols)

rows = 4
cols = 3

im = objarr(n_elements(z))


for cc = 0, 0 do begin

    dw
    win = window( dimensions=[wx,wy]*dpi, /buffer )

    image_data = aia_intscale( $
        data[*,*,*,cc], wave=fix(A[cc].channel), exptime=A[cc].exptime )

    for ii = 0, n_elements(z)-1 do begin


        im[ii] = image2( $
            image_data[*,*,ii], /current, layout=[cols,rows,ii+1], $
            margin=0.1, $
            xshowtext=0, $
            yshowtext=0, $
            rgb_table = A[cc].ct, $
            title = alph[ii] + ' ' + A[cc].time[z[ii]]  + $
                ' (' + strtrim(z[ii],1) + ')' $
            )

    endfor
    ;file = 'aia' + A[cc].channel + 'pre-flare.pdf'
    file = 'aia' + A[cc].channel + 'ribbons.pdf'
    save2, file
endfor

end
