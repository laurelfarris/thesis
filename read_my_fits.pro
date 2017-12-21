;; Last modified:   01 November 2017 15:53:11
;; Filename:        read_my_fits.pro
;; Programmer:      Laurel Farris


; Tested that xcen and ycen were the same for each image in a given wavelength by using
; IDL's ARRAY_EQUAL routine.

;; Why did I feel the need to have an entire subroutine for this?
;; Probably from the multi-bandpass fiasco.


pro read_aia, aia_1700_data

    aia_path = '/solarstorm/laurel07/Data/AIA/'
    fls = file_search(aia_path + '*1700A*.fits')
    READ_SDO, fls, aia_1700_index, aia_1700_data, nodata=0
    
    ;save, aia_1600_data, filename="aia_1600.sav"

    ;fls = file_search(aia_path + '*1700A*.fits')
    ;READ_SDO, fls, aia_1700_index, aia_1700_data, nodata=0
    ;save, aia_1700_data, filename="aia_1700.sav"

end

;;  Shift data cube according to header information (may not have to do this)

;if keyword_set(nodata) then return
;for i = 0, z-1 do begin
;    data[*,*,i] = shift( data[*,*,i], round(index[0].xcen), round(index[0].ycen), 0 )
;endfor

path = '/solarstorm/laurel07/Data/AIA/*1700A*.fits'
fls = (file_search(path))[0]
READ_SDO, fls, aiaindex, aiadata2, nodata=0
STOP

;; Path to HMI data fits files
path = '/solarstorm/laurel07/Data/HMI/*.fits'
fls = (file_search(path))[0]
READ_SDO, fls, hmiindex, hmidata, nodata=0

path = '/solarstorm/laurel07/Data/AIA/*1600A*.fits'
fls = (file_search(path))[0]
READ_SDO, fls, aiaindex, aiadata, nodata=0


    


;; This line would still be needed... (25 Oct. 2017)
;hmi_rotate, hmi_data
;save, hmi_data[]  ... see align.pro for coordinates

end
