;+
;- ?? April 2021
;-


;+
;- TO DO:
;-  [] Finish alignment
;-  [] Clean up code, write module, move to ./Align/ with GOOD DOCUMENTATION!
;-         ==>>  comments, update README, etc. ...
;-  [] interpolate to fill in missing 1700 images, save final cube + index (prob not shifts)
;-
;-  [] SCIENCE!!!  ==>>  compute powermaps
;-
;___________________________________________________
;- IDL fun times --> Enote
;-
; Time in seconds since 1 January 1970
;mtime = FILE_MODTIME(FILEPATH('dist.pro', SUBDIR = 'lib'))
mtime = FILE_MODTIME('today.pro')
print, mtime
;
; Convert to a date/time string
PRINT, SYSTIME(0, mtime)
;___________________________________________________


@par2

;- C8.3 2013-08-30 T~02:04:00  (1)
;- M1.5 2013-08-30 T~02:04:00  (1)

;flare_index = 1  ; C8.3
;flare = multiflare.(flare_index)
;-
;- OR, since flare_index is not used anywhere else, just use the TAGNAME:
;flare = multiflare.C83
flare = multiflare.M15
;-

buffer = 1
;
instr = 'aia'
channel = 1600
;channel = 1700
;
date = flare.year + flare.month + flare.day
print, date
;
class = strsplit(flare.class, '.', /extract)
class = strlowcase(class[0] + class[1])
print, class
;
path = '/solarstorm/laurel07/flares/' + class + '_' + date + '/'
;filename = class + '_' + date + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
filename = class + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
;print, file_exist(path + filename)
;
restore, path + filename

;- confirm channel is what I want it to be.
;print, index[0].wavelnth

STOP


end
