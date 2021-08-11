;+
;- 09 July 2021
;-
;- TO DO:
;-   [] Finish GOES lightcurves
;-
;- C8.3 2013-08-30 T~02:04:00
;- M1.0 2014-11-07 T~10:13:00
;- M1.5 2013-08-12 T~10:21:00
;-


;- Need to rename varialbe saved in these files for C8.3 flare...
restore, '../flares/c83_20130830/c83_aia1700header.sav'
index = c83_aia1700header
help, index

save, index, filename='c83_aia1700header.sav'


buffer = 1
@par2
;
flare = multiflare.c83

print, flare.class
class = strlowcase((flare.class).Replace('.',''))
print, class










end
