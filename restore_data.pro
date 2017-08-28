;; Last modified:   18 August 2017 10:17:08

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
; TO DO:        
;
; AUTHOR:       Laurel Farris
;
;KNOWN BUGS:
;-



@main

;; HMI --------------------------------------------------------------------------------------------

; Read hmi fits headers
fls = file_search(hmi_path)
read_sdo, fls[22:*], hmi_index, data, /nodata

; Restore hmi data
restore, 'Sav_files/hmi_aligned.sav'

;; Crop hmi images, relative to 800x800
x1 = 200
;x2 = 650
x2 = 700
y1 = 200
;y2 = 500
y2 = 530
hmi = cube[ x1:x2-1, y1:y2-1, * ]


;; AIA 1600 ---------------------------------------------------------------------------------------

; Read aia 1600 fits headers
;   (Removing first file because AIA 1700 starts ~12 seconds later)
fls = ( file_search(aia_1600_path) )[1:*]
read_sdo, fls[67:*], aia_1600_index, data, /nodata

; Restore AIA 1600 data
restore, 'Sav_files/aia_1600_aligned.sav'
cube = cube[*,*,1:*]

;; Crop aia images, relative to 800x800
x1 = 115
x2 = 615
y1 = 245
y2 = 575
a6 = cube[ x1:x2-1, y1:y2-1, 67:* ]


;; AIA 1700 ---------------------------------------------------------------------------------------

; Read AIA 1700 fits headers
fls = file_search(aia_1700_path)
read_sdo, fls[67:*], aia_1700_index, data, /nodata

; Restore AIA 1700 data
restore, 'Sav_files/aia_1700_aligned.sav'

;; Crop aia images, relative to 800x800
a7 = cube[ x1:x2-1, y1:y2-1, 67:* ]


end
