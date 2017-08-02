;; Last modified:   21 July 2017 10:28:10

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


pro FLARE_CHUNKS, index, cube_all, delt, $
    cube_during, flux_all, flux_during, ps_all, ps_during

    ;; find coordinates of images during flare
    times = strmid(index.date_obs, 11, 5)
    t1 = (where( times eq '01:20' ))[0]
    t2 = (where( times eq '03:10' ))[-1]

    cube_during = cube_all[*,*,t1:t2]

    sz = size(cube_all, /dimensions)

    ;; Flux
    flux_all = []
    for i = 0, sz[2]-1 do begin
        flux_all = [flux_all, total(cube_all[*,*,i]) ]
    endfor

    flux_during = []
    for i = t1, t2  do begin
        flux_during = [flux_during, total(cube_all[*,*,i]) ]
    endfor

    ;; Power spectrum images
    ps_all = FA_2D( cube_all, delt )
    ps_during = FA_2D( cube_during, delt )

end

GOTO, START


;; AIA

aia_path = '/solarstorm/laurel07/Data/AIA/'
aia_delt = 24.

; 1600
fls = file_search(aia_path + "*aia*1600*.fits")
read_sdo, fls, aia_1600_index, aia_1600_data, /nodata
restore, 'aia_1600_aligned.sav'  ;; VAR = cube
aia_1600_cube_all = cube[115:615, 245:575, *]

FLARE_CHUNKS, aia_1600_index, aia_1600_cube_all, aia_delt, $
    aia_1600_cube_during, aia_1600_flux_all, aia_1600_flux_during

; 1700
fls = file_search(aia_path + "*aia*1700*.fits")
read_sdo, fls, aia_1700_index, aia_1700_data, /nodata
restore, 'aia_1700_aligned.sav'  ;; VAR = cube
aia_1700_cube_all = cube[115:615, 245:575, *]

FLARE_CHUNKS, aia_1700_index, aia_1700_cube_all, aia_delt, $
    aia_1700_cube_during, aia_1700_flux_all, aia_1700_flux_during

START:
aia_1700_ps_all = FA_2D( aia_1700_cube_all, aia_delt )
aia_1700_ps_during = FA_2D( aia_1700_cube_during, aia_delt )
STOP



;; HMI

hmi_path = '/solarstorm/laurel07/Data/HMI/'
fls = file_search(hmi_path + "*hmi*.fits")
read_sdo, fls, hmi_index, hmi_data, /nodata
restore, 'hmi_aligned.sav'

interp_coords = [215, 246, 277, 324] - 22
cube2 = linear_interp( cube, [interp_coords] )

hmi_cube_all = cube2[200:650, 200:500, *]

hmi_delt = 45.

FLARE_CHUNKS, hmi_index, hmi_cube_all, hmi_delt, $
    hmi_cube_during, hmi_flux_all, hmi_flux_during


end
