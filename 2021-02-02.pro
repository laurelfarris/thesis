;+
;- 02 February 2021 (Tuesday)
;-   Part 2: align only. Remove clutter code.
;-


;===
;==========================================================================
;=
;= FIRST : Naming convention of fits files for, e.g. AIA 1600\AA{}
;=  (tired of looking this up all the time...)
;=
;=
;=    AIA
;=      UNprepped fits (level 1.0):
;=        'aia.lev1.1600A_2013-12-28T10_00_00.00Z.image_lev1.fits'
;=        'aia.lev1.304A_2013-12-28T10_00_00.00Z.image_lev1.fits'
;=
;=      PREPPED fits (level 1.5):
;=        'AIA20131228_100000_1600.fits'
;=        'AIA20131228_100000_0304.fits'
;=
;=
;=    HMI
;=      UNprepped (level 1.0):
;=        'hmi.ic_45s.yyyy.mm.dd_hh_mm_ss_TAI.continuum.fits'
;=        'hmi.m_720s.yyyy.mm.dd_hh_mm_ss_TAI.magnetogram.fits'
;=        'hmi.m_45s.yyyy.mm.dd_hh_mm_ss_TAI.magnetogram.fits'
;=        'hmi.v_45s.yyyy.mm.dd_hh_mm_ss_TAI.Dopplergram.fits'
;=
;=      PREPPED fits (level 1.5)
;=        'HMIyyyymmdd_hhmmss_cont.fits'
;=        'HMIyyyymmdd_hhmmss_*?*.fits'
;=        'HMIyyyymmdd_hhmmss_mag.fits'
;=        'HMIyyyymmdd_hhmmss_dop.fits'
;=
;=
;==========================================================================
;===


;+
;- TO DO:
;-
;-  []  Find coords of 20141023 flare, save cube and index to .sav files:
;-            20141023_aia1600cube.sav
;-            20141023_aia1700cube.sav
;-    --> INCOMPLETE
;-
;-  []  ALIGN data
;-    --> INCOMPLETE
;-
;-  []  Image HMI alongside concurrent AIA obs; check relative AR position.
;-    --> INCOMPLETE
;-          Read HMI level 1.5 fits
;-           Image full disk, 6 panels like yesterday
;-              scale continuum and/or mag ... otherwise, just get white, washed out disk...
;-           Eyeball center coords of AR
;-           Extract subset with same center and dimensions as AIA, e.g. --> "M10_hmi_mag_cube.sav"
;-
;- [] copy today.pro to some Module generalized for running alignment
;-    on any group of level 1.5 fits files (or level 1.0, shouldn't matter)
;-    --> INCOMPLETE
;-


;+
;- Alignment -- broken down into detailed steps:
;-   • read level 1.5 (PREPPED) fits : index + data
;-   • crop to subset centered on AR
;-   • padded CUBE + INDEX -> fileame.sav
;-       (read_sdo takes too long and bogs system down to where nothing gets done
;-   • align cube to reference image (center of time series)
;-   • aligned_cube + INDEX -> filename2.sav
;-       index still the same, only data has changed...
;-


;+
;- Current collection in multiflare project:
;-   • C8.3 2013-08-30 T~02:04:00  (1)
;-   • M1.0 2014-11-07 T~10:13:00  (3)
;-   • M1.5 2013-08-12 T~10:21:00  (0)
;-   • C4.6 2014-10-23 T~13:20:00  (2)
;-  multiflare.(N) --> structure of structures
;-    current index order is as listed to the right of each flare
;-    (chronological order).
;-
;flare_index = 0  ; M1.5
flare_index = 1  ; C8.3
;flare_index = 2  ; C4.6 ==>> No center coords (xcen,ycen)!!
;flare_index = 3  ; M1.0
;-


buffer = 1

instr = 'aia'
;channel = 1600
channel = 1700

;

@par2
;- multiflare = { m15:m15, c83:c83, c46:c46, m10:m10 }
;help, multiflare
flare = multiflare.(flare_index)

date = flare.year + flare.month + flare.day
path = '/solarstorm/laurel07/flares/' + date + '/'
print, path



;+
;========================================================================================
;== Alignment
;-

filename = date + '_' + strlowcase(instr) + strtrim(channel,1) + 'cube.sav'
print, filename
restore, path + filename


stop


sz = size(cube, /dimensions)
ref = cube[*,*,sz[2]/2]
help, ref


display = 0 ;- need to refresh on what PLOT_SHIFTS does before using this.
;
resolve_routine, 'align_loop', /either
ALIGN_LOOP, cube, ref, allshifts=allshifts, display=display, buffer=buffer

fname = strsplit( flare.class, '.', /extract )
savfile = fname[0] + fname[1] + '_' +  $
    strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
print, savfile


SAVE, cube, ref, allshifts, filename=savfile
;-  [] include INDEX in saved variables?


;- REMEMBER : cube is MODIFIED when returned to caller! May want to make a
;-  second variable to duplicate the original, especially if full-disk data
;-  is undefined to free up memory. Otherwise, will have to start over with
;-  READ_SDO, crop data, blah blah blah.


end
