
;===========================================================================================
;= NOTE:
;=   Copied from "today.pro" on 18 July 2022 after many edits were made...
;=   Edits from May vs. July may be unclear, but better late than never..
;=
;===========================================================================================


;+
;- 26 April 2022
;-
;- 10 May 2022
;-   Started computing pre-flare powermaps,
;-      trying to reproduce "well-known" chromospheric 3mOs in intensity...
;-
;- 18 July 2022
;-   ...
;-
;- TO DO:
;-
;- 18 July 2022
;-   [] Replace 'savefile' with different variable name.. sounds like saving variables to some file.sav,
;-      not saving a graphic to a pdf file!
;-
;-   [] copy new stuff in a2.pro back in here and delete a2.pro
;-
;-   [] Clean up code, write module, move to ./Align/ with GOOD DOCUMENTATION!
;-         ==>>  comments, update README, etc.
;-
;-
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
;-      -
;-      -
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
;-  [] see @Lit for tons of ideas
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
;-   [] FIRST: ensure HEADERS (index) and aligned data subsets (data) are saved in .sav file
;-        for each flare. Can be same file or separate, just needs to be CONSISTENT.
;-      RESTORE .sav files, save headers / data in one file, easy to resotre in future.
;-   [] AIA & GOES  LCs during flare only, dt covered by RHESSI (for CORRECT flares)
;-   [] Detrended LCs showing QPPs
;-   [] Power maps (see "today.pro")
;-   [] FFTs -> power spectra showing power as function of freqeunciews between ~1 and 20 mHz (or w/e)
;-       to compare BDA for individual flares, or same phase for different flares in one plot
;-       (first one then the other... comparing flares to each other is followup / discussion section)
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
;-
;-
;- Other flares:
;-   M1.0 2014-11-07 T~10:13:00
;-   M1.5 2013-08-12 T~10:21:00
;-


;- Need to rename variable saved in these files for C8.3 flare...
;restore, '../flares/c83_20130830/c83_aia1700header.sav'
;index = c83_aia1700header
;help, index
;save, index, filename='c83_aia1700header.sav'

;path='/home/astrobackup3/preupgradebackups/solarstorm/laurel07/'
;path='/solarstorm/laurel07/'
;testfiles = 'Data/HMI_prepped/*20140418*.fits'
;if not file_test(path + testfiles) then print, 'files not found'


;=====================================================================================================
; a2.pro

; What .sav files currently exist for each flare?
; '../flares/c83_20140418/*.sav'
; c83_aia1600aligned.sav
; c83_aia1700aligned.sav
; c83_aia1600header.sav
; c83_aia1700header.sav

; '../flares/m73_20140418/*.sav'
; '../flares/x22_20140418/*.sav'

; restore, '.../.sav'



; IDL> .run par2

@path_temp
buffer = 1
instr = 'aia'

;=== Use sav_files.pro to do all this! ================================================================

;- Loop through channels (eventually... need way to store variables after each iteration.)
;channel = ['1600', '1700']
;foreach cc, channel, ii do begin
;    restore, '../flares/' + class + '/' + class + '_' + instr + channel[ii] + 'cube.sav'
;    restore, '../flares/' + class + '/' + class + '_' + instr + channel[ii] + 'header.sav'
;endforeach


channel = '1600'
restore, '../flares/' + class + '/' + class + '_aia' + channel + 'cube.sav'
restore, '../flares/' + class + '/' + class + '_aia' + channel + 'header.sav'
aia1600index = index
aia1600cube = cube
print, index[0].wavelnth


channel = '1700'
restore, '../flares/' + class + '/' + class + '_aia' + channel + 'cube.sav'
restore, '../flares/' + class + '/' + class + '_aia' + channel + 'header.sav'
help, index
help, cube
print, index[0].wavelnth

aia1700index = index
aia1700cube = cube
;
undefine, cube
undefine, index



;=====================================================================================================

; 18 July 2022
;   Image at flare start time


z_start = (where( strmid(A[0].time, 0, 5 ) eq flare.tstart ))[0]

imdata = A.data[*,*, z_start ,*]
imdata = AIA_INTSCALE( A.data[*,*,z_ind], wave=channel, exptime=index[z_ind].exptime )

im = image2( $
    imdata
)



