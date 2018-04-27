; Last modified:   25 April 2018



pro read_hmi_fits, type, index=index, data=data

    path = '/solarstorm/laurel07/Data/HMI/*45s*magnetogram*.fits'
    fls = file_search(path)
    fls = fls[0:120]
    if arg_present(data) then nodata=0 else nodata=1
    READ_SDO, fls, index, data, nodata=nodata
end


function PREP_HMI, type, index=index

    ;if not keyword_set(index) then $
        read_hmi_fits, type, index=index, data=data

    ; Put the rest of this off for now, since data needs to be aligned
    ; before I can do anything else (2018-04-24)
    ;jd = get_jd( index )

    sz = size(data, /dimensions)
    data_rotated = fltarr(sz)

    for i = 0, sz[2]-1 do $
        data_rotated[*,*,i] = ROT( data[*,*,i], 180 )

    struc = { $
        name : 'HMI', $
        data : data_rotated, $
        cadence : 45.0 $
        }
    return, struc

end


pro image_hmi, data

    common defaults

    sz = float(size(data, /dimensions))

    wx = 4.25
    wy = wx * (sz[1]/sz[0])

    w = window( dimensions=[wx,wy]*dpi )

    im = image2( $
        data, $
        /current, $
        title='HMI B$_{LOS}$ 2011-February-15 00:01:24', $
        xtitle='X (pixels)', $
        ytitle='Y (pixels)' $
        )

end

;hmi = PREP_HMI( '*45*magnetogram', index=hmiindex )
; Works! And looks like hmiindex IS returned to the main level, even
; though this is a function. I thought the only value returned was the
; one after the 'return' statement... I will never understand this language...

hmi_image = rot( hmi.data[*,*,0], 180 )
x0 = 2440
y0 = 1600
image_hmi, hmi_image[x0-250:x0+250-1, y0-165:y0+165-1, 0]

save2, 'hmi_image.pdf'



end
