;+
;- 25 January 2021
;-
;- TO DO:
;-
;-  [] <task>
;-    --> INCOMPLETE
;-
;-  [] prep HMI data with aia_prep (hmi_prep??).
;-    use separate directories for each flare, see if it's better than all data in same dir.
;-    --> INCOMPLETE
;-
;-  []  ALIGN data
;-    --> INCOMPLETE
;-
;-  []  Power maps
;-    --> INCOMPLETE
;-
;- [] copy today.pro to some Module generalized for running alingment
;-    on any group of level 1.5 fits files (or level 1.0, shouldn't matter)
;-    --> INCOMPLETE
;-
;===================================================================================
;- "tomorrow.pro" :
;-
;- 14 May 2020
;-
;-
;- [] Prep for new science by commenting and outlining potential codes,
;-      new analysis methods, re-structure old methods (not just the science
;-      part, but also improve genearality of subroutines (can use for any flare),
;-      sort stand-alone bits into (or out of) subroutines, depending on
;-      computational efficiency, memory useage, and most importantly,
;-     ease with which poor simple-minded user (me) is able to ascertain the
;-     purpose, input/output, calling syntax, etc. VERY quickly and can use
;-     it immediately after a long hiatus, preferably with no errors due to
;-     use of variable names/types or filenames that have since been changed,
;-     calls to routines that don't even exist anymore or were absorbed into
;-     another file, kws/args added or taken away, pros changed to funcs or
;-     vice versa... always something.
;-     -
;-     -
;-
;-  What TYPE of results do I want to show for next research article?
;-  Depends on what I'm trying to accomplish, or what science questions
;-  I want to answer. So sort that out, THEN decide what figures to make at first.
;-  Answer the following questions (maybe a writing prompt or two?):
;-    • How will the science Qs posed in this study (and thesis in general)
;-      be answered by the values derived, relationships revealed in plots,
;-      or patterns displayed over images?
;-    •
;-    •
;-
;- TO DO:
;-  [] see @Lit for tons of ideas
;-  [] Enote with collection of figure screenshots from variety of @Lit:
;-     can be relevant to my research/methods or just nice graphics.
;-  [] Codes/ATT/, other Figure ideas written in Enote, Greenie, wherever,
;-     then generate as MANY as possible with sense of urgency.
;-     GOAL is to have ugly-ass graphics plagued by IDL's horrendous defaults,
;-       ~ podcast about forcing yourself NOT to run farther than the edge
;-          of your lawn if you're one of those all-or-nothing perfectionists.
;-
;===================================================================================



;+
;- Naming convention of fits files for, e.g. AIA 1600\AA{}
;
;
;    AIA
;      UNprepped fits (level 1.0):
;        'aia.lev1.1600A_2013-12-28T10_00_00.00Z.image_lev1.fits'
;        'aia.lev1.304A_2013-12-28T10_00_00.00Z.image_lev1.fits'
;
;      PREPPED fits (level 1.5):
;        'AIA20131228_100000_1600.fits'
;        'AIA20131228_100000_0304.fits'
;
;
;    HMI
;      UNprepped (level 1.0):
;        'hmi.ic_45s.yyyy.mm.dd_hh_mm_ss_TAI.continuum.fits'
;        'hmi.m_720s.yyyy.mm.dd_hh_mm_ss_TAI.magnetogram.fits'
;        'hmi.m_45s.yyyy.mm.dd_hh_mm_ss_TAI.magnetogram.fits'
;        'hmi.v_45s.yyyy.mm.dd_hh_mm_ss_TAI.Dopplergram.fits'
;
;      PREPPED fits (level 1.5)
;        'HMIyyyymmdd_hhmmss_cont.fits'
;        'HMIyyyymmdd_hhmmss_*?*.fits'
;        'HMIyyyymmdd_hhmmss_mag.fits'
;        'HMIyyyymmdd_hhmmss_dop.fits'
;
;
;---
;-



;+
;- Alignment -- broken down into detailed steps:
;-   • read level 1.5 (PREPPED) fits : index + data
;-   • crop to subset centered on AR
;-   • save to .sav file? If read_sdo takes forever...
;-   • align to center image
;-   • Def. save aligned data cube...


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
;-

;-
;maxmin, variable

;--------


buffer = 1

instr = 'aia'
channel = 1600
;channel = 1700

flare_index = 0  ; M1.5
;flare_index = 1  ; C8.3
;flare_index = 2  ; C4.6
;flare_index = 3  ; M1.0

;--------


@par2
;- defines structure of structures:
;;-   IDL>   multiflare = { m15:m15, c83:c83, c46:c46, m10:m10 }
;help, multiflare

flare = multiflare.(flare_index)
date = flare.year + flare.month + flare.day

;- 'AIAyyyymmdd_hhmmss_wave.fits'

path = '/solarstorm/laurel07/Data/' + strupcase(instr) + '_prepped/'
fnames = strupcase(instr) + date + '*' + strtrim(channel,1) + '.fits'

fls = FILE_SEARCH( path + fnames )

help, fls

;start_time = systime()
;for ii = 0, n_elements(index)-1 do begin
;    ind = [ii:ii+increment-1]
;    READ_SDO, fls[ind], index, data
;endfor


stop;---------------------------------------------------------------------------------------------



;!CPU

;for ii = 50, 745, 50 do begin
;    ind = [ ii-50 : ii-1 ]
;    print,  ii-50, ii-1
;endfor
;ind = [ 0 : n_elements(fls)-1 : 1 ]
;help, ind
;print, ind[0:4]
;print, ind[-5 : -1]
;while ii = 0,  do


;-----------------------------------------------
;- START HERE ----------------------------------
;-----------------------------------------------


dimensions = [800,800]
READ_SDO, fls, index, data, /nodata
spatial_scale = index[0].cdelt1
exptime = index[0].exptime
;print, array_equal( index.exptime, index[0].exptime )
;print, index[0].pixlunit
;
;half_dimensions = [ index[0].crpix1, index[0].crpix2 ]
;center =  half_dimensions + ([flare.xcen, flare.ycen]/spatial_scale)
full_dimensions = [ index[0].naxis1, index[0].naxis2 ]
center = FIX( (full_dimensions/2) + ([flare.xcen, flare.ycen]/spatial_scale) )
;-  "full_dimensions" avoids fractional pixel coords, if it matters...
;print, 'center coords = ',  center, ' (pixels)'

;ind = indgen(7)*100

cube = []

stop;---------------------------------------------------------------------------------------------


;for ii = 0, n_elements(fls), 100 do begin
;    if ii+100-1 GE n_elements(fls) then begin
;        ind = [ii:n_elements(fls)-1]
;    endif else begin
;        ind = [ii:ii+100-1]
;    endelse
;    READ_SDO, fls[ind], index, data
;    cube = [ [[ cube ]], $
;        [[ CROP_DATA( data, dimensions=dimensions, center=center ) ]] ]
;    help, cube
;    undefine, index
;    undefine, data
;endfor

;cube = fltarr( dimensions[0], dimensions[1], n_elements(fls) )

start_time = systime()
;
for ii = 0, n_elements(fls)-1 do begin
    READ_SDO, fls[ii], index, data
    cube = [ [[ cube ]], $
        [[ CROP_DATA( data, dimensions=dimensions, center=center ) ]] ]
    ;cube[*,*,ii] = CROP_DATA( data, dimensions=dimensions, center=center )
    ;help, cube
    undefine, index
    undefine, data
endfor
;
print, "Started at ", start_time
print, "Finished at ",  systime()

stop;---------------------------------------------------------------------------------------------

READ_SDO, fls, index, data, /nodata
help, index
;- [] check that n_elements(index) matches sz[2] of cube.
;
;help, flare
;savefile = 'm15_' + instr + strtrim(channel,1) + 'cube.sav'
savefile = date + '_' + instr + strtrim(channel,1) + 'cube.sav'
print, savefile
;

SAVE, index, cube, filename=savefile



end
