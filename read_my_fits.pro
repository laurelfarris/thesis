;; Last modified:   10 April 2018


pro read_my_fits, channel, index=index, data=data
    ; Read headers
    path = '/solarstorm/laurel07/Data/AIA/'
    files = '*aia*' + channel + '*2011-02-15*.fits'
    fls = (file_search(path + files))
    if arg_present(data) then nodata=0 else nodata=1
    READ_SDO, fls, index, data, nodata=nodata
    
end
