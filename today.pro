;+
;- LAST MODIFIED:
;-   31 May 2024
;-     (Originally 27 Dec 2023, itself copied, at least partially, from  Oct. 2022 from test.pro)
;- TO DO:
;-   [] refer to notes/2023-12-27.pro or any notes from Oct. 2022 test.pro that may exist, 
;-      if needed (I'm deleting most of thge leftovers so I can have a clean code file to work with).
;-
;- 12 December 2023
;-   Another "today.pro" up one directory from here,
;-    last modified 2019-05-10 ...

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


;- Run script "main.pro" to define buffer=1, instr='aia', cadence=24, and
;-    define flare structure for desired event
;@main

; display current nesting of procedures and functions (found in shift_ydata.pro 09 Aug 2022)
;help, /traceback




print, 3600.0 / (4.0*sqrt(2))
print, (3600.0 / (4.0*sqrt(2))) / 60.0

print, 3600.0 / (3.0*sqrt(2))
print, 3600.0 / (3.0*sqrt(2)) / 60.0

stop


;========================================================================================================

;-
;- Wavelet plots maybe??
;-
;- First, do this from IDL> cmd line:
;-   IDL> .run main_filter
;- so far so good...


;-
;- IDL> @main
;-       -- define flare of choice & restore 'A' strucure variables from .sav files
;- IDL> .run main_filter
;-       -- define cutoff period, input time series


    for ii = 0, 8 do begin
        NN = 2^ii
        duration = cadence * NN
        print, ii, NN, fix(duration), fix(duration/60.0)
    ;    print, ii, round(duration)
    ;    print, ii, round( 2^(float(ii)))
    ;    print, ii, 2.0^ii
    endfor

    print, 1000. * (1./(64*24))

    nuc = 5.6
    nu = 5.4
    res = 0.65
    dnu = 1.0
    ;
    print, ''
    print, nuc - (dnu/2), nuc + (dnu/2)
    print, nu-res, nu+res
    print, ''



end
