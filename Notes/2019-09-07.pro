


@parameters


;- HMI images for each of the 3 flares

resolve_routine, 'read_my_fits', /either
read_my_fits, $
    ;/syntax, $
    index, data, fls, $
    instr='hmi', $
    channel='mag', $
    ind=150, $
    nodata=0, $
    prepped=0
print, index.date_obs


;dataC30 = crop_data( data, center=center )
;im = image(dataC30)

;dataC30 = rotate(data, 2)
;dataC30 = CROP_DATA(dataC30, center=[1600,1575])
im = image(dataC30, max_value = 300, min_value=-300)
;-  11:53:39.30



;dataM73 = rotate(data, 2)
;dataM73 = CROP_DATA(dataM73, center=[3070,1615])
im = image(dataM73, max_value = 300, min_value=-300)
;-  11:53:04.60



;dataX22 = rotate(data, 2)
;dataX22 = crop_data(dataX22, center=[2460,1620])
im = image(dataX22, max_value = 300, min_value=-300)
;-  01:54:27.30






imdata = [ [[dataC30]], [[dataM73]], [[dataX22]] ]
help, imdata

win = window( dimensions=[8.5,11.0]*dpi )
for ii = 0, 2 do begin
    im = image2( $
        imdata[*,*,ii], $
        /current, $
        layout=[1,3,ii+1], $
        margin=0.1 $
        )
endfor
        

end
