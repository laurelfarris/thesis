;+
;- 28 May 2021
;-


;+
;- TO DO:
;-  [] save X2.2 powermap and header to .tar.gz file and send to Sean
;-      (same thing I did with c83_20130830.... ALMOST THREE MONTHS AGO!!)
;-
;- Old to-do's from previous "today.pro" (April 06...)
;-  [] interpolate to fill in missing 1700 images, save final cube + index (prob not shifts)
;-  [] Clean up code, write module, move to ./Align/ with GOOD DOCUMENTATION!
;-         ==>>  comments, update README, etc.
;-

buffer = 1
;@par2

;- C8.3 2013-08-30 T~02:04:00
;- M1.0 2014-11-07 T~10:13:00
;- M1.5 2013-08-12 T~10:21:00

;-
;flare = multiflare.C83
;flare = multiflare.M10
;flare = multiflare.M15
;flare = multiflare.X22
;-


instr = 'aia'
;channel = 1600
channel = 1700

date = '20110215'
class = 'x22'

path = '/solarstorm/laurel07/flares/' + class + '_' + date + '/'
filename = class + '_' + strlowcase(instr) + strtrim(channel,1) + 'powermap.sav'

print, file_exist(path + filename)
stop

restore, path + filename

;if channel eq 1600 then x22_aia1600powermap = map
if channel eq 1700 then x22_aia1700powermap = map

help, x22_aia1600powermap
help, x22_aia1700powermap


save, x22_aia1600powermap, filename='x22_aia1600powermap.sav'
save, x22_aia1700powermap, filename='x22_aia1700powermap.sav'

stop
;



;- restore INDEX from fits files (see ./Prep/struc_aia.pro)

READ_MY_FITS, x22_aia1600header, instr=instr, channel=1600, nodata=1, prepped=1
help, x22_aia1600header

READ_MY_FITS, x22_aia1700header, instr=instr, channel=1700, nodata=1, prepped=1
help, x22_aia1700header


save, x22_aia1600header, filename='x22_aia1600header.sav'
save, x22_aia1700header, filename='x22_aia1700header.sav'


;-
;- What I did:
;-  restored .sav files, created new variable name to replace "map", then saved to
;-  exact same file... no changes at all except variable name of powermap cube, unless
;-  "map" is not the only variable saved to the original .sav files.

end