dw
im = image2( $
    imdata, $
    rgb_table = AIA_GCT( wave=fix(channel)), $
    buffer=buffer $
)


;=====================================================================================================


; Compute Powermap from pre-flare data

z_ind = (where( strmid(index.date_obs, 11, 5 ) EQ flare.tstart ))[0]
;  [] Need faster way to retrieve z-index of flare.tstart
print, z_ind
; NOTE: M7.3 flare has ~2.5 hours of pre-flare data..

help, cube
cube = CROP_DATA(cube)
help, cube
; [] crops to 500 x 330 by default... is this okay for M7.3 flare?

; Check for missing images
;   -> see ./Maps/compute_powermaps_main.pro

; syntax (refernce)
map = COMPUTE_POWERMAPS( /syntax )


map      = COMPUTE_POWERMAPS( cube[*,*,0:z_ind], cadence        )
map_norm = COMPUTE_POWERMAPS( cube[*,*,0:z_ind], cadence, /norm )


;print, min(map), max(map)
;print, min(map_norm), max(map_norm)

; Image INTENSITY (context)
imdata = AIA_INTSCALE( cube[*,*,z_ind], wave=channel, exptime=index[z_ind].exptime )
;print, index[0].exptime
;print, index[z_ind].exptime

; Image map

;imdata = alog10(map)
;imdata = map_norm

;print, min(cube[*,*,z_ind]), max(cube[*,*,z_ind])
;print, min(imdata), max(imdata)


dw
im = image2( $
    imdata, $
    rgb_table = AIA_GCT( wave=fix(channel)), $
    buffer=buffer $
)

;
; Chage axis labels from pixels to arcsec
im.xtickname = string( fix(im.xtickvalues * index[0].cdelt1 ))
im.ytickname = string( fix(im.ytickvalues * index[0].cdelt2 ))
im.xtitle = 'X (arcsec)'
im.ytitle = 'Y (arcsec)'
;
;- Intensity image title
im.title = strupcase(instr) + ' ' + strtrim(channel,1) + "$\AA$ " + strmid(index[z_ind].date_obs,11,8) + ' UT'
;
savefile = class + '_' + instr + strtrim(channel,1) + 'intensity'
save2, savefile



;- Maps
im.title = strupcase(instr) + ' ' + strtrim(channel,1) + "$\AA$ " + $
    flare.date + $
    ' (' + strmid(index[0].date_obs,11,5) + '-' + strmid(index[z_ind].date_obs,11,5) + ')'



; Save image to pdf file
savefile = class + '_' + instr + strtrim(channel,1) + 'map_preflare'
save2, savefile

; save NORMALIZED map..
savefile_norm = class + '_' + instr + strtrim(channel,1) + 'map_preflare_norm'
save2, savefile_norm





; PLAN for completing A2 / Chapter 5: "Multi-flare"
;=====================================================================================================================
;- 27 April 2022
;-   Everything from here to EOF copied from 'tomorrow_powermaps.pro'
;=====================================================================================================================

; [] path_temp.pro
;      Is this referenced or used somehow?
; [] use 'main.pro' or something similar to define common ML variables that change too often to be in common
;    block from startup files that I never look at.
; [] Merge _README.pro with other references (i.e. aia_hmi_fits_filenames.pro, ToDo.pro, etc.)

;-
;- 05->06 April 2021
;-
;- TO DO:
;-  [] re-align images
;-       • interpolate
;-       • align in pieces
;-       • use subset outside flare to compute alignment for all pixels
;-  [] interpolate to fill in missing 1700 images
;-  [] compute powermaps
;-


;- IDL fun times --> Enote
;-
; Time in seconds since 1 January 1970
;mtime = FILE_MODTIME(FILEPATH('dist.pro', SUBDIR = 'lib'))
mtime = FILE_MODTIME('today.pro')
print, mtime
;
; Convert to a date/time string
PRINT, SYSTIME(0, mtime)




STOP

;----------------------------

;- Active Variables :
;-  index, cube, allshifts, ref, 
;-




;==================================================================================



c83_aia1700header = index

headersavfile = class + '_aia' + strtrim(channel,1) + 'header.sav'
print, headersavfile
;save, c83_aia1700header, filename = headersavfile



;----

path = './c83_20130830/'
mapfile = 'c83_aia' + strtrim(channel,1) + 'map.sav'
print, path + mapfile
;

