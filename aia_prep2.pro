;; Last modified:   31 May 2018 17:45:33


;; HMI ---------------------------------------------------------

;; Run aia_prep.pro and save fits files
;prep_hmi, 'Dopplergram'
;prep_hmi, 'magnetogram'
;prep_hmi, 'continuum'

; Run aia_prep.pro on HMI data and save new fits files.
; aia_prep and reading fits files are two different things...
; and need to be in two different routines (may call each other).

files = '*_45s*' + channel + '*.fits'
fls = file_search( path + files )

;if n_elements(ind) eq 0 then ind = [0:n_elements(fls)-1]
if n_elements(ind) ne 0 then fls = fls[ind]

outdir = '/solarstorm/laurel07/Data/HMI_prepped/'
;AIA_PREP, fls, ind, /do_write_fits, outdir=outdir
AIA_PREP, fls, -1, /do_write_fits, outdir=outdir
return
end


;; Need to align and save cropped data to prevent reading in full
;; data cubes, which takes forever. 
;hmi = read_hmi( 'continuum' )
;hmi = read_hmi( 'magnetogram' )
;hmi = read_hmi( 'Dopplergram' )

; Crop HMI data
; center coords of MIDDLE of full time series (z=374)
;x0 = 2420-35
;y0 = 1665

; center coords relative to FULL DISK
; for image in center of time series? or beginning? and for which data?
end
