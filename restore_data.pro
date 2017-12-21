;; Last modified:   04 October 2017 23:18:53

;+
; ROUTINE:      main.pro
;
; PURPOSE:      Reads fits headers and restores data from .sav files.
;               Creates arrays of total flux, and calls routine for power spectrum images,
;                   using time information from the headers for "during" and "all".
;
; USEAGE:       @main.pro
;
; INPUT:        N/A
;
; KEYWORDs:     N/A
;
; OUTPUT:       N/A
;
; TO DO:        Re-write this as a function, to be called for desired data.
;
; AUTHOR:       Laurel Farris
;
;KNOWN BUGS:
;-




pro RESTORE_HMI, index, cube2

    path = '/solarstorm/laurel07/Data/HMI/*hmi*.fits'
    files = '../Sav_files/hmi_aligned.sav'

    ; Read headers
    fls = file_search(path)
    READ_SDO, fls[ 22:* ], index, data, /nodata

    ; Restore data
    restore, files

    ; Crop images
    ;x1 = 200
    ;x2 = 700
    ;y1 = 200
    ;y2 = 530

    ; Crop images a different way (04 Oct 2017)
    arcsec = 200.
    r = (arcsec/index[0].cdelt1)/2
    x = 438
    y = 345
    cube2 = cube[ x-r:x+r-1, y-r:y+r-1, * ]


end


pro RESTORE_AIA, index, cube2, wave=wave

    if ( wave eq 1600 ) then begin
        path = '/solarstorm/laurel07/Data/AIA/*aia*1600*.fits'
        files = '../Sav_files/aia_1600_aligned.sav'

        ; (Removing first file because AIA 1700 starts ~12 seconds later)
        ; ... But the cadence is 24 seconds... ? 28 Sep 2017
        fls = ( file_search(path) )[1:*]
        i = 1

    endif $
    else if ( wave eq 1700 ) then begin
        path = '/solarstorm/laurel07/Data/AIA/*aia*1700*.fits'
        files = '../Sav_files/aia_1700_aligned.sav'
        fls = file_search(path)
        i = 0
    endif else begin
        print, "No wave specified."
        return
    endelse


    ; Read headers
    READ_SDO, fls[67:*], index, data, /nodata

    ; Restore data in variable called 'cube'
    restore, files
    cube = cube[*,*,i:*]


    ; Crop aia cube, relative to 800x800
    ;x1 = 115
    ;x2 = 615
    ;y1 = 245
    ;y2 = 575
    ;cube2 = cube[ x1:x2-1, y1:y2-1, 67:* ]

    ; Crop images a different way (04 Oct 2017)
    arcsec = 200.
    r = (arcsec/index[0].cdelt1)/2
    x = 365
    y = 440
    cube2 = cube[ x-r:x+r-1, y-r:y+r-1, 67:* ]

end



RESTORE_HMI, hmi_index, hmi_data
RESTORE_AIA, aia_1600_index, aia_1600_data, wave=1600
RESTORE_AIA, aia_1700_index, aia_1700_data, wave=1700


end