restore, path + mapfile
help, map
print, max(map)

c83_aia1700powermap = map
help, c83_aia1700powermap

print, max(c83_aia1700powermap)

save, c83_aia1700powermap, filename = mapfile


;
;==================================================================================

channel = 1600
;channel = 1700

;
path = './c83_20130830/'

headerfile = 'c83_aia' + strtrim(channel,1) + 'header.sav'

mapfile = 'c83_aia' + strtrim(channel,1) + 'powermap.sav'
;
restore, path + headerfile

help, c83_aia1700header


restore, '../flares/c83_20130830/20130830_aia' + strtrim(channel,1) + 'cube.sav'
help, index

print, index[0].wavelnth

c83_aia1600header = index
help, c83_aia1600header

save, c83_aia1600header, filename=headerfile

;===========

;channel = '1600'
channel = '1700'
;
headerfile = 'c83_aia' + channel + 'header.sav'
mapfile = 'c83_aia' + channel + 'powermap.sav'
path = './c83_20130830/'


help, c83_aia1600header
help, c83_aia1700header
help, c83_aia1600powermap
help, c83_aia1700powermap

restore, path + headerfile
restore, path + mapfile


undefine, c83_aia1600header
undefine, c83_aia1600powermap

stop


;------
basename = FILE_BASENAME(filename, '.sav')
;
filename2 = basename + '_OLD.sav'
filename3 = basename + '_OLD_2.sav'
;
print, filename
print, filename2
print, filename3
;------




;- temporary cube to preserve ALIGNED cube
cube2 = cube

filename = date + '_' + strlowcase(instr) + strtrim(channel,1) + 'cube.sav'
restore, path + filename

;- confirm that cube and cube2 are not the same anymore, cube restored from
;-    cube.sav files is same size, but pre-alignment.
print, cube[0,0,0]
print, cube2[0,0,0]

;- return ALIGNED cube values to cube variable and get rid of backup.
cube = cube2
undefine, cube2


filename = date + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
save, index, cube, allshifts, filename=filename


stop;--------------------------------------------------------------------------

;- new idl session, restore .sav file I just made and make sure all variables are there
filename = date + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
restore, filename
help, cube
help, index
help, allshifts




;
cadence = 24
dz = 64
;
oldcube = cube
cube = crop_data( oldcube, dimensions=[400,400], center=[ 400, 400 ] )
help, cube

undefine, oldcube

;
;print, array_equal( index.exptime, index[0].exptime )
;
;print, where( index.exptime le 2.90 )
;print, where( index.exptime ge 2.91 )
;-  -1 in both cases (04 March 2021)
;exptime = 1.0
exptime = index[0].exptime
;print, exptime
;
sz = size(cube, /dimensions)
;
;satlocs = where( index.nsatpix gt 0 )
;print, index[satlocs].nsatpix
;
;
time = strmid(index.date_obs, 11, 8)
;print, time[0]


;============================================================

;-
z_start = [0:sz[2]-dz]
;-  indices for full ts

;- indices to compute power map from time series of length dz, starting at flare start.
;z_start = (where( strmid(index.date_obs,11,5) eq flare.tstart ))[0]

print, z_start[-1]
print, z_start[-1] + dz -1

;print, index[z_start].date_obs
print, flare.tstart
print, index[z_start[-1]+dz-1].date_obs
print, flare.tend

;aia_lct, rr, gg, bb, wavelnth=channel, /load
;rgb_table=AIA_GCT( wave=channel )
;
;dw
;imdata = cube[*,*,z_start]

;z_peak = (where( strmid(index.date_obs,11,5) eq flare.tpeak ))[0]
;print, z_start
;print, z_peak


STOP


;====
;print,  COMPUTE_POWERMAPS( /syntax )
map = COMPUTE_POWERMAPS( cube/exptime, cadence, dz=dz, z_start=z_start )
save, map, filename='1700map.sav'
;-  started 23:58 04 March (Eastern time) for 1600Å, 2:52 05 March for 1700Å
;-    Only put in "save" command for the latter... hopefully won't crash
;-    before I get a chance to save 1600 map..
;====


