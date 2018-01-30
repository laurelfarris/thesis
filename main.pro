;; Last modified:   29 January 2018 19:39:39

;+
; ROUTINE:      Main.pro
;
; PURPOSE:      This is primarily for use as a reference:
;               It describes each step in the data analysis,
;               provides syntax for all user-defined subroutines,
;               and describes variable specs at each step (type, size, etc.)
;
;               Run this as a script to execute all routines to
;                PREP data for analysis.
;
; USEAGE:       IDL> @main.pro
;
; AUTHOR:       Laurel Farris
;
; TO DO:        read_my_fits.pro needs some work
;
;-


;; Calling sequence for subroutines:

;; Interpolate
;  IDL> result = linear_interp( old_array, header, cadence )

;; Fourier analysis
;  IDL> result = fourier2( $
;    Flux, Delt, rad=rad, pad=pad, norm=norm, signif=signif, display=display )
; frequency      = result[0,*]
; power_spectrum = result[1,*]
; phase          = result[2,*]
; amplitude      = result[3,*]

;; Read fits files
;  IDL> read_my_fits, index, data, path=path, z1=z1, z2=z2, nodata=nodata

;; Align data
;  align, data_cube

;  hmi_rotate, cube

;  radius( arr, x0=x0, y0=y0 )

;  @graphic_configs ... will have to add/change properties specific to each graphic.

;  save_figs, "filename"

;  xstepper, cube,
;     info - string array, shows up instead of index num, and at bottom of each image
;     xsize = 512, ysize = 512,
;     start = index of starting image
;     subscripts = subscripts


; Filenames of current data (examples)
;  aia.lev1.131A_2012-06-01T01_00_09.62Z.image_lev1.fits
;  hmi.ic_45s.2011.02.15_00_01_30_TAI.continuum.fits


;---------------------------------------------------------------------------------------------
;; Variables needed to prep data

; Paths to data
hmi_path = '/solarstorm/laurel07/Data/HMI/*hmi*.fits'
aia_1600_path = '/solarstorm/laurel07/Data/AIA/*aia*1600*.fits'
aia_1700_path = '/solarstorm/laurel07/Data/AIA/*aia*1700*.fits'
sav_path = '../Sav_files/'

; Cadence
hmi_cadence = 45.0
aia_cadence = 24.0


;---------------------------------------------------------------------------------------------
;; Restore data

; Run routine to RESTORE data
RESTORE_HMI, hmi_index, hmi_data
RESTORE_AIA, aia_1600_index, aia_1600_data, wave=1600
RESTORE_AIA, aia_1700_index, aia_1700_data, wave=1700
; VAR = hmi_data       -->  500 x 330 x ???   aligned and trimmed
; VAR = aia_1600_data  -->  500 x 330 x ???   aligned and trimmed
; VAR = aia_1700_data  -->  500 x 330 x ???   aligned and trimmed


;---------------------------------------------------------------------------------------------
;; Interpolate to get missing data. Use coords to manually generate the
;;   missing observation times.

LINEAR_INTERP, hmi_data, hmi_index, hmi_cadence, hmi_coords
LINEAR_INTERP, aia_1600_data, aia_1600_index, aia_cadence, a6_coords
LINEAR_INTERP, aia_1700_data, aia_1700_index, aia_cadence, a7_coords
; VAR = hmi -->  500 x 330 x 364   aligned, trimmed, and interpolated
; VAR = a6  -->  500 x 330 x 682   aligned, trimmed, and interpolated
; VAR = a7  -->  500 x 330 x 682   aligned, trimmed, and interpolated


;---------------------------------------------------------------------------------------------
;; Get flux to make lightcurves
hmi_flux      = total( total(hmi,1), 1 )
aia_1600_flux = total( total(a6, 1), 1 )
aia_1700_flux = total( total(a7, 1), 1 )


;---------------------------------------------------------------------------------------------
;; Get indices to separate data in Before, During, and After


; Flare start/end times from Milligan et al. 2017
flare_start = '01:30'
flare_end   = '02:30'




get_bda_indices, hmi_index, ht1, ht2
get_bda_indices, aia_1600_index, a6t1, a6t2
get_bda_indices, aia_1700_index, a7t1, a7t2



;---------------------------------------------------------------------------------------------
;.run plot_fft



end
