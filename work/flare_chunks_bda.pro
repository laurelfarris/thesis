;; Last modified:   21 July 2017 12:37:13

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


pro FLARE_CHUNKS, index, cube, delt, $
    flux_all, flux_before, flux_during, flux_after, $
    ps_before, ps_during, ps_after

    ;; find coordinates of images during flare
    times = strmid(index.date_obs, 11, 5)
    t1 = (where( times eq '01:20' ))[0]
    t2 = (where( times eq '03:10' ))[-1]

    
    cube_before = cube[*,*,0:t1]
    cube_during = cube[*,*,t1:t2]
    cube_after = cube[*,*,t2:*]

    sz = size(cube, /dimensions)

    ;; Flux

    flux_before = []
    for i = 0, t1-1 do begin
        flux_before = [flux_before, total(cube[*,*,i]) ]
    endfor

    flux_during = []
    for i = t1, t2  do begin
        flux_during = [flux_during, total(cube[*,*,i]) ]
    endfor

    flux_after = []
    for i = t2+1, sz[2]-1  do begin
        flux_after = [flux_after, total(cube[*,*,i]) ]
    endfor

    flux_all = [flux_before,flux_during,flux_after]


    ;; Power spectrum images
    ps_before = FA_2D( cube_before, delt )
    ps_during = FA_2D( cube_during, delt )
    ps_after = FA_2D( cube_after, delt )

end



;; AIA

aia_path = '/solarstorm/laurel07/Data/AIA/'
aia_delt = 24.

; 1600
fls = file_search(aia_path + "*aia*1600*.fits")
read_sdo, fls, aia_1600_index, aia_1600_data, /nodata
restore, 'aia_1600_aligned.sav'  ;; VAR = cube
aia_1600_cube_all = cube[115:615, 245:575, *]

FLARE_CHUNKS, aia_1600_index, aia_1600_cube_all, aia_delt, $
    aia_1600_flux_all, aia_1600_flux_before, aia_1600_flux_during, aia_1600_flux_after, $
    aia_1600_ps_before, aia_1600_ps_during, aia_1600_ps_after


; 1700
fls = file_search(aia_path + "*aia*1700*.fits")
read_sdo, fls, aia_1700_index, aia_1700_data, /nodata
restore, 'aia_1700_aligned.sav'  ;; VAR = cube
aia_1700_cube_all = cube[115:615, 245:575, *]

FLARE_CHUNKS, aia_1700_index, aia_1700_cube_all, aia_delt, $
    aia_1700_flux_all, aia_1700_flux_before, aia_1700_flux_during, aia_1700_flux_after, $
    aia_1700_ps_before, aia_1700_ps_during, aia_1700_ps_after



;; HMI

hmi_path = '/solarstorm/laurel07/Data/HMI/'
fls = file_search(hmi_path + "*hmi*.fits")
read_sdo, fls, hmi_index, hmi_data, /nodata
restore, 'hmi_aligned.sav'

interp_coords = [215, 246, 277, 324] - 22
cube2 = linear_interp( cube, [interp_coords] )

hmi_cube_all = cube2[200:650, 200:500, *]

hmi_delt = 45.

FLARE_CHUNKS, hmi_index, hmi_cube_all, aia_delt, $
    hmi_flux_all, hmi_flux_before, hmi_flux_during, hmi_flux_after, $
    hmi_ps_before, hmi_ps_during, hmi_ps_after


end
