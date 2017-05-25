;; Last modified:  22 May 2017 16:41:25
;; Filename:       read_my_fits.pro
;; Programmer:     Laurel Farris



; Description:      Read/restore data and headers, and create array of structures,
;                       one for each bandpass, with coronal hole data (1000x1000)

; Note: Written to correct for shifts using header info,
;   since corrections were not made before aligning.
; Need to redo all data to correct from the beginning.

; Tested that xcen and ycen were the same for each image in a given wavelength by using
; IDL's ARRAY_EQUAL routine.

; get_data = 0 --> Restore data from .sav files
; get_data = 1 --> Read in data from fits files (takes a long time)


function READ_MY_FITS, path, z=z


    fls = (file_search(path))
    if not keyword_set(z) then z = n_elements(fls) else fls = fls[0:z-1]

    READ_SDO, fls, index, data

    for i = 0, z-1 do begin

        ;; Shift cube according to header information (may not have to do this)
        data[*,*,i] = shift( data[*,*,i], round(index[0].xcen), round(index[0].ycen), 0 )

    endfor

    return, data

end
