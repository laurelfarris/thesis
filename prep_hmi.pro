; Last modified:   25 April 2018



function PREP_HMI, index=index

    ;if not keyword_set(index) then $
    ;    read_hmi_fits, type, index=index, data=data

    path = '/solarstorm/laurel07/Data/HMI/*45s*magnetogram*.fits'
    fls = file_search(path)
    fls = fls[0]
    ;if arg_present(data) then nodata=0 else nodata=1
    READ_SDO, fls, index, data;, nodata=nodata

    ; Put the rest of this off for now, since data needs to be aligned
    ; before I can do anything else (2018-04-24)
    ;jd = get_jd( index )

    ; Rotate data 180 degrees
    ;sz = size(data, /dimensions)
    ;data_rotated = fltarr(sz)
    ;for i = 0, sz[2]-1 do $
    ;    data_rotated[*,*,i] = ROT( data[*,*,i], 180 )

    ; Use aia_prep.pro to rotate data, plus coalign with AIA
    aia_prep, index, data, new_index, new_data

    index = new_index

    struc = { $
        name : 'HMI B$_{LOS}$', $
        ;data : data_rotated, $
        data : new_data, $
        cadence : 45.0 $
        }
    return, struc

end


pro image_hmi, data

    common defaults

    sz = float(size(data, /dimensions))

    wx = 8.5/2
    wy = wx * (sz[1]/sz[0])

    w = window( dimensions=[wx,wy]*dpi )

    im = image2( $
        data, $
        /current, $
        title='HMI B$_{LOS}$ 2011-February-15 00:00:27.30', $
        xtitle='X (arcseconds)', $
        ytitle='Y (arcseconds)' $
        )

     im.xtickname = strtrim([50:350:50],1)
     im.ytickname = strtrim([-340:-140:50],1)

end


goto, start
start:;---------------------------------------------------

hmi = PREP_HMI( index=hmiindex )
stop


; Align HMI data
cube = data_rotated
ref = cube[*,*,sz[2]/2]
align_cube3, cube, ref

stop


; from A[0].X[-1] - A[0].X[0] (same for Y)
arcsec_dimensions = [304.07713, 200.48372]

cd1 = hmiindex[0].cdelt1
cd2 = hmiindex[0].cdelt2
pixel_dimensions = arcsec_dimensions / [cd1, cd2]


xx = round(pixel_dimensions[0] / 2)
yy = round(pixel_dimensions[1] / 2)

x0 = 2440
y0 = 1600

;hmi_image = rot( hmi.data[*,*,0], 180 )
;image_hmi, hmi_image[x0-250:x0+250-1, y0-165:y0+165-1, 0]

hmi_image = hmi.data[*,*,0]
image_hmi, hmi_image[x0-xx:x0+xx-1, y0-yy:y0+yy-1, 0]

save2, 'hmi_image_2.pdf'



end
