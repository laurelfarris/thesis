
;- Copy and paste this - don't have to call as a general routine.



;- Create array of images
z = [265:276]
data = A.data[*,*,z,*]

;- Layout of graphic
rows = 4
cols = 3

wx = 8.5
wy = 11.0
win = window( dimensions=[wx,wy]*dpi, /buffer )

for cc = 0, 1 do begin
    for ii = 0, n_elements(z)-1 do begin
        image_data = aia_intscale( $
            data[*,*,ii,cc], wave=fix(A[cc].channel), exptime=A[cc].exptime )
        im[ii] = image2( $
            image_data, /current, layout=[cols,rows,ii+1], $
            margin=0.1, $
            rgb_table = A[cc].ct, $
            title = A[cc].time[z[ii]] )

    endfor

    ;- Filename to save
    file = 'aia' + A[cc].channel + 'ribbons.pdf'
    save2, file
endfor

end
