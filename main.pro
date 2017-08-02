;; Last modified:   18 July 2017 11:01:20

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
hmi_path = '/solarstorm/laurel07/Data/HMI/'
aia_path = '/solarstorm/laurel07/Data/AIA/'



;---------------------------------------------------------------------------------------------
;; (2) Restore aligned HMI data

; restore, "hmi_aligned.sav"
; VAR = cube -->  800 x 800 x 360   aligned and trimmed


;; (3) Interpolate to get missing data

; Get coordinates of missing data
; ?

; IDL> .run linear_interp
; VAR = cube2 --> 800 x 800 x 364  alined, trimmed, interpolated



;; (4) Fourier analysis

;result = fourier2( array, delt, rad=rad, pad=pad, norm=norm, signif=signif, display=display )
; frequency = result[0,*]
; power_spectrum = result[1,*]
; phase = result[2,*]
; amplitude = result[3,*]