print, '===---'
;
start_time = systime(/seconds)
wait, 5.5
minutes = (systime(/seconds) - start_time)/60
hours = (systime(/seconds) - start_time)/3660
format='( "Power maps calculated in ~", F0.2, " minutes (", F0.4, " hours)" )'
print, format=format, minutes, hours
;print, format='( "Power maps calculated in ~", F0.2, " minutes (", F0.4, " hours)" )', minutes, hours
;print, format='( "    (", F0.4, " hours)." )', hours
;
print, '===---'


;+
;- IMAGE power maps
;-

impulsive_phase = (where( strmid(time,0,5) eq flare.tpeak ))[0] - dz
decay_phase = impulsive_phase + dz

;before = impulsive_phase - 
before = (where( strmid(time,0,5) eq flare.tstart ))[0] - dz
print, time[before]


z_ind = [ $
    (where( strmid(time,0,5) eq flare.tpeak ))[0] $
]
print, z_ind
print, time[z_ind]
print, flare.tpeak

imdata = [ $
    [[ AIA_INTSCALE( cube[*,*,z_peak], wave=channel, exptime=exptime ) ]], $
    [[ AIA_INTSCALE( map, wave=channel, exptime=exptime ) ]] $
]



title = flare.class + '  ' + flare.year + '-' + flare.month + '-' + flare.day + '  '  $
    + [ time[z_peak]+ ' (intensity) ' , time[z_start] + '-' + time[z_start+dz-1] + ' (power map)' ]
;

dw
wx = 8.5
wy = wx/2
win=window( dimensions=[wx,wy]*dpi, buffer=buffer )
im = objarr(2)
for ii = 0, 1 do begin
    im[ii] = image2( $
        imdata[*,*,ii], $
        /current, $
        layout=[2,1,ii+1], $
        margin=0.10, $
        title=title[ii], $
        rgb_table=rgb_table, $
        buffer=buffer $
    )
endfor
save2, 'test'


stop;---------------------

;save, map, map2, filename='M10_aia1600map.sav'
;save, map, filename='M10_aia1600map.sav'

filename = class + '_' + date + '_' + strlowcase(instr) + strtrim(channel,1)  + 'map.sav'
print, filename

save, map, filename=filename


;-
;==
;============================================================================================


print, max(cube2) / (max( cube2/exptime) )
print, ( max(cube2) / (max( cube2/exptime) ) )^2

print, exptime^2

print, max(map) / max(map2)
;print, min(map) / min(map2)
;-  same factor whether min or max or in between, just like every pixel
;-   in data cubes differes
;-  by factor = exptime ... because one was divided by exptime... der.


;- ===>>>  NO LONGER setting threshold. Compute power for ALL pixels,
;-   Can easily compute MASK using threshold and original pixel values
;-    (where "original" pixel values are the ones used to compute the map
;-   in the first place).

maps = [ [[map]], [[map2]] ]

undefine, map
undefine, map2
   ;-  don't like these variable names anyway; espeically confusing when
   ;-   concurrent with "cube" and "cube2", but DO NOT correspond to each
   ;-  other AT ALL.


title = [ 'raw data', 'exptime-corrected' ]
;
im = objarr(2)
dw
win = window(/buffer)

imdata = maps
locs = where( imdata gt 950 and imdata lt 1000 )

help, array_indices( imdata, locs )
print, imdata[(array_indices( imdata, locs ))[*,0]]

print, imdata[ 228, 139, 0]

print, ''
print, min(imdata[*,*,0]), format=format
print, min(imdata[*,*,1]), format=format
print, max(imdata[*,*,0]), format=format
print, max(imdata[*,*,1]), format=format
print, ''
;

imdata = AIA_INTSCALE(maps, exptime=exptime, wave=channel )
print, imdata[ 228, 139, 0]

print, min(imdata[*,*,0]), format=format
print, min(imdata[*,*,1]), format=format
print, max(imdata[*,*,0]), format=format
print, max(imdata[*,*,1]), format=format
print, ''

for ii = 0, 1 do begin
    im[ii] = IMAGE2( $
        imdata[*,*,ii], $
        /current, $
        layout=[2, 1, ii+1], $
        margin=0.05, $
        title=title[ii], $
        rgb_table=rgb_table, $
        /buffer $
    )
endfor
;
save2, 'M10_aia1600map', /timestamp


print, ''
format='(e0.4)'
for ii = 0, 1 do begin
    print, min(maps[*,*,ii]), max(maps[*,*,ii]), format=format
    print, ''
endfor
print, ''


end
