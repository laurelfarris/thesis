;+
;- 18 July 2022
;-   (most of previous stuff from 10 May 2022 was copied into notes dir.. a little late)
;-
;-
;- TO DO:
;-
;-   [] See previous "today.pro"'s in ./notes/; this version has been significantly cleaned up
;-        (i.e. deleted a lot of sh*t).
;-
;-   [] Codes in .Prep/ to merge, move to ./old/, and/or delete
;-       • Prep/check_my_fits.pro
;-       • Prep/prep_flare_data_cube.pro
;-       • All the struc's in ./Prep:
;-           • struc_data
;-           • struc_aia
;-           • struc_aia_20200720
;-           • struc_hmi

;-   [] Prep for new science by commenting and outlining potential codes,
;-      new analysis methods, re-structure old methods (not just the science
;-      part, but also improve genearality of subroutines (can use for any flare),
;-      sort stand-alone bits into (or out of) subroutines, depending on
;-      computational efficiency, memory useage, and most importantly,
;-      ease with which poor simple-minded user (me) is able to ascertain the
;-      purpose, input/output, calling syntax, etc. VERY quickly and can use
;-      it immediately after a long hiatus, preferably with no errors due to
;-      use of variable names/types or filenames that have since been changed,
;-      calls to routines that don't even exist anymore or were absorbed into
;-      another file, kws/args added or taken away, pros changed to funcs or
;-      vice versa... always something.

;-  What TYPE of results do I want to show for next research article?
;-  Depends on what I'm trying to accomplish, or what science questions
;-  I want to answer. So sort that out, THEN decide what figures to make at first.
;-  Answer the following questions (maybe a writing prompt or two?):
;-    • How will the science Qs posed in this study (and thesis in general)
;-      be answered by the values derived, relationships revealed in plots,
;-      or patterns displayed over images?
;-    •

;-  [] Enote with collection of figure screenshots from variety of @Lit:
;-     can be relevant to my research/methods or just nice graphics.
;-  [] Codes/ATT/, other Figure ideas written in Enote, Greenie, wherever,
;-     then generate as MANY as possible with sense of urgency.
;-     GOAL is to have ugly-ass graphics plagued by IDL's horrendous defaults,
;-       ~ podcast about forcing yourself NOT to run farther than the edge
;-          of your lawn if you're one of those all-or-nothing perfectionists.
;-

;-
;- TO DO (A2):
;-
;-   [] AIA & GOES  LCs during flare only, dt covered by RHESSI (for CORRECT flares)
;-   [] Detrended LCs showing QPPs
;-   [] Power maps (see "today.pro")
;-   [] FFTs -> power spectra showing power as function of freqeunciews between ~1 and 20 mHz (or w/e)
;-       to compare BDA for individual flares, or same phase for different flares in one plot
;-       (first one then the other... comparing flares to each other is followup / discussion section)


;+
;- 30 January 2021
;-
;-   IDEA for possibly making my life so much easier:
;-     Modify INDEX returned from READ_SDO instead of defining my own structures
;-     from scratch? Retain the few tags I need:
;-       • -> SAFER! No risk of entering incorrect numbers
;-           (like reversing the exptime for 1600 and 1700 ...)
;-       • Will save so much time w/o repeatedly looking up fits filename syntax,
;-         read_my_fits syntax, high CPU and memory useage to read large files,
;-         (even with /nodata set, still takes forever.)
;-
;-  [] Learn how to modify/update structures,  tho?
;-      Remove tags, add new tags,
;-      Combine multiple strucs into one master struc or array, 
;-      Syntax to access tags/values using tagnames OR index, eg "struc.(ii)"
;-      
;-
;-
;- A2 flares:
;-   C8.3 2013-08-30 T~02:04:00
;-   M7.3 2014-04-18 T~
;-   X2.2 2011-02-11 T~01:43:00

;- Need to rename variable saved in these files for C8.3 flare...
;restore, '../flares/c83_20130830/c83_aia1700header.sav'
;index = c83_aia1700header
;help, index
;save, index, filename='c83_aia1700header.sav'

;path='/home/astrobackup3/preupgradebackups/solarstorm/laurel07/'
;path='/solarstorm/laurel07/'
;testfiles = 'Data/HMI_prepped/*20140418*.fits'
;if not file_test(path + testfiles) then print, 'files not found'



; What .sav files currently exist for each flare?
; '../flares/c83_20140418/*.sav'
; c83_aia1600aligned.sav
; c83_aia1700aligned.sav
; c83_aia1600header.sav
; c83_aia1700header.sav

; '../flares/m73_20140418/*.sav'
; '../flares/x22_20140418/*.sav'


@main

; display current nesting of procedures and functions (found in shift_ydata.pro 09 Aug 2022)
help, /traceback


;=====================================================================================================
; compute POWERMAP from pre-flare data

z_start = ( where( strmid(A[0].time,0,5) eq flare.tstart ) );[0]
z_peak = ( where( strmid(A[0].time,0,5) eq flare.tpeak ) );[0]
z_end = ( where( strmid(A[0].time,0,5) eq flare.tend ) );[0]
;
z_imp = [ z_start[0] : z_peak[0] ]
z_decay = [ z_peak[-1] : z_peak[-1] + n_elements(z_imp)-1 ]

; X2.2 flare only, since time windows are so short
dz = 64
z_imp = [ z_peak[0]-dz+1 : z_peak[0] ]
z_decay = [ z_peak[-1] : z_peak[-1]+dz-1 ]


help, z_imp
help, z_decay


;map = COMPUTE_POWERMAPS( /syntax )


; Set saturation threshold (may be less than saturation value for a single pixel
;   to account for pixels contaminated by blooming (i.e. extra counts, but not sat.)
threshold = 15000.

data_mask = A.data lt threshold
help, data_mask

sz = size(A.data, /dimensions)
map = fltarr(sz[0],sz[1], 4 )

map_mask = fltarr(sz[0],sz[1], 4 )
help, map_mask


for cc = 0, 1 do begin
    map[*,*,cc] = COMPUTE_POWERMAPS( $
        A[cc].data[*,*,z_imp], cadence, bandwidth=0.001)
    map_mask[*,*,cc] = PRODUCT( data_mask[*,*,z_imp,cc], 3 )
endfor
;
for cc = 0, 1 do begin
    map[*,*,cc+2] = COMPUTE_POWERMAPS( $
        A[cc].data[*,*,z_decay], cadence, bandwidth=0.001 )
    map_mask[*,*,cc+2] = PRODUCT( data_mask[*,*,z_decay,cc], 3 )
endfor

;c83_map = map
;m73_map = map
x22_map = map

print, max(c83_map)
print, max(m73_map)
print, max(x22_map)


;== IMAGE powermaps

time = strmid(A.time,0,5)
;
title = strarr(4)
title[0] = strupcase(instr) + ' ' + A.channel + '$\AA$ ' + time[z_imp[0]] + '-' + time[z_imp[-1]]
title[2] = strupcase(instr) + ' ' + A.channel + '$\AA$ ' + time[z_decay[0]] + '-' + time[z_decay[-1]]
for ii = 0, 3 do print, title[ii]

imdata = alog10( c83_map )
;
dw
im = IMAGE3( $
    imdata, $
    rows=2, cols=2, $
    top = 0.5, $
    bottom = 0.75, $
    left = 0.75, $
    xgap = 0.50, $
    ygap = 0.50, $
    title=title, $
    buffer=buffer $
)
;
im[0].rgb_table = AIA_GCT( wave=fix(A[0].channel))
im[1].rgb_table = AIA_GCT( wave=fix(A[1].channel))
im[2].rgb_table = AIA_GCT( wave=fix(A[0].channel))
im[3].rgb_table = AIA_GCT( wave=fix(A[1].channel))
;
im[2].xtitle = 'X (pixels)'
im[2].ytitle = 'Y (pixels)'
;
image_filename = class + '_' + instr + '_MAP'
print, image_filename
stop
save2,  image_filename


end
