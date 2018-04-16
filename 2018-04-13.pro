;; Last modified:   13 April 2018 11:17:37


goto, start

channel = '1600'
read_my_fits, channel, index=index


xstepper2, (A[0].data)^0.5, subscripts=[75:150]
temp = A[1].data[*,*,0:100]
locs = array_indices( temp, where( temp ge 15000.0 ) )



temp = A[1].data[*,*,0:5]
;w = window( dimensions=[8.5, 9.0]*72)


position = get_position2(layout=[2,3], width=3.0, ratio=330./500.)

im = objarr(6)
for i = 0, 5 do begin

    im[i] = image2( $
        temp[*,*,i]^0.5, $
        /current, $
        /device, $
        position=position[*,i], $
        xtitle='X (pixels)', $
        ytitle='Y (pixels)' $
    )
endfor

for i = 0, 5 do im[i].xtitle='blah'



start:;----------------------------------------------------------------------------------

end
