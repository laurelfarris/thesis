; Last modified:   25 April 2018



pro read_hmi_fits, type, index=index, data=data

    path = '/solarstorm/laurel07/Data/HMI/*45s*magnetogram*.fits'
    fls = file_search(path)
    fls = fls[0:120]
    if arg_present(data) then nodata=0 else nodata=1
    READ_SDO, fls, index, data, nodata=nodata
end


function PREP_HMI, type, index=index

    if not keyword_set(index) then $
        read_hmi_fits, type, index=index, data=data

    ; Put the rest of this off for now, since data needs to be aligned
    ; before I can do anything else (2018-04-24)
    ;jd = get_jd( index )

    struc = { $
        name : 'HMI', $
        data : data, $
        cadence : 45.0 $
        }
    return, struc

end

hmi = PREP_HMI( '*45*magnetogram', index=hmiindex )
; Works! And looks like hmiindex IS returned to the main level, even
; though this is a function. I thought the only value returned was the
; one after the 'return' statement... I will never understand this language...

end
