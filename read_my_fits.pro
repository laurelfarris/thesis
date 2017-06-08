;; Last modified:   04 June 2017 14:25:42
;; Filename:        read_my_fits.pro
;; Programmer:      Laurel Farris



; Description:      Read/restore data and headers, and create array of structures,
;                       one for each bandpass, with coronal hole data (1000x1000)

; Note: Written to correct for shifts using header info,
;   since corrections were not made before aligning.
; Need to redo all data to correct from the beginning.

; Tested that xcen and ycen were the same for each image in a given wavelength by using
; IDL's ARRAY_EQUAL routine.

; get_data = 0 --> Restore data from .sav files
; get_data = 1 --> Read in data from fits files (takes a long time)


pro READ_MY_FITS, index, data, path=path, z=z, nodata=nodata


    fls = (file_search(path))

    if not keyword_set(z) then z = [0:n_elements(fls)-1]
    print, n_elements(z)


    READ_SDO, fls[z], index, data, nodata=nodata

    RETURN


    if keyword_set(nodata) then return

    ;; Shift data cube according to header information (may not have to do this)
    for i = 0, z-1 do begin
        data[*,*,i] = shift( data[*,*,i], round(index[0].xcen), round(index[0].ycen), 0 )
    endfor

end


path = '/solarstorm/laurel07/Data/AIA/aia*2011*.fits'
READ_MY_FITS, aia_index, aia_data, path=path, nodata=0

path = '/solarstorm/laurel07/Data/HMI/hmi*2011*continuum.fits'
READ_MY_FITS, hmi_index, hmi_data, path=path, nodata=0

end
