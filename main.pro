;; Last modified:   18 August 2017 12:01:31

;+
; ROUTINE:      main.pro
;
; PURPOSE:      Describe steps in project
;               Run as script for common variables
;               Syntax for all user-defined subroutines (and some others)
;               Explanation of variables restored from .sav files
;
; USEAGE:       @main.pro
;
; INPUT:        N/A
;
; KEYWORDs:     N/A
;
; OUTPUT:       N/A
;
; TO DO:        Can't find subroutine that produced coordinates of missing hmi data,
;                   but numbers are saved in linear_interp.pro
;
; AUTHOR:       Laurel Farris
;
;KNOWN BUGS:
;-


;; Calling sequence for subroutines:

;;  read_my_fits, index, data, path=path, z1=z1, z2=z2, nodata=nodata

;;  align, data_cube

;;  result = linear_interp( old_array, indices )
;;      for HMI[800,800,360]  IDL> .run linear_interp

;;  hmi_rotate, cube

;;  radius( arr, x0=x0, y0=y0 )

;;  fourier2( Flux, Delt, rad=rad, pad=pad, norm=norm, signif=signif, display=display )

;;  @graphic_configs ... will have to add/change properties specific to each graphic.

;;  save_figs, "filename"

;;  xstepper, cube, info, xsize=512, ysize=512   (not user-written)


;---------------------------------------------------------------------------------------------
;; (1) Read fits files

;; Filenames of current data (examples)
;  aia.lev1.131A_2012-06-01T01_00_09.62Z.image_lev1.fits
;  hmi.ic_45s.2011.02.15_00_01_30_TAI.continuum.fits

;; Paths to data
hmi_path = '/solarstorm/laurel07/Data/HMI/*hmi*.fits'
aia_1600_path = '/solarstorm/laurel07/Data/AIA/*aia*1600*.fits'
aia_1700_path = '/solarstorm/laurel07/Data/AIA/*aia*1700*.fits'

;; Cadence
hmi_cad = 45.0
aia_cad = 24.0

fontname = "Helvetica"
fontsize = 9

;---------------------------------------------------------------------------------------------
;; (2) Restore aligned HMI data

;; restore, "Sav_files/hmi_aligned.sav"
; IDL> .run restore_data
; VAR = ?

;; (3) Interpolate to get missing data

; Get coordinates of missing data (linear_interp.pro does this)

; IDL> .run linear_interp
; VAR = hmi -->  500 x 330 x 364   aligned, trimmed, and interpolated
; VAR = a6  -->  500 x 330 x 682   aligned, trimmed, and interpolated
; VAR = a7  -->  500 x 330 x 682   aligned, trimmed, and interpolated



;; (4) Fourier analysis

;result = fourier2( array, delt, rad=rad, pad=pad, norm=norm, signif=signif, display=display )
; frequency = result[0,*]
; power_spectrum = result[1,*]
; phase = result[2,*]
; amplitude = result[3,*]
