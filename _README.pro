;+
; ROUTINE:
;   _README.pro
;
; LAST MODIFIED:
;   13 July 2022
;
; PURPOSE:
;   This is primarily for use as a reference:
;   It describes each step in the data analysis,
;   provides syntax for all user-defined subroutines,
;   and describes variable specs at each step (type, size, etc.)
;
;   Run this as a script to execute all routines to
;   PREP data for analysis.
;
; USEAGE:
;   IDL> @main.pro
;
; AUTHOR:
;   Laurel Farris
;
; TO DO:
;   [] Update this file
;
;-

;--------------------------------------------------------------------------------------------
;- Merged this file (_README.pro) with text file "README" (below)
;
; 01 September 2021
;  ==>> no longer commenting with ';-' ... just using ';' like a normal person.
;   Too tedious and too many typos constantly reaching for the '-' key and more often
;   than not, hitting the wrong key. If comment symbol would automatically appear
;   like every other filetype this wouldn't be a problem, but for some reason, doesn't
;   work with IDL the way it does with latex and normal .sh files
;
;
; 07 Janurary 2021
;  m10_aligned.sav --> 2014-11-07 ; AR 12205
;    • cube = INT Array [ 800, 600, 750 ]
;    • ref  = INT Array [ 800, 600 ]
;    • allshifts = FLOAT Array [ 2, 750, 9 ]
;
;
;  03 August 2020
;   IDEA : Put my "modules" in main "work" directory (alias='work' from @solarstorm)
;        at least the ones I'm actively using for whatever Figure(s) I'm creating
;        for the current "Project of the week".
;
;     •  Sub-directories all contain various types of computations/figures/SCIENCE,
;        some of which are ML routines, some are subroutines,
;        many of them call one or several of the others,
;        These directories are good places to preserve ALL versions of similar codes,
;        test codes, well-established subroutines that I don't need to look at very often
;        (there aren't many of these, unfortunately),
;        as many different variations and experiments as I neeed to spit out
;        until I uncover the approach that works best for given application.
;        Then move "the better way" up one level to the main work dir.
;        Can alos have lots of graphic-creating code here.
;
;     •  Main WORK dir. can then be kept relatively clutter-free, and
;        only need to work with codes that are right there, rather than
;        constantly jumping back and forth between all the sub-directories
;        nested here.
;
;--------------------------------------------------------------------------------------------


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

;; GET_LABELS
   ; result = GET_LABELS( array, n )
   ; short subroutine that returns array of length n+1,
   ; where n+1 = number of labels you want to show on plot.

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

; ft.pro - user's structure with all useful values


; Filenames of current data (examples)
;  aia.lev1.131A_2012-06-01T01_00_09.62Z.image_lev1.fits
;  hmi.ic_45s.2011.02.15_00_01_30_TAI.continuum.fits


;---------------------------------------------------------------------------------------------
; Variables needed to prep data
;   see also ./Prep/apply_aia_prep.pro and similar routines -- 13 July 2022

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
; aia_1600_misaligned.sav --> cube [ 800  800 750]
; aia_1700_misaligned.sav --> cube [ 800  800 745]

;; aligned using different area of sun
; aia_1600_aligned.sav    --> cube [1000 1000 750]
; aia_1700_aligned.sav    --> cube [1000 1000 745]

; VAR = hmi_data       -->  500 x 330 x ???   aligned and trimmed
; VAR = aia_1600_data  -->  500 x 330 x ???   aligned and trimmed
; VAR = aia_1700_data  -->  500 x 330 x 678   aligned and trimmed

; VAR = aia_1600_data  -->  327 x 327 x ???   aligned and trimmed, 200" x 200"
; VAR = aia_1700_data  -->  327 x 327 x 678   aligned and trimmed, 200" x 200"


;---------------------------------------------------------------------------------------------
;; Power maps

; ../aia*map.sav
; VAR = map  -->  500 x 330 x 137
;     NORM=0, TOTAL(power), z_start increments by 5


; ../aia*map2.sav
; VAR = map2  -->  500 x 330 x 685
;      /NORM,  MEAN(power),  z_start increments by 1


;---------------------------------------------------------------------------------------------
;; Interpolate to get missing data. Use coords to manually generate the
;;   missing observation times.

LINEAR_INTERP, array=a7data, jd=a7jd, cadence=24

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


;---------------------------------------------------------------------------------------------



;- 17 December 2018
;-   Reason for not making directories for Imaging and Plotting
;-   in addition to directories for Maps, Spectra, etc.
;-   -> I have a routine called image_powermaps... where would that go?
;-   Some generalized routines for plotting and imaging are great, but
;-   they would probably just go in Graphics/.

;- 02 November 2018
;- plot3.pro, image3.pro are general routines for displaying
;- multiple panels in one graphic and/or something relatively simple
;- I can call so I don't have to keep writing the same lines of code
;- over and over (creating window, setting up margins, etc.)
;-
;- 18 October 2018
;- Directory "Old" contains old versions of codes that I'll probably
;-      never need again, but they may be worth looking at in case I
;-      had some brilliant ideas that I forgot about.
;-


;- To Do:
;-  * One file for my own colors (used when overplotting), maybe with letters.
;-  *
;-  *
;-  *
;-  *


;---------------------------------------------------------------------------------------------
; 27 December 2023

;Code backups on new lappy, copied 28 March 2022 (based on ls timestamps), located in:
;    ~/Backups/codes_backup/

end
